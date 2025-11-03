import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:flutter_travels_apps/data/models/map_location.dart';
import 'package:flutter_travels_apps/data/mock/map_locations.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_travels_apps/services/trip_plan_service.dart';
import 'package:flutter_travels_apps/data/models/trip_activity_model.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map_screen';

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  VietmapController? _mapController;
  MapLocation? _selectedLocation;
  List<MapLocation> _locations = [];
  List<MapLocation> _filteredLocations = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  MapLocation? _currentLocation;
  bool _isLoading = true;
  final List<Symbol> _markers = [];
  final Map<String, MapLocation> _symbolIdToLocation = {};
  Line? _routeLine;
  final Set<String> _favoriteIds = <String>{};

  // Các chức năng mới
  final List<MapLocation> _routeWaypoints = []; // Điểm dừng trong route
  String _selectedMapStyle = 'standard'; // standard, satellite, terrain
  final List<String> _recentSearches = [];
  String? _selectedTripPlanId;
  List<TripActivityModel> _tripActivities = [];
  final TripPlanService _tripPlanService = TripPlanService();

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _loadFavorites();
    _loadRecentSearches();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
      _onSearchChanged(_searchController.text);
    });
  }

  void _loadLocations() {
    setState(() {
      _locations = MapLocationsData.locations;
      _filteredLocations = _locations;
      _currentLocation = MapLocationsData.defaultLocation;
      _isLoading = false;
    });
  }

  void _onMapCreated(VietmapController controller) {
    _mapController = controller;

    // Di chuyển camera đến vị trí mặc định
    if (_currentLocation != null) {
      Future.delayed(Duration(milliseconds: 300), () {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
            13.0,
          ),
        );
      });
    }

    // Lắng nghe tap vào symbol
    _mapController!.onSymbolTapped.add((symbol) {
      final loc = _symbolIdToLocation[symbol.id];
      if (loc != null && mounted) {
        setState(() => _selectedLocation = loc);
        _moveToLocation(loc);
      }
    });

    // Thêm markers sau khi map đã sẵn sàng
    // Đợi một chút để đảm bảo style đã load xong
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && _mapController != null) {
        _addMarkers();
      }
    });
  }

  void _addMarkers() {
    if (_mapController == null || !mounted) return;

    // Xóa markers cũ nếu có
    for (var marker in _markers) {
      try {
        _mapController!.removeSymbol(marker);
      } catch (e) {
        // Ignore errors khi remove
      }
    }
    _markers.clear();
    _symbolIdToLocation.clear();

    // Thêm markers cho filtered locations hoặc tất cả locations
    final locationsToShow =
        _filteredLocations.isNotEmpty && _searchQuery.isNotEmpty
        ? _filteredLocations
        : _locations;

    // Thêm markers mới
    for (var location in locationsToShow) {
      // Thử dùng text field trực tiếp vì icon có thể không load được
      try {
        _mapController!
            .addSymbol(
              SymbolOptions(
                geometry: LatLng(location.latitude, location.longitude),
                textField: location.type == 'hotel' ? '🏨' : '📍',
                textSize: 24.0,
                textColor: location.type == 'hotel'
                    ? Colors
                          .red // Màu đỏ cho khách sạn
                    : Colors.teal, // Màu xanh cho điểm đến
                textOffset: Offset(0, -2),
              ),
            )
            .then((symbol) {
              if (mounted && _mapController != null) {
                setState(() {
                  _markers.add(symbol);
                  _symbolIdToLocation[symbol.id] = location;
                });
              }
            })
            .catchError((error) {
              // Nếu text field không hoạt động, thử icon
              _tryAddMarkerWithIcon(location);
            });
      } catch (e) {
        // Fallback: thử với icon
        _tryAddMarkerWithIcon(location);
      }
    }
  }

  void _tryAddMarkerWithIcon(MapLocation location) {
    if (_mapController == null || !mounted) return;

    try {
      _mapController!
          .addSymbol(
            SymbolOptions(
              geometry: LatLng(location.latitude, location.longitude),
              iconImage: location.type == 'hotel'
                  ? 'marker-hotel'
                  : 'marker-destination',
              iconSize: location.type == 'hotel' ? 1.5 : 1.0,
            ),
          )
          .then((symbol) {
            if (mounted && _mapController != null) {
              setState(() {
                _markers.add(symbol);
                _symbolIdToLocation[symbol.id] = location;
              });
            }
          })
          .catchError((_) {
            // Ignore nếu cả icon cũng không hoạt động
          });
    } catch (e) {
      // Ignore errors
    }
  }

  void _onMapClick(dynamic point, LatLng latLng) {
    setState(() {
      _selectedLocation = null;
    });
  }

  void _moveToLocation(MapLocation location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location.latitude, location.longitude),
        15.0,
      ),
    );
  }

  double _degToRad(double deg) => deg * 3.1415926535 / 180.0;

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a =
        (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        (math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2));
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  Future<void> _ensureLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      return;
    }
  }

  Future<void> _focusMyLocation() async {
    await _ensureLocationPermission();
    if (_currentLocation != null) {
      _moveToLocation(_currentLocation!);
    }
  }

  Future<void> _openExternalNavigation(MapLocation location) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}&travelmode=driving',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _drawRouteTo(MapLocation location) async {
    if (_mapController == null || _currentLocation == null) return;

    // Tạo route với tất cả waypoints
    List<LatLng> points = [];

    // Điểm bắt đầu
    if (_currentLocation != null) {
      points.add(
        LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      );
    }

    // Các điểm dừng
    for (var waypoint in _routeWaypoints) {
      points.add(LatLng(waypoint.latitude, waypoint.longitude));
    }

    // Điểm đích
    points.add(LatLng(location.latitude, location.longitude));

    if (_routeLine == null) {
      _routeLine = await _mapController!.addPolyline(
        PolylineOptions(
          polylineColor: Colors.blue,
          polylineWidth: 4.0,
          geometry: points,
        ),
      );
    } else {
      await _mapController!.updatePolyline(
        _routeLine!,
        PolylineOptions(geometry: points),
      );
    }

    // Fit camera để hiển thị toàn bộ route
    if (points.isNotEmpty && points.length >= 2) {
      double minLat = points[0].latitude;
      double maxLat = points[0].latitude;
      double minLon = points[0].longitude;
      double maxLon = points[0].longitude;

      for (var point in points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLon) minLon = point.longitude;
        if (point.longitude > maxLon) maxLon = point.longitude;
      }

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng((minLat + maxLat) / 2, (minLon + maxLon) / 2),
          11.0,
        ),
      );
    }
  }

  // Thêm điểm dừng vào route
  void _addWaypoint(MapLocation location) {
    if (!_routeWaypoints.any((wp) => wp.id == location.id)) {
      setState(() {
        _routeWaypoints.add(location);
      });
      if (_selectedLocation != null) {
        _drawRouteTo(_selectedLocation!);
      }
    }
  }

  // Xóa điểm dừng
  void _removeWaypoint(MapLocation location) {
    setState(() {
      _routeWaypoints.removeWhere((wp) => wp.id == location.id);
    });
    if (_selectedLocation != null) {
      _drawRouteTo(_selectedLocation!);
    }
  }

  // Xóa toàn bộ route
  void _clearRoute() {
    setState(() {
      _routeWaypoints.clear();
      _selectedLocation = null;
    });
    if (_routeLine != null && _mapController != null) {
      try {
        _mapController!.removePolyline(_routeLine!);
        _routeLine = null;
      } catch (e) {
        // Ignore
      }
    }
  }

  // Chuyển đổi map style
  void _changeMapStyle(String style) {
    if (_mapController == null) return;

    setState(() {
      _selectedMapStyle = style;
    });

    // Lưu style preference
    LocalStorageHelper.setValue('map_style', style);

    // Note: Vietmap có thể không hỗ trợ thay đổi style runtime
    // Có thể cần reload map với style mới
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã chọn kiểu bản đồ: ${style == 'satellite'
              ? 'Vệ tinh'
              : style == 'terrain'
              ? 'Địa hình'
              : 'Tiêu chuẩn'}',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Load trip activities và hiển thị trên map
  Future<void> _loadTripActivities(String tripPlanId) async {
    try {
      final activitiesStream = _tripPlanService.getAllActivitiesStream(
        tripPlanId,
      );
      activitiesStream.listen((activitiesByDay) {
        setState(() {
          _tripActivities.clear();
          activitiesByDay.values.forEach((activities) {
            _tripActivities.addAll(activities);
          });
        });
        _addTripActivityMarkers();
      });
    } catch (e) {
      debugPrint('Lỗi load trip activities: $e');
    }
  }

  // Thêm markers cho trip activities
  void _addTripActivityMarkers() {
    // Lọc các activities có locationId hoặc locationName
    final activitiesWithLocation = _tripActivities.where((activity) {
      return activity.locationId != null || activity.locationName != null;
    }).toList();

    // Tìm locations tương ứng và thêm markers
    for (var activity in activitiesWithLocation) {
      if (activity.locationId != null) {
        final location = _locations.firstWhere(
          (loc) => loc.id == activity.locationId,
          orElse: () => MapLocation(
            id: activity.locationId!,
            name: activity.locationName ?? activity.title,
            description: activity.description,
            latitude: _currentLocation?.latitude ?? 21.0285,
            longitude: _currentLocation?.longitude ?? 105.8542,
            type: 'destination',
          ),
        );

        // Thêm marker đặc biệt cho trip activity
        if (_mapController != null) {
          _mapController!
              .addSymbol(
                SymbolOptions(
                  geometry: LatLng(location.latitude, location.longitude),
                  textField: '📅',
                  textSize: 20.0,
                  textColor: Colors.purple,
                ),
              )
              .then((symbol) {
                if (mounted) {
                  setState(() {
                    _markers.add(symbol);
                  });
                }
              });
        }
      }
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Fallback: đọc local để không mất dữ liệu người dùng ẩn danh
        final List<dynamic> local =
            (LocalStorageHelper.getValue('favorite_locations')
                as List<dynamic>?) ??
            [];
        _favoriteIds
          ..clear()
          ..addAll(local.map((e) => e.toString()));
        setState(() {});
        return;
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final List<dynamic> remote =
          (doc.data()?['favoritePlaceIds'] as List<dynamic>?) ?? [];
      _favoriteIds
        ..clear()
        ..addAll(remote.map((e) => e.toString()));
      setState(() {});
    } catch (_) {}
  }

  Future<void> _toggleFavorite(MapLocation location) async {
    final String id = location.id;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Fallback: lưu local nếu chưa đăng nhập
      final key = 'favorite_locations';
      final List<dynamic> current =
          (LocalStorageHelper.getValue(key) as List<dynamic>?) ?? [];
      if (current.contains(id)) {
        current.remove(id);
        _favoriteIds.remove(id);
      } else {
        current.add(id);
        _favoriteIds.add(id);
      }
      LocalStorageHelper.setValue(key, current);
      setState(() {});
      return;
    }

    try {
      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
      if (_favoriteIds.contains(id)) {
        await ref.update({
          'favoritePlaceIds': FieldValue.arrayRemove([id]),
        });
        _favoriteIds.remove(id);
      } else {
        await ref.update({
          'favoritePlaceIds': FieldValue.arrayUnion([id]),
        });
        _favoriteIds.add(id);
      }
      setState(() {});
    } catch (_) {}
  }

  bool _isFavorite(MapLocation location) {
    return _favoriteIds.contains(location.id);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredLocations = _locations;
      } else {
        _filteredLocations = _locations.where((location) {
          return location.name.toLowerCase().contains(query.toLowerCase()) ||
              location.description.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              (location.address?.toLowerCase().contains(query.toLowerCase()) ??
                  false);
        }).toList();
      }
    });

    // Lưu vào recent searches nếu query không rỗng
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      _addToRecentSearches(query);
    }
  }

  void _loadRecentSearches() {
    final List<dynamic> recent =
        (LocalStorageHelper.getValue('map_recent_searches')
            as List<dynamic>?) ??
        [];
    _recentSearches.clear();
    _recentSearches.addAll(
      recent.map((e) => e.toString()).take(10),
    ); // Chỉ lấy 10 gần nhất
  }

  void _addToRecentSearches(String query) {
    if (_recentSearches.contains(query)) {
      _recentSearches.remove(query);
    }
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) {
      _recentSearches.removeLast();
    }
    LocalStorageHelper.setValue('map_recent_searches', _recentSearches);
  }

  void _focusOnLocation(MapLocation location) {
    setState(() {
      _selectedLocation = location;
      _searchQuery = '';
      _filteredLocations = _locations;
    });
    _moveToLocation(location);
  }

  Widget _buildMap() {
    // API key cho Vietmap
    const String vietmapApiKey =
        '506862bb03a3d71632bdeb7674a3625328cb7e5a9b011841';
    // URL style đúng format cho Vietmap
    final String styleUrl =
        'https://maps.vietmap.vn/maps/styles/tm/tiles.json?apikey=$vietmapApiKey';

    return SizedBox.expand(
      child: VietmapGL(
        styleString: styleUrl,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentLocation?.latitude ?? 21.0285,
            _currentLocation?.longitude ?? 105.8542,
          ),
          zoom: 13.0,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: () {
          // Đảm bảo map đã load style trước khi add markers
          if (_mapController != null) {
            _addMarkers();
          }
        },
        onMapClick: _onMapClick,
        onUserLocationUpdated: (userLoc) {
          if (mounted) {
            setState(() {
              _currentLocation = MapLocation(
                id: 'me',
                name: 'Vị trí của tôi',
                description: 'Vị trí hiện tại',
                latitude: userLoc.position.latitude,
                longitude: userLoc.position.longitude,
              );
            });
          }
        },
        myLocationEnabled: true,
        compassEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        zoomGesturesEnabled: true,
      ),
    );
  }

  Widget _buildLocationInfoCard(MapLocation location) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultPadding),
      ),
      child: InkWell(
        onTap: () {
          // Có thể navigate đến detail screen
        },
        borderRadius: BorderRadius.circular(kDefaultPadding),
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      location.name,
                      style: TextStyles.defaultStyle.fontHeader.bold,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Yêu thích',
                    onPressed: () => _toggleFavorite(location),
                    icon: Icon(
                      _isFavorite(location)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.pink,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() => _selectedLocation = null);
                    },
                  ),
                ],
              ),
              SizedBox(height: kItemPadding),
              if (location.address != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: kDefaultIconSize,
                      color: ColorPalette.subTitleColor,
                    ),
                    SizedBox(width: kMinPadding),
                    Expanded(
                      child: Text(
                        location.address!,
                        style: TextStyles.defaultStyle.subTitleTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kItemPadding),
              ],
              Text(
                location.description,
                style: TextStyles.defaultStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (location.rating != null) ...[
                SizedBox(height: kItemPadding),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: kDefaultIconSize,
                      color: Colors.amber,
                    ),
                    SizedBox(width: kMinPadding),
                    Text(
                      '${location.rating}',
                      style: TextStyles.defaultStyle.bold,
                    ),
                    if (location.reviewCount != null) ...[
                      SizedBox(width: kMinPadding),
                      Text(
                        '(${location.reviewCount} đánh giá)',
                        style: TextStyles
                            .defaultStyle
                            .fontCaption
                            .subTitleTextColor,
                      ),
                    ],
                  ],
                ),
              ],
              SizedBox(height: kItemPadding),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openExternalNavigation(location),
                      icon: Icon(Icons.directions),
                      label: Text('Chỉ đường'),
                    ),
                  ),
                  SizedBox(width: kTopPadding),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _drawRouteTo(location),
                      icon: Icon(Icons.timeline),
                      label: Text('Vẽ tuyến'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kItemPadding),
              // Nút thêm/xóa điểm dừng
              if (_selectedLocation != null)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            _routeWaypoints.any((wp) => wp.id == location.id)
                            ? () => _removeWaypoint(location)
                            : () => _addWaypoint(location),
                        icon: Icon(
                          _routeWaypoints.any((wp) => wp.id == location.id)
                              ? Icons.remove_circle
                              : Icons.add_circle,
                        ),
                        label: Text(
                          _routeWaypoints.any((wp) => wp.id == location.id)
                              ? 'Xóa điểm dừng'
                              : 'Thêm điểm dừng',
                        ),
                      ),
                    ),
                    if (_routeWaypoints.isNotEmpty || _routeLine != null)
                      SizedBox(width: kTopPadding),
                    if (_routeWaypoints.isNotEmpty || _routeLine != null)
                      IconButton(
                        tooltip: 'Xóa tuyến',
                        onPressed: _clearRoute,
                        icon: Icon(Icons.clear_all),
                        color: Colors.red,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kItemPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (v) => _onSearchChanged(v),
        onTap: () {
          if (_recentSearches.isNotEmpty && _searchController.text.isEmpty) {
            _showRecentSearchesDialog();
          }
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm địa điểm...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(kTopPadding),
            child: Icon(
              Icons.search,
              color: Colors.black,
              size: kDefaultPadding,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_recentSearches.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.history, color: ColorPalette.subTitleColor),
                  onPressed: _showRecentSearchesDialog,
                  tooltip: 'Tìm kiếm gần đây',
                ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: ColorPalette.subTitleColor),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
            ],
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.primaryColor, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: kItemPadding),
        ),
      ),
    );
  }

  void _showRecentSearchesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tìm kiếm gần đây'),
        content: _recentSearches.isEmpty
            ? Text('Chưa có tìm kiếm gần đây')
            : Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _recentSearches.length,
                  itemBuilder: (context, index) {
                    final search = _recentSearches[index];
                    return ListTile(
                      leading: Icon(Icons.history),
                      title: Text(search),
                      onTap: () {
                        _searchController.text = search;
                        _onSearchChanged(search);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _recentSearches.clear();
                LocalStorageHelper.setValue('map_recent_searches', []);
              });
              Navigator.pop(context);
            },
            child: Text('Xóa tất cả'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showMapStyleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn kiểu bản đồ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.map,
                color: _selectedMapStyle == 'standard'
                    ? ColorPalette.primaryColor
                    : null,
              ),
              title: Text('Tiêu chuẩn'),
              trailing: _selectedMapStyle == 'standard'
                  ? Icon(Icons.check, color: ColorPalette.primaryColor)
                  : null,
              onTap: () {
                _changeMapStyle('standard');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.satellite,
                color: _selectedMapStyle == 'satellite'
                    ? ColorPalette.primaryColor
                    : null,
              ),
              title: Text('Vệ tinh'),
              trailing: _selectedMapStyle == 'satellite'
                  ? Icon(Icons.check, color: ColorPalette.primaryColor)
                  : null,
              onTap: () {
                _changeMapStyle('satellite');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.terrain,
                color: _selectedMapStyle == 'terrain'
                    ? ColorPalette.primaryColor
                    : null,
              ),
              title: Text('Địa hình'),
              trailing: _selectedMapStyle == 'terrain'
                  ? Icon(Icons.check, color: ColorPalette.primaryColor)
                  : null,
              onTap: () {
                _changeMapStyle('terrain');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kItemPadding + 2),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: _filteredLocations.length,
        itemBuilder: (context, index) {
          final location = _filteredLocations[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _focusOnLocation(location),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: ColorPalette.primaryColor,
                  child: Icon(
                    location.type == 'hotel' ? Icons.hotel : Icons.location_on,
                    color: Colors.white,
                    size: kBottomBarIconSize,
                  ),
                ),
                title: Text(
                  location.name,
                  style: TextStyles.defaultStyle.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  location.address ?? location.description,
                  style: TextStyles.defaultStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: ColorPalette.subTitleColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: kDefaultPadding),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 0),
        children: [
          _buildFilterChip('Tất cả', () {
            setState(() {
              _filteredLocations = _locations;
              _searchQuery = '';
            });
            _addMarkers();
          }),
          SizedBox(width: kTopPadding),
          _buildFilterChip('Điểm đến', () {
            setState(() {
              _filteredLocations = _locations
                  .where((l) => l.type == 'destination')
                  .toList();
            });
            _addMarkers();
          }),
          SizedBox(width: kTopPadding),
          _buildFilterChip('Khách sạn', () {
            setState(() {
              _filteredLocations = _locations
                  .where((l) => l.type == 'hotel')
                  .toList();
            });
            _addMarkers();
          }),
          SizedBox(width: kTopPadding),
          _buildFilterChip('Vị trí của tôi', () {
            if (_currentLocation != null) {
              _focusOnLocation(_currentLocation!);
            } else {
              _focusMyLocation();
            }
          }),
          SizedBox(width: 8),
          _buildFilterChip('Gần tôi (≤ 50km)', () {
            if (_currentLocation == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Vui lòng bật vị trí của bạn'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            setState(() {
              _filteredLocations = _locations.where((l) {
                final d = _distanceKm(
                  _currentLocation!.latitude,
                  _currentLocation!.longitude,
                  l.latitude,
                  l.longitude,
                );
                return d <= 50.0;
              }).toList();
            });
            _addMarkers();
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kItemPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kBottomBarIconSize),
          border: Border.all(color: ColorPalette.primaryColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.defaultStyle.medium.primaryTextColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Bản Đồ',
      child: Column(
        children: [
          // Search Bar - Cố định ở trên (giống TextField trong home_screen)
          _buildSearchBar(),

          // Quick Filters - Cố định ngay dưới search
          _buildQuickFilters(),

          // Map và nội dung có thể tương tác - Phần mở rộng
          Expanded(
            child: Stack(
              children: [
                // Map nền
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  _buildMap(),

                // Search Results - Hiển thị khi có kết quả tìm kiếm
                if (_searchQuery.isNotEmpty && _filteredLocations.isNotEmpty)
                  Positioned(
                    top: kTopPadding,
                    left: 0,
                    right: 0,
                    child: _buildSearchResults(),
                  ),

                // Floating buttons
                Positioned(
                  right: kDefaultPadding,
                  bottom: 120,
                  child: Column(
                    children: [
                      // Map style selector
                      FloatingActionButton(
                        heroTag: 'map_style',
                        mini: true,
                        onPressed: () => _showMapStyleDialog(),
                        child: Icon(Icons.layers),
                        backgroundColor: Colors.green,
                      ),
                      SizedBox(height: kItemPadding + 2),
                      FloatingActionButton(
                        heroTag: 'my_loc',
                        mini: true,
                        onPressed: _focusMyLocation,
                        child: Icon(Icons.my_location),
                      ),
                      SizedBox(height: kItemPadding + 2),
                      if (_selectedLocation != null)
                        FloatingActionButton(
                          heroTag: 'ext_nav',
                          mini: true,
                          onPressed: () =>
                              _openExternalNavigation(_selectedLocation!),
                          child: Icon(Icons.navigation),
                        ),
                    ],
                  ),
                ),

                // Waypoints list (nếu có)
                if (_routeWaypoints.isNotEmpty)
                  Positioned(
                    top: kTopPadding,
                    right: kDefaultPadding,
                    child: Container(
                      width: 200,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(kItemPadding),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(kItemPadding),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Điểm dừng (${_routeWaypoints.length})',
                                    style: TextStyles.defaultStyle.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, size: 18),
                                  onPressed: _clearRoute,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _routeWaypoints.length,
                              itemBuilder: (context, index) {
                                final waypoint = _routeWaypoints[index];
                                return ListTile(
                                  dense: true,
                                  leading: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: ColorPalette.primaryColor,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    waypoint.name,
                                    style: TextStyles.defaultStyle.fontCaption,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_circle, size: 18),
                                    color: Colors.red,
                                    onPressed: () => _removeWaypoint(waypoint),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Info Card - Hiển thị khi chọn địa điểm
                if (_selectedLocation != null)
                  Positioned(
                    bottom: kBottomBarIconSize,
                    left: kMediumPadding,
                    right: kMediumPadding,
                    child: SafeArea(
                      child: _buildLocationInfoCard(_selectedLocation!),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}

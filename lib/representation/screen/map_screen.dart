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

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _loadFavorites();
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
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
          13.0,
        ),
      );
    }

    // Lắng nghe tap vào symbol
    _mapController!.onSymbolTapped.add((symbol) {
      final loc = _symbolIdToLocation[symbol.id];
      if (loc != null) {
        setState(() => _selectedLocation = loc);
        _moveToLocation(loc);
      }
    });

    // Thêm markers sau khi map đã sẵn sàng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addMarkers();
    });
  }

  void _addMarkers() {
    if (_mapController == null) return;

    // Xóa markers cũ nếu có
    for (var marker in _markers) {
      try {
        _mapController!.removeSymbol(marker);
      } catch (e) {
        // Ignore errors
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
              if (mounted) {
                setState(() {
                  _markers.add(symbol);
                  _symbolIdToLocation[symbol.id] = location;
                });
              }
            });
      } catch (e) {
        // Fallback: sử dụng text label nếu không có icon
        try {
          _mapController!
              .addSymbol(
                SymbolOptions(
                  geometry: LatLng(location.latitude, location.longitude),
                  textField: location.type == 'hotel' ? '🏨' : '📍',
                  textSize: 20.0,
                ),
              )
              .then((symbol) {
                if (mounted) {
                  setState(() {
                    _markers.add(symbol);
                    _symbolIdToLocation[symbol.id] = location;
                  });
                }
              });
        } catch (e2) {
          // Ignore errors
        }
      }
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
    final points = [
      LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      LatLng(location.latitude, location.longitude),
    ];
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
    // Dùng style demo mặc định để đảm bảo có tiles hiển thị (không cần token)
    // và đảm bảo map fill toàn bộ vùng hiển thị
    return SizedBox.expand(
      child: VietmapGL(
        // Ép dùng style demo rõ ràng để tránh lỗi không tải style mặc định
        styleString: VietmapStyles.demo,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentLocation?.latitude ?? 21.0285,
            _currentLocation?.longitude ?? 105.8542,
          ),
          zoom: 13.0,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _addMarkers,
        onMapClick: _onMapClick,
        onUserLocationUpdated: (userLoc) {
          setState(() {
            _currentLocation = MapLocation(
              id: 'me',
              name: 'Vị trí của tôi',
              description: 'Vị trí hiện tại',
              latitude: userLoc.position.latitude,
              longitude: userLoc.position.longitude,
            );
          });
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultPadding)),
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
                    Icon(Icons.star, size: kDefaultIconSize, color: Colors.amber),
                    SizedBox(width: kMinPadding),
                    Text(
                      '${location.rating}',
                      style: TextStyles.defaultStyle.bold,
                    ),
                    if (location.reviewCount != null) ...[
                      SizedBox(width: kMinPadding),
                      Text(
                        '(${location.reviewCount} đánh giá)',
                        style: TextStyles.defaultStyle.fontCaption.subTitleTextColor,
                      ),
                    ],
                  ],
                ),
              ],
              SizedBox(height: kItemPadding),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _openExternalNavigation(location),
                    icon: Icon(Icons.directions),
                    label: Text('Chỉ đường'),
                  ),
                  SizedBox(width: kTopPadding),
                  ElevatedButton.icon(
                    onPressed: () => _drawRouteTo(location),
                    icon: Icon(Icons.timeline),
                    label: Text('Vẽ tuyến'),
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
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: ColorPalette.subTitleColor),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
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
            borderSide: BorderSide(
              color: ColorPalette.primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: kItemPadding),
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
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kItemPadding),
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

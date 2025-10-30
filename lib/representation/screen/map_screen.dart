import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';

class MapScreen extends StatelessWidget {
=======
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/data/mock/destination_data.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
>>>>>>> 72ffec4 (Initial commit)
  static const String routeName = '/map_screen';

  const MapScreen({Key? key}) : super(key: key);

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Bản Đồ',
      // implementLeading: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: Colors.blueAccent),
            SizedBox(height: 24),
            Text(
              'Chức năng bản đồ sẽ được phát triển',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
=======
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  double _currentZoom = 12.0;
  PopularDestination? _selectedDestination;
  List<PopularDestination> _searchResults = [];
  bool _showSearchResults = false;
  bool _hasSearchText = false;

  // Tọa độ các điểm đến (mock data)
  final Map<String, LatLng> _destinationCoordinates = {
    '1': LatLng(20.9101, 107.1839), // Hạ Long Bay
    '2': LatLng(10.2899, 103.9840), // Phú Quốc
    '3': LatLng(35.6762, 139.6503), // Tokyo
    '4': LatLng(36.3932, 25.4615), // Santorini
    '5': LatLng(-8.3405, 115.0920), // Bali
    '6': LatLng(11.9404, 108.4583), // Đà Lạt
  };

  final LatLng _defaultCenter = LatLng(21.0278, 105.8342); // Hà Nội

  @override
  void initState() {
    super.initState();
    _searchResults = DestinationData.popularDestinations;
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Marker> _buildMarkers() {
    return DestinationData.popularDestinations.map((destination) {
      final coordinates =
          _destinationCoordinates[destination.id] ?? _defaultCenter;
      final isSelected = _selectedDestination?.id == destination.id;

      return Marker(
        point: coordinates,
        width: 50,
        height: 50,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedDestination = destination;
            });
            _mapController.move(coordinates, _currentZoom);
            _showInfoBottomSheet(destination, coordinates);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? ColorPalette.primaryColor : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : ColorPalette.primaryColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on,
              color: isSelected ? Colors.white : ColorPalette.primaryColor,
              size: 30,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showInfoBottomSheet(
    PopularDestination destination,
    LatLng coordinates,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(kMediumPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            Text(
              destination.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              destination.country,
              style: const TextStyle(
                fontSize: 16,
                color: ColorPalette.subTitleColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, color: ColorPalette.yellowColor, size: 20),
                const SizedBox(width: 4),
                Text(
                  destination.rating.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${destination.reviewCount} đánh giá)',
                  style: const TextStyle(
                    color: ColorPalette.subTitleColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              destination.description,
              style: const TextStyle(
                fontSize: 14,
                color: ColorPalette.textColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            _WeatherQuickView(
              lat: coordinates.latitude,
              lon: coordinates.longitude,
            ),
            const SizedBox(height: kDefaultPadding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Có thể navigate đến detail screen ở đây
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: kDefaultBorderRadius,
                  ),
                ),
                child: const Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
>>>>>>> 72ffec4 (Initial commit)
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  void _onSearchChanged(String query) {
    setState(() {
      _hasSearchText = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = DestinationData.popularDestinations;
        _showSearchResults = false;
      } else {
        _searchResults = DestinationData.popularDestinations
            .where(
              (dest) =>
                  dest.name.toLowerCase().contains(query.toLowerCase()) ||
                  dest.country.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        _showSearchResults = true;
      }
    });
  }

  void _navigateToDestination(PopularDestination destination) {
    final coordinates =
        _destinationCoordinates[destination.id] ?? _defaultCenter;
    setState(() {
      _selectedDestination = destination;
      _showSearchResults = false;
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
    _mapController.move(coordinates, 14.0);
    _showInfoBottomSheet(destination, coordinates);
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(3.0, 18.0);
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(3.0, 18.0);
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _centerToDefault() {
    setState(() {
      _selectedDestination = null;
    });
    _mapController.move(_defaultCenter, 12.0);
    setState(() {
      _currentZoom = 12.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Bản Đồ',
      child: Column(
        children: [
          // Thanh tìm kiếm
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: kDefaultBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm địa điểm...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ColorPalette.primaryColor,
                    ),
                    suffixIcon: _hasSearchText
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: kDefaultBorderRadius,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                // Kết quả tìm kiếm
                if (_showSearchResults && _searchResults.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final dest = _searchResults[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: ColorPalette.primaryColor,
                          ),
                          title: Text(dest.name),
                          subtitle: Text(dest.country),
                          onTap: () => _navigateToDestination(dest),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          // Bản đồ
          Expanded(
            child: ClipRRect(
              borderRadius: kDefaultBorderRadius,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _defaultCenter,
                      initialZoom: _currentZoom,
                      onMapEvent: (MapEvent event) {
                        if (event is MapEventMove ||
                            event is MapEventScrollWheelZoom) {
                          setState(() {
                            _currentZoom = _mapController.camera.zoom;
                          });
                        }
                      },
                      interactionOptions: const InteractionOptions(
                        flags: ~InteractiveFlag.rotate,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName:
                            'com.example.flutter_travels_apps',
                      ),
                      MarkerLayer(markers: _buildMarkers()),
                    ],
                  ),
                  // Nút điều khiển
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Column(
                      children: [
                        // Nút zoom in
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _zoomIn,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.add,
                                  color: ColorPalette.primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Nút zoom out
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _zoomOut,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.remove,
                                  color: ColorPalette.primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Nút về vị trí mặc định
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _centerToDefault,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.my_location,
                                  color: ColorPalette.primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherQuickView extends StatefulWidget {
  final double lat;
  final double lon;
  const _WeatherQuickView({required this.lat, required this.lon});

  @override
  State<_WeatherQuickView> createState() => _WeatherQuickViewState();
}

class _WeatherQuickViewState extends State<_WeatherQuickView> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${widget.lat}&longitude=${widget.lon}&current=temperature_2m,weather_code&daily=temperature_2m_max,temperature_2m_min&timezone=auto',
    );
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        _data = json.decode(res.body) as Map<String, dynamic>;
      } else {
        _error = 'HTTP ${res.statusCode}';
      }
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Row(
        children: const [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Đang tải thời tiết...'),
        ],
      );
    }
    if (_error != null) {
      return Text(
        'Không tải được thời tiết: $_error',
        style: const TextStyle(color: Colors.red),
      );
    }
    final current = _data?['current'] as Map<String, dynamic>?;
    final daily = _data?['daily'] as Map<String, dynamic>?;
    final temp = current?['temperature_2m'];
    final List tempsMax = daily?['temperature_2m_max'] ?? [];
    final List tempsMin = daily?['temperature_2m_min'] ?? [];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thời tiết',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.thermostat, color: ColorPalette.primaryColor),
              const SizedBox(width: 6),
              Text(temp != null ? '${temp.toString()}°C hiện tại' : '—'),
            ],
          ),
          const SizedBox(height: 8),
          if (tempsMax.isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: ColorPalette.subTitleColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'Hôm nay: ${tempsMin.first?.round()}° / ${tempsMax.first?.round()}°',
                ),
              ],
            ),
        ],
      ),
    );
  }
>>>>>>> 72ffec4 (Initial commit)
}

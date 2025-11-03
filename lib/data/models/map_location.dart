class MapLocation {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final String? type; // 'destination', 'hotel', 'attraction', etc.
  final String? address;

  MapLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.type,
    this.address,
  });
}

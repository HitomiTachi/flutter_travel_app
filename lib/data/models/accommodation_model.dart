class AccommodationModel {
  final String id;
  final String name;
  final String type;
  final String location;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int pricePerNight;
  final List<String> amenities;
  final String description;

  AccommodationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.amenities,
    required this.description,
  });

  String get formattedPrice {
    if (pricePerNight >= 1000000) {
      return '${(pricePerNight / 1000000).toStringAsFixed(1)}M VNĐ';
    } else if (pricePerNight >= 1000) {
      return '${(pricePerNight / 1000).toStringAsFixed(0)}K VNĐ';
    } else {
      return '$pricePerNight VNĐ';
    }
  }

  String get typeIcon {
    switch (type) {
      case 'Khách sạn':
        return '🏨';
      case 'Homestay':
        return '🏠';
      case 'Resort':
        return '🏖️';
      case 'Hostel':
        return '🛏️';
      case 'Villa':
        return '🏰';
      default:
        return '🏨';
    }
  }
}
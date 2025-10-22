import 'package:flutter_travels_apps/data/models/popular_destination.dart';

class DestinationDataProvider {
  static List<PopularDestination> getPopularDestinations() {
    return [
      PopularDestination(
        id: '1',
        name: 'Hạ Long Bay',
        country: 'Việt Nam',
        imageUrl: 'assets/images/img1.jpg',
        rating: 4.9,
        reviewCount: 3247,
        description: 'Di sản thế giới với hàng nghìn đảo đá vôi kỳ thú',
        isPopular: true,
      ),
      PopularDestination(
        id: '2',
        name: 'Phú Quốc',
        country: 'Việt Nam',
        imageUrl: 'assets/images/img2.jpg',
        rating: 4.8,
        reviewCount: 2156,
        description: 'Đảo ngọc nhiệt đới với bãi biển cát trắng tuyệt đẹp',
        isPopular: true,
      ),
      PopularDestination(
        id: '3',
        name: 'Tokyo',
        country: 'Japan',
        imageUrl: 'assets/images/img3.jpg',
        rating: 4.7,
        reviewCount: 3521,
        description: 'Thủ đô hiện đại kết hợp văn hóa truyền thống độc đáo',
      ),
      PopularDestination(
        id: '4',
        name: 'Santorini',
        country: 'Hy Lạp',
        imageUrl: 'assets/images/imgHotel.jpg',
        rating: 4.9,
        reviewCount: 1923,
        description: 'Đảo lãng mạn với kiến trúc trắng xanh đặc trưng',
      ),
      PopularDestination(
        id: '5',
        name: 'Bali',
        country: 'Indonesia',
        imageUrl: 'assets/images/img1.jpg',
        rating: 4.6,
        reviewCount: 2847,
        description: 'Thiên đường nhiệt đới với văn hóa Hindu độc đáo',
      ),
      PopularDestination(
        id: '6',
        name: 'Đà Lạt',
        country: 'Việt Nam',
        imageUrl: 'assets/images/img2.jpg',
        rating: 4.5,
        reviewCount: 1654,
        description: 'Thành phố ngàn hoa với khí hậu mát mẻ quanh năm',
      ),
    ];
  }

  static List<PopularDestination> getDestinationsByCountry(String country) {
    final destinations = getPopularDestinations();
    if (country == 'Tất cả') return destinations;
    return destinations.where((dest) => dest.country == country).toList();
  }

  static List<String> getAvailableCountries() {
    final destinations = getPopularDestinations();
    final countries = destinations.map((dest) => dest.country).toSet().toList();
    return ['Tất cả', ...countries];
  }

  static List<PopularDestination> getPopularOnly() {
    return getPopularDestinations().where((dest) => dest.isPopular == true).toList();
  }

  static List<PopularDestination> getTopRatedDestinations({int limit = 5}) {
    final destinations = getPopularDestinations();
    destinations.sort((a, b) => b.rating.compareTo(a.rating));
    return destinations.take(limit).toList();
  }

  static List<PopularDestination> searchDestinations(String query) {
    final destinations = getPopularDestinations();
    return destinations.where((dest) => 
      dest.name.toLowerCase().contains(query.toLowerCase()) ||
      dest.country.toLowerCase().contains(query.toLowerCase()) ||
      dest.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  static List<PopularDestination> getDestinationsByRating(double minRating) {
    return getPopularDestinations().where((dest) => dest.rating >= minRating).toList();
  }
}
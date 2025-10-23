import '../models/popular_destination.dart';

class DestinationData {
  static List<PopularDestination> get popularDestinations => [
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
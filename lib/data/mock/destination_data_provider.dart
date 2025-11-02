import 'package:flutter_travels_apps/data/models/popular_destination.dart';

class DestinationDataProvider {
  // Dữ liệu gốc - Single source of truth
  static final List<PopularDestination> _destinations = [
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
      name: 'Đà Lạt',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img2.jpg',
      rating: 4.7,
      reviewCount: 1654,
      description: 'Thành phố ngàn hoa với khí hậu mát mẻ quanh năm',
      isPopular: true,
    ),
    PopularDestination(
      id: '4',
      name: 'Sapa',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img3.jpg',
      rating: 4.8,
      reviewCount: 2341,
      description: 'Thị trấn miền núi với ruộng bậc thang tuyệt đẹp',
      isPopular: true,
    ),
    PopularDestination(
      id: '5',
      name: 'Hội An',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img1.jpg',
      rating: 4.9,
      reviewCount: 2987,
      description: 'Phố cổ di sản với đèn lồng rực rỡ về đêm',
      isPopular: true,
    ),
    PopularDestination(
      id: '6',
      name: 'Nha Trang',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img2.jpg',
      rating: 4.6,
      reviewCount: 2543,
      description: 'Thành phố biển với bãi tắm đẹp và hải sản tươi ngon',
      isPopular: true,
    ),
    PopularDestination(
      id: '7',
      name: 'Huế',
      country: 'Việt Nam',
      imageUrl: 'assets/images/imgHotel.jpg',
      rating: 4.7,
      reviewCount: 1876,
      description: 'Cố đô với kiến trúc hoàng cung và ẩm thực cung đình',
      isPopular: true,
    ),
    PopularDestination(
      id: '8',
      name: 'Ninh Bình',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img1.jpg',
      rating: 4.8,
      reviewCount: 2134,
      description: 'Vịnh Hạ Long trên cạn với hang động và núi non hùng vĩ',
      isPopular: true,
    ),
    PopularDestination(
      id: '9',
      name: 'Đà Nẵng',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img3.jpg',
      rating: 4.7,
      reviewCount: 3124,
      description: 'Thành phố đáng sống với cầu Rồng và Bà Nà Hills',
      isPopular: true,
    ),
    PopularDestination(
      id: '10',
      name: 'Mũi Né',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img2.jpg',
      rating: 4.5,
      reviewCount: 1923,
      description: 'Bãi biển với đồi cát đỏ và trắng tuyệt đẹp',
      isPopular: true,
    ),
    PopularDestination(
      id: '11',
      name: 'Cần Thơ',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img1.jpg',
      rating: 4.6,
      reviewCount: 1567,
      description: 'Thủ phủ miền Tây với chợ nổi Cái Răng nổi tiếng',
    ),
    PopularDestination(
      id: '12',
      name: 'Côn Đảo',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img2.jpg',
      rating: 4.9,
      reviewCount: 1234,
      description: 'Quần đảo hoang sơ với biển xanh trong vắt',
    ),
    PopularDestination(
      id: '13',
      name: 'Mai Châu',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img3.jpg',
      rating: 4.6,
      reviewCount: 987,
      description: 'Thung lũng yên bình với nhà sàn và văn hóa Thái',
    ),
    PopularDestination(
      id: '14',
      name: 'Vũng Tàu',
      country: 'Việt Nam',
      imageUrl: 'assets/images/imgHotel.jpg',
      rating: 4.4,
      reviewCount: 2456,
      description: 'Thành phố biển gần Sài Gòn với hải sản tươi ngon',
    ),
    PopularDestination(
      id: '15',
      name: 'Cát Bà',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img1.jpg',
      rating: 4.7,
      reviewCount: 1678,
      description: 'Đảo lớn nhất Vịnh Hạ Long với vườn quốc gia',
    ),
    PopularDestination(
      id: '16',
      name: 'Phan Thiết',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img2.jpg',
      rating: 4.5,
      reviewCount: 1889,
      description: 'Thành phố ven biển nổi tiếng với nước mắm và mực khô',
    ),
    PopularDestination(
      id: '17',
      name: 'Tam Đảo',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img3.jpg',
      rating: 4.6,
      reviewCount: 1123,
      description: 'Thị trấn núi mát mẻ gần Hà Nội với sương mù quanh năm',
    ),
    PopularDestination(
      id: '18',
      name: 'Quy Nhơn',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img1.jpg',
      rating: 4.7,
      reviewCount: 1456,
      description: 'Thành phố biển yên tĩnh với Eo Gió nổi tiếng',
    ),
    PopularDestination(
      id: '19',
      name: 'Mộc Châu',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img2.jpg',
      rating: 4.6,
      reviewCount: 1298,
      description: 'Cao nguyên với đồi chè xanh mướt và sữa bò tươi',
    ),
    PopularDestination(
      id: '20',
      name: 'Hà Giang',
      country: 'Việt Nam',
      imageUrl: 'assets/images/img3.jpg',
      rating: 4.9,
      reviewCount: 2134,
      description: 'Vùng núi đá đôi với cung đường biên giới hùng vĩ',
    ),
  ];

  // Getter chính
  static List<PopularDestination> getPopularDestinations() => List.from(_destinations);

  // Backward compatibility với DestinationData
  static List<PopularDestination> get popularDestinations => getPopularDestinations();

  static List<PopularDestination> getDestinationsByCountry(String country) {
    if (country == 'Tất cả') return getPopularDestinations();
    return _destinations.where((dest) => dest.country == country).toList();
  }

  static List<String> getAvailableCountries() {
    final countries = _destinations.map((dest) => dest.country).toSet().toList();
    return ['Tất cả', ...countries];
  }

  static List<PopularDestination> getPopularOnly() {
    return _destinations.where((dest) => dest.isPopular == true).toList();
  }

  static List<PopularDestination> getTopRatedDestinations({int limit = 5}) {
    final sorted = List<PopularDestination>.from(_destinations);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(limit).toList();
  }

  static List<PopularDestination> searchDestinations(String query) {
    return _destinations.where((dest) => 
      dest.name.toLowerCase().contains(query.toLowerCase()) ||
      dest.country.toLowerCase().contains(query.toLowerCase()) ||
      dest.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  static List<PopularDestination> getDestinationsByRating(double minRating) {
    return _destinations.where((dest) => dest.rating >= minRating).toList();
  }

  // ===== THÊM: Methods cho Favorites =====
  
  /// Lấy destinations theo danh sách IDs (cho màn hình yêu thích)
  static List<PopularDestination> getDestinationsByIds(Set<String> ids) {
    return _destinations.where((dest) => ids.contains(dest.id)).toList();
  }

  /// Lấy 3 destinations mặc định cho demo favorites
  static Set<String> getDefaultFavoriteIds() {
    return _destinations.take(3).map((d) => d.id).toSet();
  }

  /// Lọc theo category (Việt Nam, Biển, Núi, v.v.)
  static List<PopularDestination> filterByCategory(
    List<PopularDestination> destinations, 
    String category,
  ) {
    switch (category) {
      case 'Việt Nam':
        return destinations.where((d) => d.country == 'Việt Nam').toList();
      case 'Biển':
        return destinations.where((d) => 
          d.name.contains('Phú Quốc') || 
          d.name.contains('Santorini') || 
          d.name.contains('Bali')
        ).toList();
      case 'Núi':
        return destinations.where((d) => d.name.contains('Đà Lạt')).toList();
      default:
        return destinations;
    }
  }
}
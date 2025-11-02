import 'package:flutter_travels_apps/data/models/featured_article.dart';

class ArticleDataProvider {
  // Dữ liệu gốc - Single source of truth
  static final List<FeaturedArticle> _articles = [
    FeaturedArticle(
      id: '1',
      title: 'Top 15 Điểm Đến Tuyệt Vời Nhất Việt Nam 2024',
      subtitle: 'Khám phá những địa danh đẹp nhất đất nước hình chữ S từ Bắc vào Nam',
      imageUrl: 'assets/images/img1.jpg',
      author: 'Minh Châu',
      publishDate: DateTime.now().subtract(Duration(days: 1)),
      readTime: 12,
      category: 'Khám phá',
      likes: 1247,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '2',
      title: 'Bí Kíp Du Lịch Việt Nam Tiết Kiệm',
      subtitle: 'Hướng dẫn chi tiết để có chuyến đi backpacking hoàn hảo với ngân sách thấp',
      imageUrl: 'assets/images/img2.jpg',
      author: 'Hoàng Anh',
      publishDate: DateTime.now().subtract(Duration(days: 3)),
      readTime: 8,
      category: 'Mẹo hay',
      likes: 892,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '3',
      title: 'Ẩm Thực Đường Phố Sài Gòn Phải Thử',
      subtitle: 'Những món ăn vặt không thể bỏ qua khi đến thành phố Hồ Chí Minh',
      imageUrl: 'assets/images/img3.jpg',
      author: 'Thuỳ Linh',
      publishDate: DateTime.now().subtract(Duration(days: 5)),
      readTime: 6,
      category: 'Ẩm thực',
      likes: 567,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '4',
      title: 'Resort Cao Cấp Phú Quốc Đáng Trải Nghiệm',
      subtitle: 'Danh sách những khu nghỉ dưỡng 5 sao tốt nhất tại đảo ngọc',
      imageUrl: 'assets/images/imgHotel.jpg',
      author: 'Đức Minh',
      publishDate: DateTime.now().subtract(Duration(days: 7)),
      readTime: 10,
      category: 'Nghỉ dưỡng',
      likes: 724,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '5',
      title: 'Hành Trình Khám Phá Hạ Long Bằng Du Thuyền',
      subtitle: 'Trải nghiệm overnight cruise qua vịnh Hạ Long huyền diệu',
      imageUrl: 'assets/images/img1.jpg',
      author: 'Văn Hưng',
      publishDate: DateTime.now().subtract(Duration(days: 10)),
      readTime: 15,
      category: 'Phiêu lưu',
      likes: 445,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '6',
      title: 'Lịch Trình Du Lịch Đà Lạt 3 Ngày 2 Đêm',
      subtitle: 'Khám phá thành phố ngàn hoa với lịch trình chi tiết và tiết kiệm',
      imageUrl: 'assets/images/img2.jpg',
      author: 'Thanh Hà',
      publishDate: DateTime.now().subtract(Duration(days: 12)),
      readTime: 9,
      category: 'Lịch trình',
      likes: 658,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '7',
      title: 'Khám Phá Sapa Mùa Lúa Chín',
      subtitle: 'Ruộng bậc thang vàng óng và văn hóa dân tộc độc đáo',
      imageUrl: 'assets/images/img3.jpg',
      author: 'Lan Anh',
      publishDate: DateTime.now().subtract(Duration(days: 14)),
      readTime: 11,
      category: 'Khám phá',
      likes: 823,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '8',
      title: 'Ẩm Thực Hà Nội Không Thể Bỏ Qua',
      subtitle: 'Phở, bún chả, và hàng chục món đặc sản thủ đô',
      imageUrl: 'assets/images/img1.jpg',
      author: 'Quang Huy',
      publishDate: DateTime.now().subtract(Duration(days: 16)),
      readTime: 7,
      category: 'Ẩm thực',
      likes: 934,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '9',
      title: 'Hội An - Phố Cổ Lung Linh Đèn Lồng',
      subtitle: 'Khám phá kiến trúc cổ và làng nghề truyền thống',
      imageUrl: 'assets/images/img2.jpg',
      author: 'Mai Phương',
      publishDate: DateTime.now().subtract(Duration(days: 18)),
      readTime: 13,
      category: 'Khám phá',
      likes: 1156,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '10',
      title: 'Ninh Bình - Hạ Long Trên Cạn',
      subtitle: 'Hang Múa, Tam Cốc và những danh thắng tuyệt đẹp',
      imageUrl: 'assets/images/img3.jpg',
      author: 'Tuấn Kiệt',
      publishDate: DateTime.now().subtract(Duration(days: 20)),
      readTime: 10,
      category: 'Phiêu lưu',
      likes: 687,
      isFeatured: true,
    ),
    FeaturedArticle(
      id: '11',
      title: 'Nha Trang - Thiên Đường Biển Xanh',
      subtitle: 'Lặn biển, tắm bùn khoáng và hải sản tươi ngon',
      imageUrl: 'assets/images/img1.jpg',
      author: 'Hồng Nhung',
      publishDate: DateTime.now().subtract(Duration(days: 22)),
      readTime: 9,
      category: 'Nghỉ dưỡng',
      likes: 745,
    ),
    FeaturedArticle(
      id: '12',
      title: 'Đà Nẵng - Thành Phố Đáng Sống',
      subtitle: 'Cầu Rồng, Bà Nà Hills và những điểm check-in hot',
      imageUrl: 'assets/images/img2.jpg',
      author: 'Văn Đức',
      publishDate: DateTime.now().subtract(Duration(days: 24)),
      readTime: 12,
      category: 'Khám phá',
      likes: 892,
    ),
    FeaturedArticle(
      id: '13',
      title: 'Huế - Cố Đô Ngàn Năm Văn Hiến',
      subtitle: 'Hoàng cung, lăng tẩm và ẩm thực cung đình đặc sắc',
      imageUrl: 'assets/images/img3.jpg',
      author: 'Thanh Bình',
      publishDate: DateTime.now().subtract(Duration(days: 26)),
      readTime: 14,
      category: 'Lịch trình',
      likes: 623,
    ),
    FeaturedArticle(
      id: '14',
      title: 'Mũi Né - Thiên Đường Đồi Cát',
      subtitle: 'Đồi cát bay, đồi cát đỏ và biển xanh trong vắt',
      imageUrl: 'assets/images/imgHotel.jpg',
      author: 'Phương Anh',
      publishDate: DateTime.now().subtract(Duration(days: 28)),
      readTime: 8,
      category: 'Phiêu lưu',
      likes: 534,
    ),
    FeaturedArticle(
      id: '15',
      title: 'Cần Thơ - Miền Tây Sông Nước',
      subtitle: 'Chợ nổi Cái Răng và vườn trái cây tươi ngon',
      imageUrl: 'assets/images/img1.jpg',
      author: 'Minh Tuấn',
      publishDate: DateTime.now().subtract(Duration(days: 30)),
      readTime: 11,
      category: 'Ẩm thực',
      likes: 467,
    ),
    FeaturedArticle(
      id: '16',
      title: 'Côn Đảo - Quần Đảo Bí Ẩn',
      subtitle: 'Biển xanh hoang sơ và lịch sử bi hùng',
      imageUrl: 'assets/images/img2.jpg',
      author: 'Thu Hà',
      publishDate: DateTime.now().subtract(Duration(days: 32)),
      readTime: 13,
      category: 'Khám phá',
      likes: 389,
    ),
    FeaturedArticle(
      id: '17',
      title: 'Mai Châu - Thung Lũng Yên Bình',
      subtitle: 'Nhà sàn, ruộng lúa và văn hóa dân tộc Thái',
      imageUrl: 'assets/images/img3.jpg',
      author: 'Đình Phong',
      publishDate: DateTime.now().subtract(Duration(days: 34)),
      readTime: 10,
      category: 'Lịch trình',
      likes: 512,
    ),
    FeaturedArticle(
      id: '18',
      title: 'Quy Nhơn - Bãi Biển Hoang Sơ',
      subtitle: 'Eo Gió, Kỳ Co và hải sản tươi ngon giá rẻ',
      imageUrl: 'assets/images/img1.jpg',
      author: 'Ngọc Trinh',
      publishDate: DateTime.now().subtract(Duration(days: 36)),
      readTime: 9,
      category: 'Nghỉ dưỡng',
      likes: 678,
    ),
    FeaturedArticle(
      id: '19',
      title: 'Mộc Châu - Cao Nguyên Trà Sữa',
      subtitle: 'Đồi chè xanh mướt và sữa bò tươi ngon nhất',
      imageUrl: 'assets/images/img2.jpg',
      author: 'Hải Đăng',
      publishDate: DateTime.now().subtract(Duration(days: 38)),
      readTime: 8,
      category: 'Mẹo hay',
      likes: 445,
    ),
    FeaturedArticle(
      id: '20',
      title: 'Hà Giang - Hành Trình Chinh Phục',
      subtitle: 'Cung đường biên giới và cao nguyên đá Đồng Văn',
      imageUrl: 'assets/images/img3.jpg',
      author: 'Việt Anh',
      publishDate: DateTime.now().subtract(Duration(days: 40)),
      readTime: 16,
      category: 'Phiêu lưu',
      likes: 1234,
    ),
  ];

  // Getter chính
  static List<FeaturedArticle> getFeaturedArticles() => List.from(_articles);

  // Backward compatibility với ArticleData
  static List<FeaturedArticle> get featuredArticles => getFeaturedArticles();

  static List<FeaturedArticle> getArticlesByCategory(String category) {
    if (category == 'Tất cả') return getFeaturedArticles();
    return _articles.where((article) => article.category == category).toList();
  }

  static List<String> getAvailableCategories() {
    final categories = _articles.map((article) => article.category).toSet().toList();
    return ['Tất cả', ...categories];
  }

  static List<FeaturedArticle> getFeaturedOnly() {
    return _articles.where((article) => article.isFeatured == true).toList();
  }

  static List<FeaturedArticle> searchArticles(String query) {
    return _articles.where((article) => 
      article.title.toLowerCase().contains(query.toLowerCase()) ||
      article.subtitle.toLowerCase().contains(query.toLowerCase()) ||
      article.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // ===== THÊM: Methods cho Favorites =====
  
  /// Lấy articles theo danh sách IDs (cho màn hình yêu thích)
  static List<FeaturedArticle> getArticlesByIds(Set<String> ids) {
    return _articles.where((article) => ids.contains(article.id)).toList();
  }

  /// Lấy 2 articles mặc định cho demo favorites (article 1 và 3)
  static Set<String> getDefaultFavoriteIds() {
    return {'1', '3'}; // Top 15 Điểm Đến và Ẩm Thực Sài Gòn
  }

  /// Lọc theo category (Kinh nghiệm, Review, Gợi ý lịch trình...)
  static List<FeaturedArticle> filterByCategory(
    List<FeaturedArticle> articles, 
    String category,
  ) {
    switch (category) {
      case 'Tất cả':
        return articles;
      case 'Kinh nghiệm':
        return articles.where((a) => 
          a.category == 'Du lịch' || 
          a.title.toLowerCase().contains('kinh nghiệm')
        ).toList();
      case 'Review':
        return articles.where((a) => 
          a.title.toLowerCase().contains('review') ||
          a.title.toLowerCase().contains('top') ||
          a.title.toLowerCase().contains('điểm đến')
        ).toList();
      case 'Gợi ý lịch trình':
        return articles.where((a) => 
          a.title.toLowerCase().contains('lịch trình') ||
          a.title.toLowerCase().contains('ngày') ||
          a.category == 'Lịch trình'
        ).toList();
      case 'Ẩm thực':
        return articles.where((a) => a.category == 'Ẩm thực').toList();
      default:
        return articles;
    }
  }
}
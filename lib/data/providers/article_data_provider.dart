import 'package:flutter_travels_apps/data/models/featured_article.dart';

class ArticleDataProvider {
  static List<FeaturedArticle> getFeaturedArticles() {
    return [
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
        title: 'Bí Kíp Du Lịch Bụi Đông Nam Á Tiết Kiệm',
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
      ),
    ];
  }

  static List<FeaturedArticle> getArticlesByCategory(String category) {
    final articles = getFeaturedArticles();
    if (category == 'Tất cả') return articles;
    return articles.where((article) => article.category == category).toList();
  }

  static List<String> getAvailableCategories() {
    final articles = getFeaturedArticles();
    final categories = articles.map((article) => article.category).toSet().toList();
    return ['Tất cả', ...categories];
  }

  static List<FeaturedArticle> getFeaturedOnly() {
    return getFeaturedArticles().where((article) => article.isFeatured == true).toList();
  }

  static List<FeaturedArticle> searchArticles(String query) {
    final articles = getFeaturedArticles();
    return articles.where((article) => 
      article.title.toLowerCase().contains(query.toLowerCase()) ||
      article.subtitle.toLowerCase().contains(query.toLowerCase()) ||
      article.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
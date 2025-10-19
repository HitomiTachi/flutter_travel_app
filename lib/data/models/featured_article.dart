class FeaturedArticle {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String author;
  final DateTime publishDate;
  final int readTime; // minutes
  final String category;
  final int likes;
  final bool isFeatured;

  FeaturedArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.author,
    required this.publishDate,
    required this.readTime,
    required this.category,
    required this.likes,
    this.isFeatured = false,
  });

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(publishDate);
    
    if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} tuần trước';
    } else {
      return '${(difference.inDays / 30).floor()} tháng trước';
    }
  }
}
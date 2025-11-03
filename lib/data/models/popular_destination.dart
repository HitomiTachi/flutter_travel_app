class PopularDestination {
  final String id;
  final String name;
  final String country;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final bool isPopular;

  PopularDestination({
    required this.id,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.isPopular = false,
  });
}
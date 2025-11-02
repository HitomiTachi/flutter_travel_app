class LikeFilterModel {
  final String label;
  final String? iconKey;

  const LikeFilterModel({
    required this.label,
    this.iconKey,
  });
}

// Danh sách filter mặc định cho tầng 1
const List<LikeFilterModel> kDefaultLikeFilters = [
  LikeFilterModel(label: 'Gợi ý'),
  LikeFilterModel(label: 'Việt Nam', iconKey: 'vietnam'),
  LikeFilterModel(label: 'Nước ngoài', iconKey: 'world'),
  LikeFilterModel(label: 'Chủ đề', iconKey: 'category'),
  LikeFilterModel(label: 'Gần bạn', iconKey: 'location'),
];

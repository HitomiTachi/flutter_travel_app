import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/review_model.dart';
import 'package:flutter_travels_apps/services/review_service.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/review_widgets/review_summary_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/review_widgets/review_card.dart';
import 'package:flutter_travels_apps/representation/widgets/review_widgets/review_filter_bar.dart';

/// Màn hình hiển thị danh sách reviews cho một địa điểm
class DestinationReviewsScreen extends StatefulWidget {
  final String destinationId;
  final String destinationName;
  final String targetType;

  const DestinationReviewsScreen({
    Key? key,
    required this.destinationId,
    required this.destinationName,
    this.targetType = 'location',
  }) : super(key: key);

  static const String routeName = '/destination_reviews';

  @override
  State<DestinationReviewsScreen> createState() => _DestinationReviewsScreenState();
}

class _DestinationReviewsScreenState extends State<DestinationReviewsScreen>
    with TickerProviderStateMixin {
  final ReviewService _reviewService = ReviewService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<ReviewModel> _allReviews = [];
  List<ReviewModel> _filteredReviews = [];
  bool _isLoading = true;
  
  // Filter states
  ReviewSortType _selectedSort = ReviewSortType.newest;
  TripType _selectedTripType = TripType.all;
  double? _selectedMinRating;
  bool _showVerifiedOnly = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _loadReviews();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    
    try {
      // Tạm thời sử dụng mock data thay vì Firestore
      // TODO: Cần tạo Firestore index để query hoạt động
      final reviews = await _getMockReviews();
      
      setState(() {
        _allReviews = reviews;
        _applyFilters();
        _isLoading = false;
      });
      
      _animationController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải đánh giá: $e')),
        );
      }
    }
  }

  // Mock data để tránh lỗi Firestore index
  Future<List<ReviewModel>> _getMockReviews() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      // Trả về empty list vì chưa có dữ liệu thật
    ];
  }

  void _applyFilters() {
    var filtered = List<ReviewModel>.from(_allReviews);
    
    // Filter by trip type
    filtered = _reviewService.filterByTripType(
      filtered,
      tripType: _selectedTripType.value,
    );
    
    // Filter by rating
    if (_selectedMinRating != null) {
      filtered = _reviewService.filterByRating(
        filtered,
        minRating: _selectedMinRating!,
      );
    }
    
    // Filter by verified
    if (_showVerifiedOnly) {
      filtered = _reviewService.filterByVerified(
        filtered,
        isVerified: true,
      );
    }
    
    // Sort
    filtered = _reviewService.sortReviews(
      filtered,
      sortType: _selectedSort,
    );
    
    setState(() {
      _filteredReviews = filtered;
    });
  }

  void _handleHelpfulYes(String reviewId) async {
    try {
      await _reviewService.toggleHelpful(reviewId, true);
      _loadReviews();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  void _handleHelpfulNo(String reviewId) async {
    try {
      await _reviewService.toggleHelpful(reviewId, false);
      _loadReviews();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final averageRating = _allReviews.isEmpty
        ? 0.0
        : _allReviews.fold<double>(0.0, (sum, r) => sum + r.rating) / _allReviews.length;
    final ratingDistribution = _reviewService.getRatingDistribution(_allReviews);
    final recommendedPercentage = _reviewService.getRecommendedPercentage(_allReviews);

    return Scaffold(
      body: Stack(
        children: [
          // AppBar
          AppBarContainerWidget(
            titleString: widget.destinationName,
            implementLeading: true,
            child: Container(),
          ),
          
          // Content
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allReviews.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.rate_review_outlined,
                        title: 'Chưa có đánh giá',
                        subtitle: 'Hãy là người đầu tiên đánh giá địa điểm này!',
                        // Ẩn nút "Viết đánh giá"
                        // actionButton: ElevatedButton.icon(
                        //   onPressed: () {
                        //     // Navigate to WriteReviewScreen
                        //   },
                        //   icon: const Icon(Icons.edit),
                        //   label: const Text('Viết đánh giá'),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: ColorPalette.primaryColor,
                        //     foregroundColor: Colors.white,
                        //   ),
                        // ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            // Summary
                            Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: ReviewSummaryWidget(
                                averageRating: averageRating,
                                totalReviews: _allReviews.length,
                                ratingDistribution: ratingDistribution,
                                recommendedPercentage: recommendedPercentage,
                              ),
                            ),
                            
                            // Filter bar
                            ReviewFilterBar(
                              selectedSort: _selectedSort,
                              selectedTripType: _selectedTripType,
                              selectedMinRating: _selectedMinRating,
                              showVerifiedOnly: _showVerifiedOnly,
                              onSortChanged: (sort) {
                                setState(() => _selectedSort = sort);
                                _applyFilters();
                              },
                              onTripTypeChanged: (tripType) {
                                setState(() => _selectedTripType = tripType);
                                _applyFilters();
                              },
                              onMinRatingChanged: (rating) {
                                setState(() => _selectedMinRating = rating);
                                _applyFilters();
                              },
                              onVerifiedChanged: (verified) {
                                setState(() => _showVerifiedOnly = verified);
                                _applyFilters();
                              },
                            ),
                            
                            // Reviews list
                            Expanded(
                              child: _filteredReviews.isEmpty
                                  ? EmptyStateWidget(
                                      icon: Icons.filter_alt_off,
                                      title: 'Không tìm thấy đánh giá',
                                      subtitle: 'Thử thay đổi bộ lọc để xem thêm đánh giá',
                                      actionButton: TextButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _selectedSort = ReviewSortType.newest;
                                            _selectedTripType = TripType.all;
                                            _selectedMinRating = null;
                                            _showVerifiedOnly = false;
                                          });
                                          _applyFilters();
                                        },
                                        icon: const Icon(Icons.clear_all),
                                        label: const Text('Xóa bộ lọc'),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(kDefaultPadding),
                                      itemCount: _filteredReviews.length,
                                      itemBuilder: (context, index) {
                                        final review = _filteredReviews[index];
                                        return ReviewCard(
                                          review: review,
                                          onHelpfulYes: () => _handleHelpfulYes(review.id),
                                          onHelpfulNo: () => _handleHelpfulNo(review.id),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to WriteReviewScreen
          // Navigator.pushNamed(
          //   context,
          //   WriteReviewScreen.routeName,
          //   arguments: {
          //     'destinationId': widget.destinationId,
          //     'destinationName': widget.destinationName,
          //   },
          // );
        },
        backgroundColor: ColorPalette.primaryColor,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(
          'Viết đánh giá',
          style: TextStyles.defaultStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

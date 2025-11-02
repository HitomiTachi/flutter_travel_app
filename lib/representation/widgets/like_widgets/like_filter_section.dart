import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';

class LikeFilterSection extends StatefulWidget {
  final TabController tabController; // 3 tab nhóm chính - Tầng 1
  final List<String> allFilters; // Tất cả filters gộp chung - Tầng 2
  final int selectedFilterIndex; // Index filter đang chọn
  final ValueChanged<int> onFilterSelected; // Callback khi chọn filter
  final bool showFilters; // Hiển thị/ẩn tầng 2

  const LikeFilterSection({
    Key? key,
    required this.tabController,
    required this.allFilters,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
    this.showFilters = true,
  }) : super(key: key);

  @override
  State<LikeFilterSection> createState() => _LikeFilterSectionState();
}

class _LikeFilterSectionState extends State<LikeFilterSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      vsync: this,
    );

    // Slide từ dưới lên (0, 0.5) -> (0, 0)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    // Fade từ 0 -> 1
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));

    // Khởi động animation nếu showFilters = true
    if (widget.showFilters) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(LikeFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showFilters != oldWidget.showFilters) {
      if (widget.showFilters) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tầng 1: TabBar 3 nhóm chính (Địa danh / Bài viết / Lịch trình)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kItemPadding),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(4),
          child: TabBar(
            controller: widget.tabController,
            labelColor: Colors.white,
            unselectedLabelColor: ColorPalette.primaryColor,
            labelStyle: TextStyles.defaultStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyles.defaultStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            indicator: BoxDecoration(
              color: ColorPalette.primaryColor,
              borderRadius: BorderRadius.circular(kTopPadding),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: kMinPadding),
                  child: Text('Địa danh'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: kMinPadding),
                  child: Text('Bài viết'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: kMinPadding),
                  child: Text('Lịch trình'),
                ),
              ),
            ],
          ),
        ),
        
        // Tầng 2: All filters - SlideTransition (từ dưới lên) + FadeTransition
        ClipRect(
          child: AnimatedSize(
            duration: Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            child: widget.showFilters && widget.allFilters.isNotEmpty
              ? SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: EdgeInsets.only(top: kDefaultPadding),
                      padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kMinPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(kItemPadding),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            widget.allFilters.length,
                            (index) {
                              final isSelected = index == widget.selectedFilterIndex;
                              
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index < widget.allFilters.length - 1 
                                    ? kMediumPadding 
                                    : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () => widget.onFilterSelected(index),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding,
                                      vertical: kMinPadding,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected 
                                        ? ColorPalette.primaryColor 
                                        : ColorPalette.backgroundScaffoldColor,
                                      borderRadius: BorderRadius.circular(kTopPadding * 2),
                                      border: Border.all(
                                        color: isSelected
                                          ? ColorPalette.primaryColor
                                          : Colors.transparent,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      widget.allFilters[index],
                                      style: TextStyles.defaultStyle.copyWith(
                                        fontSize: 13,
                                        fontWeight: isSelected 
                                          ? FontWeight.bold 
                                          : FontWeight.w600,
                                        color: isSelected
                                          ? Colors.white
                                          : ColorPalette.subTitleColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

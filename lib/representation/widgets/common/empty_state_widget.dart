import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';


class EmptyStateWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? subtitle;
  final Widget? actionButton;
  final String? iconAsset;
  final double? iconSize;
  
  const EmptyStateWidget({
    Key? key,
    required this.title,
    this.icon,
    this.subtitle,
    this.actionButton,
    this.iconAsset,
    this.iconSize,
  }) : super(key: key);

  double get _effectiveIconSize => iconSize ?? 64.0;
  Color get _iconColor => ColorPalette.subTitleColor.withOpacity(0.5);
  
  TextStyle get _titleStyle => TextStyles.defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ColorPalette.textColor,
  );
  
  TextStyle get _subtitleStyle => TextStyles.defaultStyle.copyWith(
    fontSize: 14,
    color: ColorPalette.subTitleColor,
    height: 1.4,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIconSection(),
            const SizedBox(height: kDefaultPadding),
            
            Text(
              title,
              style: _titleStyle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: kMinPadding),
              Text(
                subtitle!,
                style: _subtitleStyle,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            if (actionButton != null) ...[
              const SizedBox(height: kMediumPadding),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildIconSection() {
    if (iconAsset != null) {
      return Image.asset(
        iconAsset!,
        width: _effectiveIconSize,
        height: _effectiveIconSize,
        fit: BoxFit.contain,
      );
    }
    
    return Icon(
      icon ?? Icons.inbox_outlined,
      size: _effectiveIconSize,
      color: _iconColor,
    );
  }
}

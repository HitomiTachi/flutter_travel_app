import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';

/// Widget dấu tick chọn cho edit mode
class SelectableMark extends StatelessWidget {
  final bool visible;
  final bool selected;
  
  const SelectableMark({
    Key? key,
    required this.visible,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? ColorPalette.primaryColor : Colors.white,
          border: Border.all(color: ColorPalette.primaryColor, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 22,
        height: 22,
        child: Icon(
          selected ? Icons.check : Icons.circle_outlined,
          size: 14,
          color: selected ? Colors.white : ColorPalette.primaryColor,
        ),
      ),
    );
  }
}

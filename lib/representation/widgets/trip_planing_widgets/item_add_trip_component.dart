import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';

class ItemAddTripComponent extends StatefulWidget {
  const ItemAddTripComponent({
    Key? key,
    required this.title,
    required this.icon,
    required this.innitData,
    this.onValueChanged,
    this.maxValue = 100, // Giới hạn tối đa cho một số thành phần
    this.minValue = 1,   // Giới hạn tối thiểu
  }) : super(key: key);

  final String title;
  final String icon;
  final int innitData;
  final int maxValue;
  final int minValue;
  final Function(int)? onValueChanged;

  @override
  State<ItemAddTripComponent> createState() => _ItemAddTripComponentState();
}

class _ItemAddTripComponentState extends State<ItemAddTripComponent> {
  late final TextEditingController _textEditingController;
  final FocusNode _focusNode = FocusNode();
  late int number;

  @override
  void initState() {
    super.initState();
    number = widget.innitData;
    _textEditingController = TextEditingController(text: widget.innitData.toString())
      ..addListener(() {
        final v = int.tryParse(_textEditingController.text);
        if (v != null && v >= widget.minValue && v <= widget.maxValue) {
          number = v;
          widget.onValueChanged?.call(number);
        }
      });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kTopPadding),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      padding: const EdgeInsets.all(kMediumPadding),
      child: Row(
        children: [
          // 1) Icon cho thành phần chuyến đi
          ImageHelper.loadFromAsset(
            widget.icon,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: kDefaultPadding),

          // 2) Tiêu đề thành phần chuyến đi
          Expanded(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 3) Nút giảm
          GestureDetector(
            onTap: () {
              if (number > widget.minValue) {
                setState(() {
                  number--;
                  _textEditingController.text = number.toString();
                  if (_focusNode.hasFocus) _focusNode.unfocus();
                });
                widget.onValueChanged?.call(number);
              }
            },
            child: ImageHelper.loadFromAsset(
              AssetHelper.icoMinusButton,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),

          // 4) Ô nhập số
          Container(
            height: 35,
            width: 60,
            padding: const EdgeInsets.only(left: 3),
            alignment: Alignment.center,
            child: TextField(
              controller: _textEditingController,
              textAlign: TextAlign.center,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 18),
              ),
            ),
          ),

          // 5) Nút tăng
          GestureDetector(
            onTap: () {
              if (number < widget.maxValue) {
                setState(() => number++);
                _textEditingController.text = number.toString();
                if (_focusNode.hasFocus) _focusNode.unfocus();
                widget.onValueChanged?.call(number);
              }
            },
            child: ImageHelper.loadFromAsset(
              AssetHelper.icoPlusButton,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
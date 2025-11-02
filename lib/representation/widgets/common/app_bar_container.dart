import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarContainerWidget extends StatelessWidget {
  const AppBarContainerWidget({
    Key? key,
    required this.child,
    this.title,
    this.implementLeading = false,
    this.titleString,
    this.implementTraling = false,
  }) : super(key: key);

  final Widget child;
  final Widget? title;
  final String? titleString;
  final bool implementLeading;
  final bool implementTraling;

  @override
  Widget build(BuildContext context) {
    // GIỮ NGUYÊN: vẫn là Scaffold như code Nhân
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 186,
            child: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 90,
              backgroundColor: ColorPalette.backgroundScaffoldColor,
              // ĐIỂM GHÉP TỪ CODE 2: title thông minh hơn
              title: title ??
                  Row(
                    children: [
                      // 1. NÚT BACK: giữ nguyên từ code Nhân
                      if (implementLeading)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultPadding),
                              ),
                            ),
                            padding: EdgeInsets.all(kItemPadding),
                            child: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.black,
                              size: kDefaultIconSize,
                            ),
                          ),
                        ),

                      // 2. TITLE Ở GIỮA: cải tiến từ code Danh (maxLines + ellipsis)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                titleString ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                maxLines: 1, // (A) từ code Danh
                                overflow: TextOverflow.ellipsis, // (A) từ code Danh
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 3. NÚT TRÊN PHẢI: giữ từ code Nhân
                      if (implementTraling)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              kDefaultPadding,
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(kItemPadding),
                          child: Icon(
                            FontAwesomeIcons.bars,
                            size: kDefaultIconSize,
                            color: Colors.black,
                          ),
                        )
                      // (B) từ code Danh: nếu CÓ nút back nhưng KHÔNG có nút trailing
                      // thì chèn 1 box trống để title thật sự ở giữa
                      else if (implementLeading && !implementTraling)
                        Container(
                          width: kDefaultPadding + (kItemPadding * 2) - 12,
                        ),
                    ],
                  ),
              // GIỮ từ code Nhân
              flexibleSpace: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: Gradients.defaultGradientBackground,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        // bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // GIỮ từ code Nhân
          Container(
            margin: const EdgeInsets.only(top: 156),
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: child,
          ),
        ],
      ),
    );
  }
}

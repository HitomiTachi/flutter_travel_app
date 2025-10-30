import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarContainerWidget extends StatelessWidget{
  const AppBarContainerWidget({Key? key, required this.child, this.title, this.implementLeading = false, this.titleString, this.implementTraling = false}) : super(key: key);

  final Widget child;
  final Widget? title;
  final String? titleString;
  final bool implementLeading;
  final bool implementTraling;

  @override
  Widget build(BuildContext context) {
    // --- SỬA LỖI: Xóa 'Scaffold' và 'body:' ---
    // return Scaffold(
    //       body: Stack(
    return Stack(
      children: [
        SizedBox(
          height: 186,
          child: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 90,
            backgroundColor: ColorPalette.backgroundScaffoldColor,
            title: title ??
            Row(
              children: [
                if(implementLeading)
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
                        size: kDefaultIconSize,),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          titleString ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
                          color: Colors.white ),
                          maxLines: 1, // Thêm để tránh tràn
                          overflow: TextOverflow.ellipsis, // Thêm để tránh tràn
                        ),
                      ],
                    ),
                  ),
                ),
                if(implementTraling)
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
                      color: Colors.black,),
                  )
                // --- THÊM: Spacer để giữ title ở giữa nếu chỉ có nút back ---
                else if (implementLeading && !implementTraling)
                  Container(
                    width: kDefaultPadding + (kItemPadding * 2) - 12, // Căn chỉnh cho bằng nút back
                  ),
              ],
            ),
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
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 156),
          padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
          child: child,
        )
      ],
    );
    // );
    // --- KẾT THÚC SỬA LỖI ---
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
<<<<<<< HEAD
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarContainerWidget extends StatelessWidget{
  const AppBarContainerWidget({Key? key, required this.child, this.title, this.implementLeading = false, this.titleString, this.implementTraling = false}) : super(key: key);
=======
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
>>>>>>> 72ffec4 (Initial commit)

  final Widget child;
  final Widget? title;
  final String? titleString;
  final bool implementLeading;
  final bool implementTraling;

  @override
  Widget build(BuildContext context) {
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
<<<<<<< HEAD
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
                            color: Colors.white )
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
                  ),
                ],
                ),
=======
              title:
                  title ??
                  Row(
                    children: [
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
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                titleString ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                        ),
                    ],
                  ),
>>>>>>> 72ffec4 (Initial commit)
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
<<<<<<< HEAD
                  )
=======
                  ),
>>>>>>> 72ffec4 (Initial commit)
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 156),
            padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: child,
<<<<<<< HEAD
          )
=======
          ),
>>>>>>> 72ffec4 (Initial commit)
        ],
      ),
    );
  }
}

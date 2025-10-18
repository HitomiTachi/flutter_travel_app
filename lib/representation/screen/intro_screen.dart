import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/representation/screen/main_app.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  static const String routeName = '/intro_screen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {


  final PageController _pageController = PageController();
  final StreamController<int> _pageStreamController = StreamController<int>.broadcast();
  void initState(){
    super.initState();
    _pageController.addListener((){
    _pageStreamController.add(_pageController.page!.toInt());

    });
  }
Widget _buildItemIntroScreen(String image, String title, String description,Alignment alignment) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        alignment: alignment,
        child: ImageHelper.loadFromAsset(
        image,
        height: 375,
        fit: BoxFit.fitHeight,
      ),
      ),
      const SizedBox(
        height: kMediumPadding * 2,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kMediumPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: TextStyles.defaultStyle.bold,
            ),
            const SizedBox(
        height: kMediumPadding,
            ),
            Text(description,style: TextStyles.defaultStyle,)
        ],
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              _buildItemIntroScreen(AssetHelper.image1,'Explore the World','Discover new places and adventures with our travel app.', Alignment.centerRight),
              _buildItemIntroScreen(AssetHelper.image2,'Plan Your Trip','Easily plan your itinerary and book accommodations.', Alignment.center),
              _buildItemIntroScreen(AssetHelper.image3,'Share Your Journey','Connect with fellow travelers and share your experiences.', Alignment.centerLeft),
            ],
          ),
          Positioned(
            left: kMediumPadding,
            right: kMediumPadding,
            bottom: kMediumPadding * 2,
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child:
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.orange,
                    dotHeight: kMinPadding,
                    dotWidth: kMinPadding,
                  ),
                ),
                ),
                StreamBuilder<int>(
                  initialData: 0,
                  stream: _pageStreamController.stream,
                  builder: (context, snapshot) {
                    return Expanded(
                      flex: 4,
                      child: ButtonWidget(
                        title: snapshot.data != 2 ? 'Tiếp Tục' : 'Bắt Đầu',
                        onTap: () {
                          if(_pageController.page !=2){
                            _pageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                          } else {
                            Navigator.of(context).pushNamed(MainApp.routeName);
                          }
                        },
                    ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

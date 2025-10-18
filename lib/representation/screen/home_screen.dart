import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();

}
  class _HomeScreenState extends State<HomeScreen>{

    Widget _buildItemCategory(Widget icon, Color color, Function() onTap, String title){
      return GestureDetector(
        onTap: onTap,
        child: Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.symmetric(
                  vertical: kMediumPadding,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(kItemPadding)
                ),
                child: Center(child: icon),
              ),
              SizedBox(height: kDefaultPadding / 2),
              Container(
                height: 32,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context){
      return AppBarContainerWidget(
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Xin Chào! ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
                    color: Colors.white )
                    ),
                    SizedBox(
                      height: kMediumPadding,
                    ),
                    Text('Hãy tạo kế hoạch chuyến đi của bạn! ',
                    style: TextStyle(
                      fontSize: 14,)
                    ),
                    
                ],
              ),
              Spacer(),
              Icon(
                FontAwesomeIcons.bell,
                size: kDefaultIconSize,
                color: Colors.white,
              ),
              SizedBox(width: kTopPadding,),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(kItemPadding),
                color: Colors.white
                ),
                padding: EdgeInsets.all(kTopPadding),
                child: ImageHelper.loadFromAsset(AssetHelper.person),
              )
            ],
          ),
        ),
        // titleString: 'Home',
        // implementLeading: true,
        // implementTraling: true,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm điểm đến ...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(kTopPadding),
                  child: Icon(FontAwesomeIcons.magnifyingGlass,
                  color: Colors.black,
                  size: kDefaultPadding,),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(kItemPadding),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: kItemPadding,
                  ),
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildItemCategory(
                      ImageHelper.loadFromAsset(AssetHelper.iconlocation,
                      width: kBottomBarIconSize,
                      height: kBottomBarIconSize,),
                      Colors.blue,
                      () {
                        Navigator.of(context).pushNamed('/trip_plans_list_screen');
                      },
                      'Kế hoạch\nchuyến đi',
                    ),
                  ),
                  SizedBox(width: kDefaultPadding,),
                  Expanded(
                    child: _buildItemCategory(
                      ImageHelper.loadFromAsset(AssetHelper.planes,
                      width: kBottomBarIconSize,
                      height: kBottomBarIconSize,),
                      Colors.orange,
                      () {},
                      'Chuyến bay',
                    ),
                  ),
                  SizedBox(width: kDefaultPadding,),
                  Expanded(
                    child: _buildItemCategory(
                      ImageHelper.loadFromAsset(AssetHelper.allservices,
                      width: kBottomBarIconSize,
                      height: kBottomBarIconSize,),
                      Colors.orange,
                      () {},
                      'Tất cả dịch vụ',
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    }
  }
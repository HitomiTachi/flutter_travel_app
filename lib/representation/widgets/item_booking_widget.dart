import "package:flutter/material.dart";
import "package:flutter_travels_apps/core/constants/dismension_constants.dart";

class ItemBookingWidget extends StatelessWidget {
  const ItemBookingWidget({
    super.key,
    required this.icons,
    required this.title,
    required this.description,
    this.onTap,
    this.implementLeading = false,
  });

  final String icons;
  final String title;
  final String description;
  final Function()? onTap;
  final bool implementLeading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
        ),
        child: Row(
          children: [
            Image.asset(icons, width: 30, height: 30),
            SizedBox(width: kDefaultPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                SizedBox(height: kMinPadding),
                Text(
                  description,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// Container
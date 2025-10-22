import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';

class MapScreen extends StatelessWidget {
  static const String routeName = '/map_screen';

  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Bản Đồ',
      // implementLeading: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: Colors.blueAccent),
            SizedBox(height: 24),
            Text(
              'Chức năng bản đồ sẽ được phát triển',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

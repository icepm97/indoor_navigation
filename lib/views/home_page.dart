import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indoor_navigation/views/map_page.dart';
import 'package:indoor_navigation/views/qr_page.dart';
import 'package:indoor_navigation/views/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indoor Navigation'),
      ),
      drawer: appDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRViewExample(),
                  ));
                },
                child: const Text('qrView'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Or"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => {Get.off(MapPage())},
                child: const Text("Browse Map"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: null,
                child: Text("View POIs"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

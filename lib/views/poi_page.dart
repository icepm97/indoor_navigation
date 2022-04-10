import 'package:flutter/material.dart';
import 'package:indoor_navigation/views/widgets/app_drawer.dart';

class PoiPage extends StatelessWidget {
  const PoiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indoor Navigation'),
      ),
      drawer: appDrawer(),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 11 widgets that display their index in the List.
        children: List.generate(11, (index) {
          return  Center(
            child: Card(
              child: SizedBox(
                height: 400,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.place),
                      title: Text('STALL $index'),
                      subtitle:
                      // ignore: todo
                      // TODO: Change the subtitle to relevant shop related text.
                          const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    const Image(image: AssetImage("assets/shop-front.jpeg")),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

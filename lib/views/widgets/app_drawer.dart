import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:indoor_navigation/views/home_page.dart';
import 'package:indoor_navigation/views/map_page.dart';
import 'package:indoor_navigation/views/poi_page.dart';
import 'package:indoor_navigation/views/qr_page.dart';

appDrawer() => Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            child: Center(
              child: Text(
                'Indoor Navigator',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => {
              Get.off(const HomePage()),
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map'),
            onTap: () => {Get.off(MapPage())},
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('POI'),
            onTap: () => {Get.off(PoiPage())},
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('Scan QR Code'),
            onTap: () => {Get.off(const QRViewExample())},
          ),
        ],
      ),
    );

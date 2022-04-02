import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

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
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('POI'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('Scan QR Code'),
            onTap: () => {},
          ),
        ],
      ),
    );

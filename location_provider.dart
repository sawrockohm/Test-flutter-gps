

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps/google_map_page.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  // BitmapDescriptor? _pinIcon;
  // BitmapDescriptor? get pinIcon => _pinIcon;
  // Map<MarkerId, Marker>? _marker;
  // Map<MarkerId, Marker>? get marker => _marker;

  // final MarkerId markerId = MarkerId("1");

  get a => GoogleMapPage.lalg;

  Location? _location;
  Location? get location => _location;
  LatLng? _locationposition;
  LatLng? get locationposition => _locationposition;
  bool locationServiceActive = true;

  LocationProvider() {
    _location = Location();
    log(" come in location ");
  }

  intitalization() async {
    log("getUserLocation");
    await getUserLocation();
    // await setCustomMapPin();
  }

  getUserLocation() async {
    bool? _serviceEnable;
    PermissionStatus? _premissionGranted;

    _serviceEnable = await location?.serviceEnabled();
    log("start check service");
    if (!_serviceEnable!) {
      log("!_serviceEnable! if 1");
      _serviceEnable = await location?.requestService();
      if (!_serviceEnable!) {
        log("!_serviceEnable! if 2");
        return;
      }
    }
    _premissionGranted = await location?.hasPermission();
    if (_premissionGranted == PermissionStatus.denied) {
      _premissionGranted = await location?.requestPermission();
      log("requestPermission");
      if (_premissionGranted != PermissionStatus.granted) {
        log("not requestPermission");
        return;
      }
    } 
    location?.onLocationChanged.listen((LocationData currentLocation) {
      _locationposition = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      // log("-$a"*20);
      log("get locationposition in $_locationposition");
      // if (a == null) {
      //   //visible: false
      //   p("marker is null hide visible");
      //   _marker = <MarkerId, Marker>{};
      //   Marker marker = Marker(
      //       visible: false,
      //       markerId: markerId,
      //       position: LatLng(
      //         currentLocation.latitude!,
      //         currentLocation.longitude!,
      //       ),
      //       );
      //   _marker?[markerId] = marker;
      // } else {
      //   //visible: true
      //   p("marker is $a show visible");
      //   _marker = <MarkerId, Marker>{};
      //   Marker marker = Marker(
      //       visible: true,
      //       markerId: markerId,
      //       position: a, //position on save
      //       icon: pinIcon!,
      //       draggable: true,
      //       onDragEnd: ((newPosition) {
      //         //new position on onDragEnd
      //         _locationposition = LatLng(
      //           newPosition.latitude,
      //           newPosition.longitude,
      //         );
      //         log("get new draggable locationposition in $_locationposition");
      //         // notifyListeners();
      //       }));
      //   _marker?[markerId] = marker;

      //   notifyListeners();
      // }
      //18.7577241,99.0017479

      notifyListeners();
    });
  }

  // setCustomMapPin() async {
  //   _pinIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5), 'assets/Rider_1.png');
  // }
}

void p(a) {
  print('\x1B[31m$a\x1B[0m');
}

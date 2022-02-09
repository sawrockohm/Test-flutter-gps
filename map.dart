import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  LatLng _initialPosition = LatLng(18.756984868142588, 99.00229314197271);
  late GoogleMapController _controller;
  Location _locationTracker = Location();
  late Marker marker;
  late StreamSubscription _locationSubscription;

  // void _onMapCreated(GoogleMapController _cntrl) {
  //   _controller = _cntrl;
  //   _locationTracker.onLocationChanged.listen((l) {
  //     _controller.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: LatLng(18.844426934658223, 99.13696326047771),
  //           zoom: 15,
  //         ),
  //       ),
  //     );
  //   });
  // }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(18.844426934658223, 99.13696326047771),
    zoom: 14,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_icon2.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarker(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng =
        LatLng(newLocalData.latitude ?? 0.0, newLocalData.longitude ?? 0.0);
    this.setState(
      () {
        marker = Marker(
          markerId: MarkerId('1'),
          position: latlng,
          rotation: newLocalData.heading ?? 0.0,
          draggable: false,
          flat: true,
          zIndex: 2,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData),
        );
      },
    );
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      updateMarker(location, imageData);
      // ignore: unnecessary_null_comparison
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        // ignore: unnecessary_null_comparison
        if (_controller != null) {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(newLocalData.latitude ?? 0.0,
                    newLocalData.longitude ?? 0.0),
                tilt: 0,
                zoom: 18,
              ),
            ),
          );
          updateMarker(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          // markers: Set.of((marker != null) ? [marker] : []),
          myLocationEnabled: true,
           
          myLocationButtonEnabled: true,
          // myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          }),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.location_searching),
      //   onPressed: () {
      //     getCurrentLocation();
      //   },
      // ),
    );
  }
}

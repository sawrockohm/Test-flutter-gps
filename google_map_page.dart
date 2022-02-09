import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps/provider/location_provider.dart';
import 'package:provider/provider.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);
  static LatLng? lalg;
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {

  @override
  void initState() {  //เรียก location_provider
    super.initState();
    log("state 1 find location!!!");
    Provider.of<LocationProvider>(context, listen: false).intitalization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map Live Tracking"),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 650,
              width: double.infinity,
              child: googleMapUi(),
            ),
          ],
        ),
      ),
    );
  }

  Widget googleMapUi() { //สร้างแมพ
    return Consumer<LocationProvider>(builder: (  
      ctx,  //contex
      model,  //เก็บตัวแปลในหน้า location_provider
      child,
    ) {
      log("in home page location = ${model.locationposition}");
      if (model.locationposition != null) {
        log("this ctx$ctx");
        log("this model$model");
        log("this child$child");
        log("this ok");
        log("This location");
        // LatLng(18.7527051, 99.0166389)
        return Column(
          children: [
            Expanded(
              child: StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: model.locationposition!, zoom: 18), 
                          //model.locationposition! ตำแหน่งล่าสุด
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      // markers: Set<Marker>.of(model.marker!.values),
                      onMapCreated: (GoogleMapController controller) {},
                    );
                  }),
            ),
            TextButton(
              onPressed: () {
                GoogleMapPage.lalg = model.locationposition!;
                log("log tesr ==> ${GoogleMapPage.lalg}");
                // p("${model.marker!.values}");
              },
              child: const Text("Save location"),
            ),
          ],
        );
      } else {
        log("somthing went wrong");
        log("location false = ${model.locationposition}");
        print("model.locationposition = ${model.locationposition}");
        print("model = ${model}");
      }
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}

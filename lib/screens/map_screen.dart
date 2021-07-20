import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sarthi/provider/location_provider.dart';
import 'package:sarthi/screens/homeScreen.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentlocation;
  GoogleMapController _mapController;
  bool _loggedIn = false;
  bool _locating = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    setState(() {
      currentlocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: currentlocation, zoom: 19.151926040649414),
          zoomControlsEnabled: false,
          minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          mapToolbarEnabled: true,
          onCameraMove: (CameraPosition position) {
            setState(() {
              _locating = true;
            });
            locationData.onCameraMove(position);
          },
          onMapCreated: onCreated,
          onCameraIdle: () {
            setState(() {
              _locating = false;
            });
            locationData.getMoveCamera();
          },
        ),
        Center(
          child: Container(
            height: 50,
            margin: EdgeInsets.only(bottom: 40),
            child: Image.asset(
              'images/markerr.png',
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [
                _locating
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      )
                    : Container(),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.location_searching,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Flexible(
                      child: Text(
                        _locating
                            ? 'Locating.....'
                            : locationData.selectedAddress.featureName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    _locating ? '' : locationData.selectedAddress.addressLine,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: AbsorbPointer(
                      absorbing: _locating ? true : false,
                      child: FlatButton(
                          onPressed: () {
                            if (_loggedIn == false) {
                              Navigator.pushNamed(context, HomeScreen.id);
                            } else {}
                          },
                          color: _locating
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                          child: Text(
                            'CONFIRM LOCATION',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    )));
  }
}

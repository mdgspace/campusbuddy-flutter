import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'events.dart';

Set<Marker> _createMarker(double latitude, double longitude) {
  return <Marker>[
    Marker(
      markerId: MarkerId("destination"),
      position: LatLng(latitude, longitude),
      icon: BitmapDescriptor.defaultMarker,
    )
  ].toSet();
}

class Gmaps extends StatefulWidget {
  double longitude;
  double latitude;

  Gmaps({Key key, this.latitude, this.longitude}) : super(key: key);

  @override
  _GmapsState createState() => _GmapsState();
}

class _GmapsState extends State<Gmaps> {
  GoogleMapController myController;
  final LatLng _center = const LatLng(29.864553512846367, 77.89656284648702);

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
            mapType: _currentMapType,
            markers: _createMarker(widget.latitude, widget.longitude),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                onPressed: _onMapTypeButtonPressed,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.green,
                child: Icon(Icons.map, size: 30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  MapPage({this.initialLatitude, this.initialLongitude});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedLocation = LatLng(widget.initialLatitude!, widget.initialLongitude!);
      _markers.add(
        Marker(
          markerId: MarkerId('selectedLocation'),
          position: _selectedLocation!,
          infoWindow: InfoWindow(title: 'Selected Location'),
        ),
      );
    }
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selectedLocation'),
          position: location,
          infoWindow: InfoWindow(title: 'Selected Location'),
        ),
      );
      _moveCamera(location); // Move camera to the selected location
    });
  }

  void _moveCamera(LatLng location) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLng(location),
      );
    }
  }

  void _onOkPressed() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text('Select Location'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? LatLng(-7.052026, 110.435291),
              zoom: 15,
            ),
            markers: _markers,
            onTap: _onMapTap,
          ),
          Positioned(
            bottom: 27,
            left: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              onPressed: _onOkPressed,
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}

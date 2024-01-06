import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  final LatLng pDestination;
  const MapPage({super.key, required this.pDestination});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Location _locationController = Location();
  Set<Marker> markers = {}; // Add this line to declare the markers set

  // static const LatLng _pSchool = LatLng(10.8506377, 106.7693382);

  late LatLng _currentP = LatLng(0.0, 0.0);

  Map<PolylineId, Polyline> polylines = {};
  late double distance = 0.0;

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((currentLocation) {
      setState(() {
        _currentP = currentLocation;
      });
      getPolylinePoints().then(
        (coordinates) {
          generatePolylineFromPoints(coordinates);
        },
      );

      calculateDistance().then((result) {
        setState(() {
          distance = result;
        });
      });
    });
  }

  Future<LatLng> getCurrentLocation() async {
    LocationData currentLocation =
        await _locationController.getLocation(); // Sử dụng package location
    return LatLng(currentLocation.latitude!, currentLocation.longitude!);
  }

  Future<BitmapDescriptor> _getMarkerIcon(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes,
        targetHeight: 90, targetWidth: 90);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? buffer =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);

    if (buffer != null) {
      final ByteData circularBuffer = await createCircularImage(buffer);
      return BitmapDescriptor.fromBytes(circularBuffer.buffer.asUint8List());
    } else {
      throw 'Error loading marker icon';
    }
  }

  Future<ByteData> createCircularImage(ByteData originalBuffer) async {
    final ui.Codec originalCodec =
        await ui.instantiateImageCodec(originalBuffer.buffer.asUint8List());
    final ui.Image originalImage = (await originalCodec.getNextFrame()).image;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint()
      ..shader = ImageShader(originalImage, TileMode.clamp, TileMode.clamp,
          Matrix4.identity().storage);
    canvas.drawCircle(
      Offset(originalImage.width / 2, originalImage.height / 2),
      originalImage.width / 2,
      paint,
    );

    final picture = recorder.endRecording();
    final img =
        await picture.toImage(originalImage.width, originalImage.height);
    final ByteData? buffer =
        await img.toByteData(format: ui.ImageByteFormat.png);

    if (buffer != null) {
      return buffer;
    } else {
      throw 'Error creating circular image';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<BitmapDescriptor>(
        future: _getMarkerIcon('assets/images/Lan.jpg'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              return GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _currentP, zoom: 13),
                markers: {
                  Marker(
                    markerId: MarkerId("_currentLocation"),
                    icon: snapshot.data!,
                    position: _currentP,
                    infoWindow: InfoWindow(
                      title: 'Travel Information',
                      snippet: 'Distance: ${distance.toStringAsFixed(2)} km',
                    ),
                  ),
                  Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: widget.pDestination,
                  ),
                },
                polylines: Set<Polyline>.of(polylines.values),
              );
            } else {
              return Center(child: Text('Error loading marker icon'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          GOOGLE_MAPS_API_KEY,
          PointLatLng(_currentP.latitude, _currentP.longitude),
          PointLatLng(
              widget.pDestination.latitude, widget.pDestination.longitude),
          travelMode: TravelMode.driving);

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        if (result.errorMessage != null) {
        } else {}
      }
      return polylineCoordinates;
    } catch (e) {
      return [];
    }
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");

    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 5);

    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<double> calculateDistance() async {
    double distance =  Geolocator.distanceBetween(
      _currentP.latitude,
      _currentP.longitude,
      widget.pDestination.latitude,
      widget.pDestination.longitude,
    );

    return distance / 1000;
  }

  //CHUYỂN ĐỔI PLACE_DETAIL THÀNH 1 TỌA ĐỘ
}

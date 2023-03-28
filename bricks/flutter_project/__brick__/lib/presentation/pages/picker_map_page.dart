import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:{{appName.snakeCase()}}/presentation/controller/add_story_controller.dart';

class PickerMapPage extends StatefulWidget {
  const PickerMapPage({super.key});

  @override
  State<PickerMapPage> createState() => _PickerMapPageState();
}

class _PickerMapPageState extends State<PickerMapPage> {
  /// todo-01-01: define a variables
  var targetPosition = const LatLng(0, 0);

  late GoogleMapController mapController;

  late final Set<Marker> markers = {};

  /// todo-04-02: define a placemark to store a location's address
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        /// todo-01-02: add google maps widget
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: targetPosition,
              ),

              markers: markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,

              /// todo-02-12: show the device location's marker
              myLocationEnabled: true,

              /// todo-01-03: setup controller and marker
              /// todo-04-07: do reverse geocoding in onMapCreated callback
              onMapCreated: (controller) async {
                setState(() {
                  mapController = controller;
                });

                Position position = await _determinePosition();
                final latLng = LatLng(position.latitude, position.longitude);

                mapController.animateCamera(
                  CameraUpdate.newLatLng(latLng),
                );

                setState(() {
                  targetPosition = latLng;
                });

                final info = await geo.placemarkFromCoordinates(
                    targetPosition.latitude, targetPosition.longitude);

                final place = info[0];
                final street = place.street!;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                setState(() {
                  placemark = place;
                });

                defineMarker(targetPosition, street, address);
              },

              /// todo-03-01: setup callback onLongPress
              onLongPress: (LatLng latLng) => onLongPressGoogleMap(latLng),
            ),

            /// todo-02-05: create a FAB widget
            Positioned(
              top: 100,
              right: 16,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () => onMyLocationButtonPress(),
              ),
            ),

            /// todo-05-04: show the widget
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: PlacemarkWidget(
                  placemark: placemark!,
                  latLng: targetPosition,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// todo-04-06: do reverse geocoding in onLongPressGoogleMap function
  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
      targetPosition = latLng;
    });

    /// todo-03-02: set a marker based on new lat-long
    defineMarker(latLng, street, address);

    /// todo-03-03: animate a map view based on a new latLng
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void onMyLocationButtonPress() async {
    /// todo-02-09: get the current device location
    Position position = await _determinePosition();
    final latLng = LatLng(position.latitude, position.longitude);

    /// todo-04-03: run the reverse geocoding
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    /// todo-04-04: define a name and address of location
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    /// todo-02-10: set a marker
    /// todo-04-05: show the information of location's place and add new argument
    defineMarker(latLng, street, address);

    /// todo-02-11: animate a map view based on a new latLng
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  /// todo--02: define a marker based on a new latLng
  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    /// todo--03: clear and add a new marker
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}

/// todo-05-01: create a location's place widget
class PlacemarkWidget extends StatelessWidget {
  final AddStoryController _addStoryController = Get.find();

  PlacemarkWidget({
    super.key,
    required this.placemark,
    required this.latLng,
  });

  /// todo-05-02: create a variable
  final geo.Placemark placemark;
  final LatLng latLng;

  @override
  Widget build(BuildContext context) {
    return Container(
      /// todo-05-03: show the information
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      placemark.street!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              double lat = latLng.latitude;
              double long = latLng.longitude;
              _addStoryController.setLatLong(lat, long);
              context.pop();
            },
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                'Pilih',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

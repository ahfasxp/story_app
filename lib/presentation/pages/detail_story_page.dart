import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/data/remote/response/story_result.dart';

class DetailStoryPage extends StatefulWidget {
  final StoryResult storyResult;

  const DetailStoryPage({super.key, required this.storyResult});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  var targetPosition = const LatLng(0, 0);
  bool hasLatlon = false;

  @override
  void initState() {
    super.initState();

    hasLatlon =
        (widget.storyResult.lat != null && widget.storyResult.lon != null);

    if (hasLatlon) {
      setupMarker();
    }
  }

  setupMarker() async {
    targetPosition = LatLng(widget.storyResult.lat!, widget.storyResult.lon!);

    /// todo-04-03: run the reverse geocoding
    final info = await geo.placemarkFromCoordinates(
        targetPosition.latitude, targetPosition.longitude);

    /// todo-04-04: define a name and address of location
    final place = info[0];

    final marker = Marker(
      markerId: const MarkerId("dicoding"),
      position: targetPosition,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 100,
              child: Center(
                child: Text('${place.name}, ${place.locality}'),
              ),
            );
          },
        );
      },
    );
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    return (hasLatlon)
        ? detailMaps()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Story Detail'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.storyResult.photoUrl ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.storyResult.name ?? 'user_name',
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      Text(widget.storyResult.description ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Scaffold detailMaps() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Detail'),
      ),
      body: Center(
        child: GoogleMap(
          markers: markers,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            zoom: 18,
            target: targetPosition,
          ),
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.storyResult.photoUrl ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.storyResult.name ?? 'user_name',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.storyResult.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

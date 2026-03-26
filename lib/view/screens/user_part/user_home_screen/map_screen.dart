import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_text/custom_text.dart';
import 'user_home_controller/sports_type_controller.dart';



class FullscreenMapScreenNonEvent extends StatelessWidget {
  FullscreenMapScreenNonEvent({super.key});
  final SportsTypeController sportsController = Get.find<SportsTypeController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sportsController.getNearbyVenues();
    });

    return Scaffold(
      body: Obx(() {
        if (sportsController.currentPosition.value == null) {
          return const Center(child: CustomLoader());
        }
        final venueList = sportsController.levelList;
        Set<Marker> markers = {};
        Set<Polyline> polylines = {};

        if (sportsController.isNavigating.value &&
            sportsController.routePolylinePoints.isNotEmpty) {
          polylines.add(
            Polyline(
              polylineId: const PolylineId("navigation_route"),
              points: sportsController.routePolylinePoints.toList(),
              color: Colors.blue,
              width: 6,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              jointType: JointType.round,
            ),
          );
        }

        for (var venue in venueList) {
          final double lat = venue.latitude ?? 0.0;
          final double lon = venue.longitude ?? 0.0;

          double distanceInMeters = Geolocator.distanceBetween(
            sportsController.currentPosition.value!.latitude,
            sportsController.currentPosition.value!.longitude,
            lat,
            lon,
          );
          double distanceInKm = distanceInMeters / 1000;

          bool isDestination = sportsController.isNavigating.value &&
              sportsController.selectedEventLocation.value?.latitude == lat &&
              sportsController.selectedEventLocation.value?.longitude == lon;

          markers.add(
            Marker(
              markerId: MarkerId("${venue.id}"),
              position: LatLng(lat, lon),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                isDestination ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen,
              ),
              onTap: () {
                Get.defaultDialog(
                  title: venue.venueName ?? "Venue Details",
                  content: Column(
                    children: [
                      CustomText(text: "Type: ${venue.sportsType ?? 'N/A'}"),
                      CustomText(text: "Price: \$${venue.pricePerHour}/hr"),
                      CustomText(text: "Distance: ${distanceInKm.toStringAsFixed(2)} km"),
                    ],
                  ),
                  textConfirm: "Navigate",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  buttonColor: AppColors.primary,
                  onConfirm: () {
                    Get.back();
                    sportsController.startNavigationToEvent(lat, lon);
                  },
                );
              },
            ),
          );
        }

        return Stack(
          children: [
            // ৫. গুগল ম্যাপ
            GoogleMap(
              onMapCreated: (controller) => sportsController.mapController = controller,
              initialCameraPosition: CameraPosition(
                target: sportsController.currentPosition.value!,
                zoom: 12,
              ),
              markers: markers,
              polylines: polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),

            // ৬. ক্লোজ বাটন
            Positioned(
              top: 50,
              left: 16,
              child: FloatingActionButton.small(
                heroTag: "close_map",
                backgroundColor: Colors.white,
                child: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  sportsController.stopNavigation();
                  Get.back();
                },
              ),
            ),

            // ৭. ডিস্টেন্স ইন্ডিকেটর (নেভিগেশন চলাকালীন)
            if (sportsController.isNavigating.value)
              Positioned(
                top: 50,
                left: 80,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car, color: Colors.blue, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CustomText(text: "Distance to Venue", fontSize: 10, color: Colors.grey),
                            CustomText(
                              text: sportsController.remainingDistance.value < 1
                                  ? "${(sportsController.remainingDistance.value * 1000).toStringAsFixed(0)} m"
                                  : "${sportsController.remainingDistance.value.toStringAsFixed(2)} km",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => sportsController.stopNavigation(),
                      )
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
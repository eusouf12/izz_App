import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/all_sports_model.dart';
import '../model/map_model.dart' as map_mod;
import '../model/sports_type_model.dart';

class SportsTypeController extends GetxController {

  RxList<SportsType> sportsList = <SportsType>[].obs;
  final isSportsLoading = false.obs;
  final isSportsLoadMore = false.obs;
  int currentPage = 1;
  int totalPages = 1;

  Future<void> getAllSports({bool loadMore = false, String? search,}) async {

    if (loadMore) {
      if (isSportsLoadMore.value || currentPage >= totalPages) return;

      isSportsLoadMore.value = true;
      currentPage++;

    }
    else {
      isSportsLoading.value = true;
      currentPage = 1;
      sportsList.clear();
    }

    try {
      final response = await ApiClient.getData(
        ApiUrl.getSportsTypes(page: currentPage.toString(), search: search,),);

      final Map<String, dynamic> jsonResponse = response.body is String ? jsonDecode(response.body) : Map<String, dynamic>.from(response.body);

      final model = SportsTypeResponseModel.fromJson(jsonResponse);

      totalPages = model.data?.meta?.total ?? 1;

      final newData = model.data?.data ?? [];

      /// 🔥 duplicate remove
      final existingIds = sportsList.map((e) => e.id).toSet();

      for (final item in newData) {
        if (!existingIds.contains(item.id)) {
          sportsList.add(item);
        }
      }

    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
      print("SPORT ERROR => $e");

    } finally {
      isSportsLoading.value = false;
      isSportsLoadMore.value = false;
    }
  }
  // ================= map show controller
  RxList<Venue> levelList = <Venue>[].obs;
  final isLevelLoading = false.obs;
  final isLevelLoadMore = false.obs;
  int levelCurrentPage = 1;
  int levelTotalPage = 1;

  Future<void> getNearbyVenues({bool loadMore = false}) async {
    if (isLevelLoading.value || isLevelLoadMore.value) return;

    try {
      bool isLocationOn = await Geolocator.isLocationServiceEnabled();
      if (!isLocationOn) {
        showCustomSnackBar("Please enable your location service", isError: true);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (loadMore) {
        if (levelCurrentPage >= levelTotalPage) return;
        isLevelLoadMore.value = true;
        levelCurrentPage++;
      }
      else {
        isLevelLoading.value = true;
        levelCurrentPage = 1;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await ApiClient.getData(ApiUrl.nearByEvent(page: levelCurrentPage.toString(), lat: pos.latitude.toString(), lon: pos.longitude.toString()),);

      final jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200) {
        final model = map_mod.NearbyVenueResponse.fromJson(jsonResponse);
        final List<dynamic> rawData = jsonResponse['data']['data'] ?? [];

        final List<Venue> newVenues = rawData.map((e) => Venue.fromJson(e as Map<String, dynamic>)).toList();

        if (loadMore) {
          levelList.addAll(newVenues);
        } else {
          levelList.assignAll(newVenues);
        }

        if (model.data?.meta != null) {
          int total = model.data!.meta!.total ?? 0;
          int limit = model.data!.meta!.limit ?? 10;
          levelTotalPage = (total / limit).ceil();
        }
      } else {
        showCustomSnackBar(jsonResponse["message"] ?? "Failed", isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching venues: $e");
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLevelLoading.value = false;
      isLevelLoadMore.value = false;
    }
  }

  ///=======================map controller=======================

  final loc.Location locationController = loc.Location();
  GoogleMapController? mapController;

  // বর্তমান পজিশন ও এড্রেস
  var currentPosition = Rxn<LatLng>(const LatLng(23.8103, 90.4125));
  var currentAddress = "...".obs;

  // নেভিগেশন ভেরিয়েবল
  var selectedEventLocation = Rxn<LatLng>();
  var routePolylinePoints = <LatLng>[].obs;
  var remainingDistance = 0.0.obs;
  var isNavigating = false.obs;
  Timer? navigationTimer;

  String get googleApiKey => ApiUrl.mapKey;

  @override
  void onInit() {
    super.onInit();
    getLocationUpdates();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionGranted = await locationController.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    locationController.onLocationChanged.listen((loc.LocationData currentLocation) async {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        LatLng newPos = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        currentPosition.value = newPos;

        try {
          List<Placemark> placeMarks = await placemarkFromCoordinates(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          if (placeMarks.isNotEmpty) {
            currentAddress.value = "${placeMarks.first.locality}, ${placeMarks.first.administrativeArea}";
          }
        } catch (e) {
          debugPrint("Geocoding Error: $e");
        }
        if (!isNavigating.value) {
          mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
        }
      }
    });
  }

  Future<void> startNavigationToEvent(double lat, double lon) async {
    if (currentPosition.value == null) return;

    selectedEventLocation.value = LatLng(lat, lon);
    isNavigating.value = true;

    await getDirectionsRoute(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      lat,
      lon,
    );
    _startDistanceTracking();
  }

  Future<void> getDirectionsRoute(double sLat, double sLng, double eLat, double eLng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$sLat,$sLng&destination=$eLat,$eLng&mode=driving&key=$googleApiKey'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          String encodedPoints = data['routes'][0]['overview_polyline']['points'];
          List<PointLatLng> result = PolylinePoints.decodePolyline(encodedPoints);

          routePolylinePoints.assignAll(
              result.map((p) => LatLng(p.latitude, p.longitude)).toList()
          );

          // দূরত্ব সেট করা
          int dist = data['routes'][0]['legs'][0]['distance']['value'];
          remainingDistance.value = dist / 1000;

          _fitMapToRoute();
        }
      }
    } catch (e) {
      debugPrint("Route Error: $e");
    }
  }

  void _fitMapToRoute() {
    if (mapController == null || selectedEventLocation.value == null) return;

    LatLng start = currentPosition.value!;
    LatLng end = selectedEventLocation.value!;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        start.latitude < end.latitude ? start.latitude : end.latitude,
        start.longitude < end.longitude ? start.longitude : end.longitude,
      ),
      northeast: LatLng(
        start.latitude > end.latitude ? start.latitude : end.latitude,
        start.longitude > end.longitude ? start.longitude : end.longitude,
      ),
    );
    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  void _startDistanceTracking() {
    navigationTimer?.cancel();
    navigationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentPosition.value != null && selectedEventLocation.value != null) {
        double distance = Geolocator.distanceBetween(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
          selectedEventLocation.value!.latitude,
          selectedEventLocation.value!.longitude,
        );

        remainingDistance.value = distance / 1000;

        if (distance < 40) {
          stopNavigation();
          Get.snackbar("Arrived", "You have reached your destination",
              backgroundColor: Colors.green, colorText: Colors.white);
        }
      }
    });
  }

  void stopNavigation() {
    isNavigating.value = false;
    navigationTimer?.cancel();
    routePolylinePoints.clear();
    selectedEventLocation.value = null;
    remainingDistance.value = 0.0;
  }

  @override
  void onClose() {
    navigationTimer?.cancel();
    super.onClose();
  }

}

class VenueDetailsResponse {
  final bool success;
  final String message;
  final VenueDetails data;

  VenueDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VenueDetailsResponse.fromJson(Map<String, dynamic> json) {
    return VenueDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: VenueDetails.fromJson(json['data'] ?? {}),
    );
  }
}

class VenueDetails {
  final String id;
  final String venueName;
  final String sportsType;
  final double pricePerHour;
  final int capacity;
  final int courtNumbers;
  final String location;
  final bool venueStatus;
  final String description;
  final String venueImage;
  final List<Amenity> amenities;
  final String venueRating;
  final String vendorId;
  final int venueReviewCount;
  final List<VenueAvailability> venueAvailabilities;

  VenueDetails({
    required this.id,
    required this.venueName,
    required this.sportsType,
    required this.pricePerHour,
    required this.capacity,
    required this.courtNumbers,
    required this.location,
    required this.venueStatus,
    required this.description,
    required this.venueImage,
    required this.amenities,
    required this.venueRating,
    required this.vendorId,
    required this.venueReviewCount,
    required this.venueAvailabilities,
  });

  factory VenueDetails.fromJson(Map<String, dynamic> json) {

    // ✅ Handle courtNumbers
    int parsedCourtNumbers = 1;
    if (json['courtNumbers'] is List) {
      parsedCourtNumbers = (json['courtNumbers'] as List).length;
    } else {
      parsedCourtNumbers = int.tryParse(json['courtNumbers']?.toString() ?? '1') ?? 1;
    }

    List<VenueAvailability> cleanAvailabilities = [];

    if (json['venueAvailabilities'] != null) {
      var rawList = List<VenueAvailability>.from(
          json['venueAvailabilities'].map((x) => VenueAvailability.fromJson(x)));

      Map<String, List<ScheduleSlot>> dayMap = {};

      for (var item in rawList) {
        String dayKey = item.day.trim().toUpperCase();
        if (!dayMap.containsKey(dayKey)) {
          dayMap[dayKey] = [];
        }
        dayMap[dayKey]!.addAll(item.scheduleSlots);
      }

      dayMap.forEach((day, slots) {
        final uniqueSlots = <ScheduleSlot>[];
        final seenSlots = <String>{};

        for (var slot in slots) {
          String key = "${slot.from}-${slot.to}";
          if (!seenSlots.contains(key)) {
            seenSlots.add(key);
            uniqueSlots.add(slot);
          }
        }

        cleanAvailabilities.add(VenueAvailability(day: day, scheduleSlots: uniqueSlots));
      });
    }

    return VenueDetails(
      id: json['id']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? '',
      venueName: json['venueName']?.toString() ?? '',
      sportsType: json['sportsType']?.toString() ?? '',
      pricePerHour: double.tryParse(json['pricePerHour']?.toString() ?? '0.0') ?? 0.0,
      capacity: int.tryParse(json['capacity']?.toString() ?? '0') ?? 0,
      courtNumbers: parsedCourtNumbers,
      location: json['location']?.toString() ?? '',
      venueStatus: json['venueStatus'] ?? false,
      description: json['description']?.toString() ?? '',
      venueImage: json['venueImage']?.toString() ?? '',
      amenities: json['amenities'] == null
          ? []
          : List<Amenity>.from(json['amenities'].map((x) => Amenity.fromJson(x))),
      venueRating: json['venueRating']?.toString() ?? '0.0',
      venueReviewCount: int.tryParse(json['venueReviewCount']?.toString() ?? '0') ?? 0,

      // ✅ Assigning Cleaned List
      venueAvailabilities: cleanAvailabilities,
    );
  }
}

class Amenity {
  final String amenityName;
  Amenity({required this.amenityName});
  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(amenityName: json['amenityName']?.toString() ?? '');
  }
}

class VenueAvailability {
  final String day;
  final List<ScheduleSlot> scheduleSlots;
  VenueAvailability({required this.day, required this.scheduleSlots});

  factory VenueAvailability.fromJson(Map<String, dynamic> json) {
    var rawSlots = json['scheduleSlots'] == null
        ? <ScheduleSlot>[]
        : List<ScheduleSlot>.from(json['scheduleSlots'].map((x) => ScheduleSlot.fromJson(x)));

    final uniqueSlots = <ScheduleSlot>[];
    final seen = <String>{};

    for (var slot in rawSlots) {
      final key = "${slot.from}-${slot.to}";
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueSlots.add(slot);
      }
    }

    return VenueAvailability(
      day: json['day']?.toString() ?? '',
      scheduleSlots: uniqueSlots,
    );
  }
}

class ScheduleSlot {
  final String from;
  final String to;
  ScheduleSlot({required this.from, required this.to});
  factory ScheduleSlot.fromJson(Map<String, dynamic> json) {
    return ScheduleSlot(
        from: json['from']?.toString() ?? '',
        to: json['to']?.toString() ?? ''
    );
  }
}
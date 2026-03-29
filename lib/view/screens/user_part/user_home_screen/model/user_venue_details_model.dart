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
  final List<int> courtNumbers; // ✅ পরিবর্তিত: এখন এটি List<int>
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
    // ✅ courtNumbers List হ্যান্ডেল করা
    List<int> parsedCourts = [];
    if (json['courtNumbers'] is List) {
      parsedCourts = List<int>.from(json['courtNumbers']);
    }

    List<VenueAvailability> cleanAvailabilities = [];

    if (json['venueAvailabilities'] != null) {
      // আমরা দিন অনুযায়ী ডাটা গ্রুপ করবো যাতে একই দিনের স্লটগুলো একসাথে থাকে
      Map<String, VenueAvailability> dayMap = {};

      for (var item in json['venueAvailabilities']) {
        var availability = VenueAvailability.fromJson(item);
        String dayKey = availability.day.trim().toUpperCase();

        if (dayMap.containsKey(dayKey)) {
          // যদি দিনটি ইতিমধ্যে থাকে, তবে নতুন স্লটগুলো যোগ করো এবং ডুপ্লিকেট চেক করো
          var existingSlots = dayMap[dayKey]!.scheduleSlots;
          for (var newSlot in availability.scheduleSlots) {
            bool isDuplicate = existingSlots.any((s) => s.from == newSlot.from && s.to == newSlot.to);
            if (!isDuplicate) {
              existingSlots.add(newSlot);
            }
          }
        } else {
          dayMap[dayKey] = availability;
        }
      }
      cleanAvailabilities = dayMap.values.toList();
    }

    return VenueDetails(
      id: json['id']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? '',
      venueName: json['venueName']?.toString() ?? '',
      sportsType: json['sportsType']?.toString() ?? '',
      pricePerHour: double.tryParse(json['pricePerHour']?.toString() ?? '0.0') ?? 0.0,
      capacity: int.tryParse(json['capacity']?.toString() ?? '0') ?? 0,
      courtNumbers: parsedCourts,
      location: json['location']?.toString() ?? '',
      venueStatus: json['venueStatus'] ?? false,
      description: json['description']?.toString() ?? '',
      venueImage: json['venueImage']?.toString() ?? '',
      amenities: json['amenities'] == null
          ? []
          : List<Amenity>.from(json['amenities'].map((x) => Amenity.fromJson(x))),
      venueRating: json['venueRating']?.toString() ?? '0.0',
      venueReviewCount: int.tryParse(json['venueReviewCount']?.toString() ?? '0') ?? 0,
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
  final String? id; 
  final String day;
  final List<ScheduleSlot> scheduleSlots;

  VenueAvailability({
    this.id, 
    required this.day, 
    required this.scheduleSlots,
  });

  factory VenueAvailability.fromJson(Map<String, dynamic> json) {
    return VenueAvailability(
      id: json['id']?.toString(),
      day: json['day']?.toString() ?? '',
      scheduleSlots: json['scheduleSlots'] == null
          ? []
          : List<ScheduleSlot>.from(
              json['scheduleSlots'].map((x) => ScheduleSlot.fromJson(x))),
    );
  }
}

class ScheduleSlot {
  final String? id; 
  final String from;
  final String to;

  ScheduleSlot({
    this.id,
    required this.from,
    required this.to,
  });

  factory ScheduleSlot.fromJson(Map<String, dynamic> json) {
    return ScheduleSlot(
      id: json['id']?.toString(),
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}
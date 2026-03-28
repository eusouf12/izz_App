class NearbyVenueResponse {
  bool? success;
  String? message;
  NearbyVenueData? data;

  NearbyVenueResponse({
    this.success,
    this.message,
    this.data,
  });

  factory NearbyVenueResponse.fromJson(Map<String, dynamic> json) {
    return NearbyVenueResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? NearbyVenueData.fromJson(json['data'])
          : null,
    );
  }
}

class NearbyVenueData {
  Meta? meta;
  List<Venue>? data;

  NearbyVenueData({this.meta, this.data});

  factory NearbyVenueData.fromJson(Map<String, dynamic> json) {
    return NearbyVenueData(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<Venue>.from(json['data'].map((x) => Venue.fromJson(x)))
          : [],
    );
  }
}

class Meta {
  int? total;
  int? page;
  int? limit;

  Meta({this.total, this.page, this.limit});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total']?.toInt(),
      page: json['page']?.toInt(),
      limit: json['limit']?.toInt(),
    );
  }
}

class Venue {
  String? id;
  String? venueName;
  String? sportsType;
  int? pricePerHour;
  int? capacity;
  String? location;
  double? latitude;
  double? longitude;
  bool? venueStatus;
  String? description;
  String? venueImage;

  List<Amenity>? amenities;
  List<int>? courtNumbers;

  String? everyServiceStatus;
  String? venueRating;
  int? venueReviewCount;

  String? createdAt;
  String? updatedAt;
  String? vendorId;

  List<VenueAvailability>? venueAvailabilities;
  List<dynamic>? reviews;

  double? distance;

  Venue({
    this.id,
    this.venueName,
    this.sportsType,
    this.pricePerHour,
    this.capacity,
    this.location,
    this.latitude,
    this.longitude,
    this.venueStatus,
    this.description,
    this.venueImage,
    this.amenities,
    this.courtNumbers,
    this.everyServiceStatus,
    this.venueRating,
    this.venueReviewCount,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
    this.venueAvailabilities,
    this.reviews,
    this.distance,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      venueName: json['venueName'],
      sportsType: json['sportsType'],
      pricePerHour: json['pricePerHour']?.toInt(),
      capacity: json['capacity']?.toInt(),
      location: json['location'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      venueStatus: json['venueStatus'],
      description: json['description'],
      venueImage: json['venueImage'],
      amenities: json['amenities'] != null
          ? List<Amenity>.from(
          json['amenities'].map((x) => Amenity.fromJson(x)))
          : [],
      courtNumbers: json['courtNumbers'] != null
          ? (json['courtNumbers'] as List).map((e) => (e as num).toInt()).toList()
          : [],
      everyServiceStatus: json['EveryServiceStatus'],
      venueRating: json['venueRating'],
      venueReviewCount: json['venueReviewCount']?.toInt(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      vendorId: json['vendorId'],
      venueAvailabilities: json['venueAvailabilities'] != null
          ? List<VenueAvailability>.from(
          json['venueAvailabilities']
              .map((x) => VenueAvailability.fromJson(x)))
          : [],
      reviews: json['reviews'] ?? [],
      distance: (json['distance'] ?? 0).toDouble(),
    );
  }
}

class Amenity {
  String? amenityName;

  Amenity({this.amenityName});

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      amenityName: json['amenityName'],
    );
  }
}

class VenueAvailability {
  String? id;
  String? day;
  String? createdAt;
  String? venueId;
  List<ScheduleSlot>? scheduleSlots;

  VenueAvailability({
    this.id,
    this.day,
    this.createdAt,
    this.venueId,
    this.scheduleSlots,
  });

  factory VenueAvailability.fromJson(Map<String, dynamic> json) {
    return VenueAvailability(
      id: json['id'],
      day: json['day'],
      createdAt: json['createdAt'],
      venueId: json['venueId'],
      scheduleSlots: json['scheduleSlots'] != null
          ? List<ScheduleSlot>.from(
          json['scheduleSlots']
              .map((x) => ScheduleSlot.fromJson(x)))
          : [],
    );
  }
}

class ScheduleSlot {
  String? id;
  String? from;
  String? to;
  String? venueId;
  String? availableVenueId;

  ScheduleSlot({
    this.id,
    this.from,
    this.to,
    this.venueId,
    this.availableVenueId,
  });

  factory ScheduleSlot.fromJson(Map<String, dynamic> json) {
    return ScheduleSlot(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      venueId: json['venueId'],
      availableVenueId: json['availableVenueId'],
    );
  }
}
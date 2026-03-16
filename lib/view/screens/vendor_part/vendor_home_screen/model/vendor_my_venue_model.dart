class VendorMyVenueModel {
  final bool success;
  final String message;
  final Meta meta;  // Added meta field
  final List<Venue> data;

  VendorMyVenueModel({
    required this.success,
    required this.message,
    required this.meta,  // Initialize meta
    required this.data,
  });

  factory VendorMyVenueModel.fromJson(Map<String, dynamic> json) {
    return VendorMyVenueModel(
      success: json['success'],
      message: json['message'],
      meta: Meta.fromJson(json['data']['meta']),  // Parse meta field
      data: (json['data']['data'] as List).map((e) => Venue.fromJson(e)).toList(),
    );
  }
}

class Meta {
  final int total;
  final int page;
  final int limit;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  }
}

class Venue {
  final String id;
  final String venueName;
  final String sportsType;
  final int pricePerHour;
  final int capacity;
  final String location;
  final bool venueStatus;
  final String description;
  final String venueImage;
  final List<Amenity> amenities;
  final List<int> courtNumbers;
  final String createdAt;
  final String updatedAt;
  final String vendorId;
  final List<VenueAvailability> venueAvailabilities;

  Venue({
    required this.id,
    required this.venueName,
    required this.sportsType,
    required this.pricePerHour,
    required this.capacity,
    required this.location,
    required this.venueStatus,
    required this.description,
    required this.venueImage,
    required this.amenities,
    required this.courtNumbers,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorId,
    required this.venueAvailabilities,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      venueName: json['venueName'],
      sportsType: json['sportsType'],
      pricePerHour: json['pricePerHour'],
      capacity: json['capacity'],
      location: json['location'],
      venueStatus: json['venueStatus'],
      description: json['description'],
      venueImage: json['venueImage'] ?? '',
      amenities: (json['amenities'] as List)
          .map((e) => Amenity.fromJson(e))
          .toList(),
      courtNumbers: List<int>.from(json['courtNumbers']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      vendorId: json['vendorId'],
      venueAvailabilities: (json['venueAvailabilities'] as List)
          .map((e) => VenueAvailability.fromJson(e))
          .toList(),
    );
  }
}

class Amenity {
  final String amenityName;

  Amenity({required this.amenityName});

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(amenityName: json['amenityName']);
  }
}

class VenueAvailability {
  final String id;
  final String day;
  final String createdAt;
  final String venueId;
  final List<ScheduleSlot> scheduleSlots;

  VenueAvailability({
    required this.id,
    required this.day,
    required this.createdAt,
    required this.venueId,
    required this.scheduleSlots,
  });

  factory VenueAvailability.fromJson(Map<String, dynamic> json) {
    return VenueAvailability(
      id: json['id'],
      day: json['day'],
      createdAt: json['createdAt'],
      venueId: json['venueId'],
      scheduleSlots: (json['scheduleSlots'] as List)
          .map((e) => ScheduleSlot.fromJson(e))
          .toList(),
    );
  }
}

class ScheduleSlot {
  final String id;
  final String from;
  final String to;
  final String venueId;
  final String availableVenueId;

  ScheduleSlot({
    required this.id,
    required this.from,
    required this.to,
    required this.venueId,
    required this.availableVenueId,
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

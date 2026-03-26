// ================= Venue API Response =================

class VenueResponse {
  final bool success;
  final String message;
  final VenueData data;

  VenueResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VenueResponse.fromJson(Map<String, dynamic> json) {
    return VenueResponse(
      success: json['success'],
      message: json['message'],
      data: VenueData.fromJson(json['data']),
    );
  }
}

class VenueData {
  final Meta meta;
  final List<SportsVenueGroup> data;

  VenueData({
    required this.meta,
    required this.data,
  });

  factory VenueData.fromJson(Map<String, dynamic> json) {
    return VenueData(
      meta: Meta.fromJson(json['meta']),
      data: (json['data'] as List)
          .map((e) => SportsVenueGroup.fromJson(e))
          .toList(),
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

class SportsVenueGroup {
  final String sportsType;
  final String? sportsImage;
  final List<Venue> venues;
  final int count;

  SportsVenueGroup({
    required this.sportsType,
    this.sportsImage,
    required this.venues,
    required this.count,
  });

  factory SportsVenueGroup.fromJson(Map<String, dynamic> json) {
    return SportsVenueGroup(
      sportsType: json['sportsType'],
      sportsImage: json['sportsImage'],
      venues: (json['venues'] as List)
          .map((e) => Venue.fromJson(e))
          .toList(),
      count: json['count'],
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
  final double latitude;
  final double longitude;
  final double distance;
  final List<Amenity> amenities;
  final List<int> courtNumbers;
  final String everyServiceStatus;
  final String venueRating;
  final int venueReviewCount;
  final List<Review> reviews;
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
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.amenities,
    required this.courtNumbers,
    required this.everyServiceStatus,
    required this.venueRating,
    required this.venueReviewCount,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorId,
    required this.venueAvailabilities,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] ?? '',
      venueName: json['venueName'] ?? '',
      sportsType: json['sportsType'] ?? '',
      pricePerHour: (json['pricePerHour'] ?? 0).toInt(),
      capacity: (json['capacity'] ?? 0).toInt(),
      location: json['location'] ?? '',
      venueStatus: json['venueStatus'] ?? false,
      description: json['description'] ?? '',
      venueImage: json['venueImage'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      amenities: json['amenities'] != null ? (json['amenities'] as List).map((e) => Amenity.fromJson(e)).toList() : [],
      courtNumbers: json['courtNumbers'] != null ? List<int>.from(json['courtNumbers']) : [],
      everyServiceStatus: json['EveryServiceStatus'] ?? '',
      venueRating: json['venueRating']?.toString() ?? '0',
      venueReviewCount: (json['venueReviewCount'] ?? 0).toInt(),
      reviews: json['reviews'] == null ? [] : (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      vendorId: json['vendorId'] ?? '',
      venueAvailabilities: json['venueAvailabilities'] != null ? (json['venueAvailabilities'] as List).map((e) => VenueAvailability.fromJson(e)).toList() : [],
    );
  }
}

class UserVenueDetailsModel {
  final bool success;
  final String message;
  final Venue data;

  UserVenueDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserVenueDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserVenueDetailsModel(
      success: json['success'],
      message: json['message'],
      data: Venue.fromJson(json['data']),
    );
  }
}


class Amenity {
  final String amenityName;

  Amenity({required this.amenityName});

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      amenityName: json['amenityName'],
    );
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

// ================= Reviews =================

class Review {
  final String id;
  final int rating;
  final dynamic subRatings;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final String userId;
  final String venueId;

  Review({
    required this.id,
    required this.rating,
    this.subRatings,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.venueId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      subRatings: json['subRatings'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      venueId: json['venueId'],
    );
  }
}

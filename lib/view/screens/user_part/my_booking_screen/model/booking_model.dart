// =======================
// Main Response Model
// =======================
class MyVenueBookingResponseModel {
  bool? success;
  String? message;
  Meta? meta;
  List<BookingData>? data;

  MyVenueBookingResponseModel({
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory MyVenueBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return MyVenueBookingResponseModel(
      success: json['success'],
      message: json['message'],
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<BookingData>.from(
        json['data'].map((x) => BookingData.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

// =======================
// Meta Model
// =======================
class Meta {
  int? total;
  int? page;
  int? limit;

  Meta({this.total, this.page, this.limit});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}

// =======================
// Booking Data Model
// =======================
class BookingData {
  String? id;
  String? checkoutSessionId;
  String? date;
  String? day;
  TimeSlot? timeSlot;
  int? courtNumber;
  String? sportsType;
  int? totalPrice;
  String? bookingStatus;
  String? createdAt;
  String? updatedAt;
  String? vendorId;
  String? userId;
  String? venueId;
  Venue? venue;
  User? user;
  List<dynamic>? payment;
  String? calculatedStatus;

  BookingData({
    this.id,
    this.checkoutSessionId,
    this.date,
    this.day,
    this.timeSlot,
    this.courtNumber,
    this.sportsType,
    this.totalPrice,
    this.bookingStatus,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
    this.userId,
    this.venueId,
    this.venue,
    this.user,
    this.payment,
    this.calculatedStatus,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'],
      checkoutSessionId: json['checkoutSessionId'],
      date: json['date'],
      day: json['day'],
      timeSlot:
      json['timeSlot'] != null ? TimeSlot.fromJson(json['timeSlot']) : null,
      courtNumber: json['courtNumber'],
      sportsType: json['sportsType'],
      totalPrice: json['totalPrice'],
      bookingStatus: json['bookingStatus'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      vendorId: json['vendorId'],
      userId: json['userId'],
      venueId: json['venueId'],
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      payment: json['payment'] ?? [],
      calculatedStatus: json['calculatedStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkoutSessionId': checkoutSessionId,
      'date': date,
      'day': day,
      'timeSlot': timeSlot?.toJson(),
      'courtNumber': courtNumber,
      'sportsType': sportsType,
      'totalPrice': totalPrice,
      'bookingStatus': bookingStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'vendorId': vendorId,
      'userId': userId,
      'venueId': venueId,
      'venue': venue?.toJson(),
      'user': user?.toJson(),
      'payment': payment,
      'calculatedStatus': calculatedStatus,
    };
  }
}

// =======================
// Time Slot Model
// =======================
class TimeSlot {
  String? from;
  String? to;

  TimeSlot({this.from, this.to});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      from: json['from'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}

// ======================= Venue Model =======================
class Venue {
  String? id;
  String? venueName;
  String? sportsType;
  String? location;
  String? venueImage;
  int? pricePerHour;
  String? venueRating;
  int? venueReviewCount;

  Venue({
    this.id,
    this.venueName,
    this.sportsType,
    this.location,
    this.venueImage,
    this.pricePerHour,
    this.venueRating,
    this.venueReviewCount,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      venueName: json['venueName'],
      sportsType: json['sportsType'],
      location: json['location'],
      venueImage: json['venueImage'],
      pricePerHour: json['pricePerHour'],
      venueRating: json['venueRating']?.toString() ?? "0",
      venueReviewCount: json['venueReviewCount'] != null ? (json['venueReviewCount'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venueName': venueName,
      'sportsType': sportsType,
      'location': location,
      'venueImage': venueImage,
      'pricePerHour': pricePerHour,
    };
  }
}

// ======================= User Model =======================
class User {
  String? id;
  String? fullName;
  String? email;
  String? contactNumber;

  User({
    this.id,
    this.fullName,
    this.email,
    this.contactNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      contactNumber: json['contactNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'contactNumber': contactNumber,
    };
  }
}

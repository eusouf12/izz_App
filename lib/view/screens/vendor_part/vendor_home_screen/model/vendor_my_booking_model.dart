class MyVenueBookingResponseModel {
  bool? success;
  String? message;
  Meta? meta;
  List<VendorMyBookingData>? data;

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
          ? List<VendorMyBookingData>.from(
        json['data'].map((x) => VendorMyBookingData.fromJson(x)),
      )
          : [],
    );
  }
}

/* ================= META ================= */

class Meta {
  int? total;
  int? page;
  int? limit;

  Meta({
    this.total,
    this.page,
    this.limit,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  }
}

/* ================= BOOKING DATA ================= */

class VendorMyBookingData {
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

  VendorMyBookingData({
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

  factory VendorMyBookingData.fromJson(Map<String, dynamic> json) {
    return VendorMyBookingData(
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
      venue:
      json['venue'] != null ? Venue.fromJson(json['venue']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      payment: json['payment'] ?? [],
      calculatedStatus: json['calculatedStatus'],
    );
  }

  /* ======= STATUS HELPERS (TAB FILTER ER JONNO) ======= */

  bool get isCompleted => calculatedStatus == 'completed';
  bool get isOngoing => calculatedStatus == 'ongoing';
  bool get isRequested => calculatedStatus == 'new-requests';
}

/* ================= TIME SLOT ================= */

class TimeSlot {
  String? from;
  String? to;

  TimeSlot({
    this.from,
    this.to,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      from: json['from'],
      to: json['to'],
    );
  }
}

/* ================= VENUE ================= */

class Venue {
  String? id;
  String? venueName;
  String? sportsType;
  String? location;
  String? venueImage;
  int? pricePerHour;

  Venue({
    this.id,
    this.venueName,
    this.sportsType,
    this.location,
    this.venueImage,
    this.pricePerHour,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      venueName: json['venueName'],
      sportsType: json['sportsType'],
      location: json['location'],
      venueImage: json['venueImage'],
      pricePerHour: json['pricePerHour'],
    );
  }
}

/* ================= USER ================= */

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
}

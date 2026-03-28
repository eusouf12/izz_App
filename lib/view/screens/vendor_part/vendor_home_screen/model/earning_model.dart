class VendorEarningsResponse {
  bool? success;
  String? message;
  VendorEarningsData? data;

  VendorEarningsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory VendorEarningsResponse.fromJson(Map<String, dynamic> json) {
    return VendorEarningsResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? VendorEarningsData.fromJson(json['data'])
          : null,
    );
  }
}

class VendorEarningsData {
  num? totalEarnings;
  int? totalBookings;

  num? currentMonthEarnings;
  int? currentMonthBookings;

  List<EarningsTrend>? earningsTrend;
  List<BookingsTrend>? bookingsTrend;

  int? filterYear;

  VendorEarningsData({
    this.totalEarnings,
    this.totalBookings,
    this.currentMonthEarnings,
    this.currentMonthBookings,
    this.earningsTrend,
    this.bookingsTrend,
    this.filterYear,
  });

  factory VendorEarningsData.fromJson(Map<String, dynamic> json) {
    return VendorEarningsData(
      totalEarnings: json['totalEarnings'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0,
      currentMonthEarnings: json['currentMonthEarnings'] ?? 0,
      currentMonthBookings: json['currentMonthBookings'] ?? 0,

      earningsTrend: json['earningsTrend'] != null
          ? List<EarningsTrend>.from(
              json['earningsTrend'].map((x) => EarningsTrend.fromJson(x)),
            )
          : [],

      bookingsTrend: json['bookingsTrend'] != null
          ? List<BookingsTrend>.from(
              json['bookingsTrend'].map((x) => BookingsTrend.fromJson(x)),
            )
          : [],

      filterYear: json['filterYear'],
    );
  }
}

class EarningsTrend {
  String? month;
  num? earnings;

  EarningsTrend({
    this.month,
    this.earnings,
  });

  factory EarningsTrend.fromJson(Map<String, dynamic> json) {
    return EarningsTrend(
      month: json['month'],
      earnings: json['earnings'] ?? 0,
    );
  }
}

class BookingsTrend {
  String? month;
  int? bookings;

  BookingsTrend({
    this.month,
    this.bookings,
  });

  factory BookingsTrend.fromJson(Map<String, dynamic> json) {
    return BookingsTrend(
      month: json['month'],
      bookings: json['bookings'] ?? 0,
    );
  }
}
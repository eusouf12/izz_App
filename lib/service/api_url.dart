class ApiUrl {
  /// ================= BASE URL =================
 // static const String baseUrl = "https://sports-izz-122-backend.onrender.com/api/v1";
  static const String baseUrl = "https://vat-component-billing-attendance.trycloudflare.com/api/v1";
  static const String websocket = "https://sports-izz-122-backend.onrender.com";

  /// ================= AUTHENTICATION =================
  static const String signUp = "/users";
  static const String signIn = "/auth/login";

  static const String forgotPassword = "/auth/forgot-password";
  static const String verifyOtp = "/auth/verify-otp";
  static const String resetPassword = "/auth/reset-password";
  static const String termsCondition = "/terms-conditions";
  static const String logout = "/auth/logout";
  static const String privacyPolicy = "/policy";
  static const String aboutUs = "/settings/about";
  static const String changePassword = "/auth/change-password";
  static const String updateProfile = "/users/update";
  static const String vendorProfile = "/users/my-profile";
  static const String getSportsTypes = "/sports-types";
  static String allSports({String? page, String? sportName}) {
    String url = "/venues/group-by-sports-type?page=$page&limit=10";
    if (sportName != null && sportName.isNotEmpty) {url += "&searchTerm=$sportName";}
    return url;
  }
  static String filterSports({required String page, required String filter}) => "/venues?page=$page&limit=3&sportsType=$filter";
  static String bookingsByStatus({required String status}) => "/venue-bookings/specific-user-bookings?filter=${status.toLowerCase()}";
  static String vendorBookingsByStatus({required String status}) => "/venue-bookings/specific-vendor-bookings?filter=${status.toLowerCase()}";

  /// ==================== Vendor Profile ===================
  static const String createVenue = "/venues";
  static const String vendorMyVenues = "/venues/my";
  static String userVenueDetails({required String id}) => "/venues/$id";
  static String updateVenue({required String id}) => "/venues/$id";
  static String bookSlot({required String id}) => "/venue-bookings/$id";
  static String specificUserBookings({required String id}) => "/venue-bookings/specific-user-bookings/$id";
  static String reviews = "/reviews/venue";
  static String gamificationProfile = "/gamification/profile";
  static String notification = "/notifications/my-notifications";

  /// ======================== user =======================
  static String initialText({required String id}) => "/messages/my-channel/$id";
  static String initialSendText({required String id}) => "/messages/send-message/$id";
  static String chatList({required String page}) => "/messages/channels?page=$page&limit=10";
  static String getAllChat({required String channelName,required String page}) => "/messages/get-message/$channelName/?page=$page&limit=10";

}
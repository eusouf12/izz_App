import 'package:get/get.dart';
import '../../view/screens/authentication_screen/forgot_screen/forgot_screen.dart';
import '../../view/screens/authentication_screen/login_screen/login_screen.dart';
import '../../view/screens/authentication_screen/otp_screen/otp_screen.dart';
import '../../view/screens/authentication_screen/set_new_password/set_new_password.dart';
import '../../view/screens/authentication_screen/sign_up_screen/sign_up_screen.dart';
import '../../view/screens/onboarding_screen/frame_screen.dart';
import '../../view/screens/onboarding_screen/onboarding_screen.dart';
import '../../view/screens/splash_screen/splash_screen.dart';
import '../../view/screens/user_part/my_booking_screen/my_booking_screen.dart';
import '../../view/screens/user_part/my_booking_screen/user_my_bookings_screen.dart';
import '../../view/screens/user_part/user_home_screen/book_your_slot_screen.dart';
import '../../view/screens/user_part/user_home_screen/user_all_sports_screen.dart';
import '../../view/screens/user_part/user_home_screen/user_home_screen.dart';
import '../../view/screens/user_part/user_home_screen/user_notification_screen.dart';
import '../../view/screens/user_part/user_home_screen/user_review_screen.dart';
import '../../view/screens/user_part/user_home_screen/user_search_venue_screen.dart';
import '../../view/screens/user_part/user_home_screen/user_venue_details_screen.dart';
import '../../view/screens/user_part/user_message_list_screen/view/user_message_list_screen.dart';
import '../../view/screens/user_part/user_message_list_screen/view/chat_inbox_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_about_us_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_change_password_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_collect_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_edit_profile_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_help_support_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_how_it_work_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_privacy_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_profile_screen.dart';
import '../../view/screens/user_part/user_profile_screen/user_terms_screen.dart';
import '../../view/screens/user_part/user_social_screen/user_social_screen.dart';
import '../../view/screens/vendor_part/vendor_home_screen/add_venue_screen.dart';
import '../../view/screens/vendor_part/vendor_home_screen/edit_venue_screen.dart';
import '../../view/screens/vendor_part/vendor_home_screen/vendor_booking_details_screen.dart';
import '../../view/screens/vendor_part/vendor_home_screen/vendor_booking_request_screen.dart';
import '../../view/screens/vendor_part/vendor_home_screen/vendor_home_screen.dart';
import '../../view/screens/vendor_part/vendor_home_screen/vendor_my_venues_screen.dart';
import '../../view/screens/vendor_part/vendor_home_screen/venue_availability_screen.dart';
import '../../view/screens/vendor_part/vendor_home_screen/venue_details_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_about_us_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_account_settings.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_change_password_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_edit_profile_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_help_support_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_message_list_screen/vendor_message_list_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_notification_setting_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_privacy_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_profile_collect_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_profile_screen.dart';
import '../../view/screens/vendor_part/vendor_profile_screen/vendor_terms_screen.dart';

class AppRoutes {
  ///===========================User Part ==========================
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/OnboardingScreen";
  static const String frameScreen = "/FrameScreen";
  static const String userSocialScreen = "/UserSocialScreen";
  static const String signUpScreen = "/SignUpScreen";
  static const String loginScreen = "/LoginScreen";
  static const String userHomeScreen = "/UserHomeScreen";
  static const String myBookingScreen = "/MyBookingScreen";
  static const String userProfileScreen = "/UserProfileScreen";
  static const String userMessageListScreen = "/UserMessageListScreen";
  static const String userEditProfileScreen = "/UserEditProfileScreen";
  static const String userChangePasswordScreen = "/UserChangePasswordScreen";
  static const String userTermsScreen = "/UserTermsScreen";
  static const String userPrivacyScreen = "/UserPrivacyScreen";
  static const String userAboutUsScreen = "/UserAboutUsScreen";
  static const String userHelpSupportScreen = "/UserHelpSupportScreen";
  static const String userNotificationScreen = "/UserNotificationScreen";
  static const String userCollectScreen = "/UserCollectScreen";
  static const String userHowItWorkScreen = "/UserHowItWorkScreen";
  static const String forgotScreen = "/ForgotScreen";
  static const String otpScreen = "/OtpScreen";
  static const String setNewPassword = "/SetNewPassword";
  static const String userReviewScreen = "/UserReviewScreen";


  ///===========================Vendor Part ==========================
  static const String vendorHomeScreen = "/VendorHomeScreen";
  static const String addVenueScreen = "/AddVenueScreen";
  static const String vendorMyVenuesScreen = "/VendorMyVenuesScreen";
  static const String vendorBookingRequestScreen = "/VendorBookingRequestScreen";
  static const String vendorBookingDetailsScreen = "/VendorBookingDetailsScreen";
  static const String vendorAboutUsScreen = "/VendorAboutUsScreen";
  static const String vendorAccountSettings = "/VendorAccountSettings";
  static const String vendorChangePasswordScreen = "/VendorChangePasswordScreen";
  static const String vendorEditProfileScreen = "/VendorEditProfileScreen";
  static const String vendorHelpSupportScreen = "/VendorHelpSupportScreen";
  static const String vendorNotificationSettingScreen = "/VendorNotificationSettingScreen";
  static const String vendorPrivacyScreen = "/VendorPrivacyScreen";
  static const String vendorProfileCollectScreen = "/VendorProfileCollectScreen";
  static const String vendorProfileScreen = "/VendorProfileScreen";
  static const String vendorTermsScreen = "/VendorTermsScreen";
  static const String vendorMessageListScreen = "/VendorMessageListScreen";
  static const String userSearchVenueScreen = "/UserSearchVenueScreen";
  static const String userVenueDetailsScreen = "/UserVenueDetailsScreen";
  static const String bookYourSlotScreen = "/BookYourSlotScreen";
  static const String userMyBookingsScreen = "/UserMyBookingsScreen";
  static const String userAllSportsScreen = "/UserAllSportsScreen";
  static const String editVenueScreen = "/EditVenueScreen";
  static const String venueDetailsScreen = "/VenueDetailsScreen";
  static const String venueAvailabilityScreen = "/VenueAvailabilityScreen";
  static const String chatInboxScreen = "/ChatInboxScreen";


  static List<GetPage> routes = [
    ///===========================User Part==========================
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: frameScreen, page: () => FrameScreen()),
    GetPage(name: userSocialScreen, page: () => UserSocialScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: userHomeScreen, page: () => UserHomeScreen()),
    GetPage(name: myBookingScreen, page: () => MyBookingScreen()),
    GetPage(name: userProfileScreen, page: () => UserProfileScreen()),
    GetPage(name: userMessageListScreen, page: () => UserMessageListScreen()),
    GetPage(name: userEditProfileScreen, page: () => UserEditProfileScreen()),
    GetPage(name: userChangePasswordScreen, page: () => UserChangePasswordScreen()),
    GetPage(name: userTermsScreen, page: () => UserTermsScreen()),
    GetPage(name: userPrivacyScreen, page: () => UserPrivacyScreen()),
    GetPage(name: userAboutUsScreen, page: () => UserAboutUsScreen()),
    GetPage(name: userHelpSupportScreen, page: () => UserHelpSupportScreen()),
    GetPage(name: userNotificationScreen, page: () => UserNotificationScreen()),
    GetPage(name: userCollectScreen, page: () => UserCollectScreen()),
    GetPage(name: userHowItWorkScreen, page: () => UserHowItWorkScreen()),
    GetPage(name: forgotScreen, page: () => ForgotScreen()),
    GetPage(name: otpScreen, page: () => OtpScreen()),
    GetPage(name: setNewPassword, page: () => SetNewPassword()),
    GetPage(name: userReviewScreen, page: () => UserReviewScreen(venueId: '',)),
    GetPage(name: chatInboxScreen, page: () => ChatInboxScreen()),


    ///===========================Vendor Part ==========================
    GetPage(name: vendorHomeScreen, page: () => VendorHomeScreen()),
    GetPage(name: addVenueScreen, page: () => AddVenueScreen()),
    GetPage(name: vendorMyVenuesScreen, page: () => VendorMyVenuesScreen()),
    GetPage(name: vendorBookingRequestScreen, page: () => VendorBookingRequestScreen()),
    GetPage(name: vendorBookingDetailsScreen, page: () => VendorBookingDetailsScreen()),
    GetPage(name: vendorAboutUsScreen, page: () => VendorAboutUsScreen()),
    GetPage(name: vendorAccountSettings, page: () => VendorAccountSettings()),
    GetPage(name: vendorChangePasswordScreen, page: () => VendorChangePasswordScreen()),
    GetPage(name: vendorEditProfileScreen, page: () => VendorEditProfileScreen()),
    GetPage(name: vendorHelpSupportScreen, page: () => VendorHelpSupportScreen()),
    GetPage(name: vendorNotificationSettingScreen, page: () => VendorNotificationSettingScreen()),
    GetPage(name: vendorPrivacyScreen, page: () => VendorPrivacyScreen()),
    GetPage(name: vendorProfileCollectScreen, page: () => VendorProfileCollectScreen()),
    GetPage(name: vendorProfileScreen, page: () => VendorProfileScreen()),
    GetPage(name: vendorTermsScreen, page: () => VendorTermsScreen()),
    GetPage(name: vendorMessageListScreen, page: () => VendorMessageListScreen()),
    GetPage(name: userSearchVenueScreen, page: () => UserSearchVenueScreen()),
    GetPage(name: userVenueDetailsScreen, page: () => UserVenueDetailsScreen()),
    GetPage(name: bookYourSlotScreen, page: () => BookYourSlotScreen()),
    GetPage(name: userMyBookingsScreen, page: () => UserMyBookingsScreen()),
    GetPage(name: userAllSportsScreen, page: () => UserAllSportsScreen()),
    GetPage(name: editVenueScreen, page: () => EditVenueScreen()),
    GetPage(name: venueDetailsScreen, page: () => VenueDetailsScreen()),
    GetPage(name: venueAvailabilityScreen, page: () => VenueAvailabilityScreen()),


  ];
}

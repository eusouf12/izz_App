import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../../service/api_check.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../../../../../utils/app_const/app_const.dart';
import '../../vendor_home_screen/model/about_model.dart';
import '../../vendor_home_screen/model/vedor_privacy_model.dart';
import '../model/terms_model.dart';

class VendorProfileController extends GetxController {
  ///========= Image Picker GetX Controller Code ===========//
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  RxBool isLoading = false.obs;

  // Content Strings
  RxString termsContent = "".obs;
  RxString privacyContent = "".obs;
  RxString aboutUsContent = "".obs;

  // Loading States
  RxBool updateProfileLoading = false.obs;
  RxBool isProfileLoading = false.obs;
  RxBool updatePasswordLoading = false.obs;

  // Text Controllers for Profile
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<TextEditingController> dobController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> oldPasswordController = TextEditingController().obs;

  // Image Pickers
  //==========================================
  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  //==========================================// Terms, Privacy, About Us (Existing Logic)//==========================================
  final rxTermsStatus = Status.loading.obs;
  void setTermsStatus(Status value) {rxTermsStatus.value = value;}

  Rx<TermsResponseModel> termsResponse = TermsResponseModel(data: []).obs;

  Future<void> getTermsConditions() async {
    try {
      setTermsStatus(Status.loading);

      var response = await ApiClient.getData(ApiUrl.termsCondition);

      if (response.statusCode == 200) {
        termsResponse.value = TermsResponseModel.fromJson(response.body);

        setTermsStatus(Status.completed);
      } else if (response.statusCode == 404) {
        setTermsStatus(Status.error);
      } else {
        if (response.statusText == ApiClient.somethingWentWrong) {
          setTermsStatus(Status.internetError);
        } else {
          setTermsStatus(Status.error);
        }
      }
    } catch (e) {
      debugPrint("Terms API error: $e");
      setTermsStatus(Status.error);
    }
  }

  Future<void> getPrivacyPolicy() async {
    isLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.privacyPolicy);
      if (response.statusCode == 200) {
        var responseData = response.body['data'];
        if (responseData != null && responseData is List) {
          List<PrivacyPolicyModel> data = responseData
              .map((e) => PrivacyPolicyModel.fromJson(e))
              .toList();
          privacyContent.value = data
              .map((e) => e.description ?? "")
              .join("\n\n");
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("Error fetching privacy policy: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Rx<AboutAppResponseModel> aboutResponse = AboutAppResponseModel().obs;
  RxBool isLoadingAbout = false.obs;
  Future<void> getAboutUsData() async {
    isLoadingAbout.value = true;

    try {
      var response = await ApiClient.getData(ApiUrl.aboutUs);

      if (response.statusCode == 200) {
        aboutResponse.value = AboutAppResponseModel.fromJson(response.body);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("Error fetching about us: $e");
    } finally {
      isLoadingAbout.value = false;
    }
  }

  //==========================================// Change Password (UPDATED with JSON Encode)//==========================================
  Future<void> changePassword() async {
    updatePasswordLoading.value = true;

    try {
      Map<String, String> body = {
        "oldPassword": oldPasswordController.value.text.trim(),
        "newPassword": newPasswordController.value.text.trim(),
      };

      var response = await ApiClient.putData(ApiUrl.changePassword, body,);

      updatePasswordLoading.value = false;

      var jsonResponse = response.body is String
          ? jsonDecode(response.body)
          : response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          jsonResponse['message'] ?? "Password changed!",
          isError: false,
        );
        resetPasswordFields();
        Get.back();
      } else {
        showCustomSnackBar(
          jsonResponse['message'] ?? "Failed to change password",
          isError: true,
        );
      }
    } catch (e) {
      updatePasswordLoading.value = false;
      print("Change Password Error: $e");
      showCustomSnackBar("Something went wrong.", isError: true);
    }
  }

  void resetPasswordFields() {
    oldPasswordController.value.clear();
    newPasswordController.value.clear();
    confirmPasswordController.value.clear();
  }

  Rx<UserProfileModel> userProfileModel = UserProfileModel(
    id: '',
    fullName: '',
    email: '',
    contactNumber: '',
    dateOfBirth: '',
    photo: '',
    country: '',
    referralCode: '',
  ).obs;

  Future<void> getUserProfile() async {
    final userId = await SharePrefsHelper.getString(AppConstants.userId);

    var response = await ApiClient.getData(ApiUrl.vendorProfile);

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        var data = response.body['data'];
        userProfileModel.value = UserProfileModel.fromJson(data);

        if (nameController.value.text.isEmpty) {
          nameController.value.text = userProfileModel.value.fullName;
        }
        emailController.value.text = userProfileModel.value.email;
        if (phoneController.value.text.isEmpty) {
          phoneController.value.text = userProfileModel.value.contactNumber;
        }
        if (countryController.value.text.isEmpty) {
          countryController.value.text = userProfileModel.value.country!;
        }

        // setRequestStatus(Status.completed);
        update();
      } catch (e) {
        // setRequestStatus(Status.error);
        debugPrint("Parsing error: $e");
      }
    } else {
      // setRequestStatus(Status.error);
      Get.snackbar("Error", "Failed to load user profile.");
    }
  }

  Future<void> updateProfile() async {
    updateProfileLoading.value = true;
    refresh();

    try {
      Map<String, String> body = {
        "fullName": nameController.value.text.trim(),
        "contactNumber": phoneController.value.text.trim(),
        "country": countryController.value.text,
      };

      dynamic response;
      if (selectedImage.value != null) {
        response = await ApiClient.patchMultipartData(
          ApiUrl.updateProfile,
          body,
          multipartBody: [MultipartBody("profileImage", selectedImage.value!)],
        );
      } else {
        response = await ApiClient.patchData(
          ApiUrl.updateProfile,
          jsonEncode(body),
        );
      }

      updateProfileLoading.value = false;
      refresh();

      Map<String, dynamic> jsonResponse = response.body is String
          ? jsonDecode(response.body)
          : response.body as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ??
              "Profile updated successfully!",
          isError: false,
        );

        String? userRole = await SharePrefsHelper.getString(AppConstants.role);
        debugPrint("userRole=============================: $userRole");

        resetPasswordFields();
        await getUserProfile();
        Get.back();

        // if (userRole.toLowerCase() == "host") {
        //   Get.offAllNamed(AppRoutes.profileScreen);
        // } else {
        //   Get.offAllNamed(AppRoutes.dmProfileScreen);
        // }
      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Update failed",
          isError: true,
        );
      }
    } catch (e) {
      updateProfileLoading.value = false;
      refresh();
      showCustomSnackBar("An error occurred. Please try again.", isError: true);
      debugPrint("Profile update error: $e");
    }
  }

  //============ delete account ===============
  Future<void> deleteAccount({required String userId}) async {
    try {
      final response = await ApiClient.deleteData(ApiUrl.deleteAccount(userId: userId));
      final jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200 || response.statusCode == 204) {
        showCustomSnackBar(jsonResponse["message"] ?? "Account deleted successfully!", isError: false,);
        Get.offAllNamed(AppRoutes.loginScreen);

      } else {
        debugPrint("Failed to delete account");
        showCustomSnackBar(jsonResponse["message"] ?? "Failed to delete account", isError: true,);
      }

    } catch (e) {
      debugPrint("Error deleting account: $e");
      showCustomSnackBar("Something went wrong!", isError: true,);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}

class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String contactNumber;
  final String? dateOfBirth;
  final String? country;
  final String? address;
  final String photo;
  final String referralCode;

  UserProfileModel({
    this.country,
    this.address,
    required this.id,
    required this.fullName,
    required this.email,
    required this.contactNumber,
    this.dateOfBirth,
    required this.photo,
    required this.referralCode,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      country: json['country'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      photo: json['profileImage'] ?? '',
      referralCode: json['referralCode'] ?? '',
    );
  }
}

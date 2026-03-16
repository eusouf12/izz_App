import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Ensure this package is added
import '../../../../core/app_routes/app_routes.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_check.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../utils/ToastMsg/toast_message.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/app_strings/app_strings.dart';

class AuthController extends GetxController {
  ///========== Text Controllers ==========
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> dateOfBirthController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;

  // Login Controllers
  Rx<TextEditingController> loginEmailController = TextEditingController().obs;
  Rx<TextEditingController> loginPasswordController = TextEditingController().obs;

  // Forgot/Reset Password Controllers
  Rx<TextEditingController> forgetPasswordController = TextEditingController().obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;
  Rx<TextEditingController> updatePasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmNewPasswordController = TextEditingController().obs;

  ///========== Loading States ==========
  RxBool signUpLoading = false.obs;
  RxBool loginLoading = false.obs;
  RxBool forgetPasswordLoading = false.obs;
  RxBool otpLoading = false.obs;
  RxBool updatePasswordLoading = false.obs;

  Future<void> signUp({required String role}) async {
    signUpLoading.value = true;

    // String role = await SharePrefsHelper.getString(AppConstants.role);

    Map<String, dynamic> body = {
      "fullName": nameController.value.text.trim(),
      "password": passwordController.value.text,
      "email": emailController.value.text.trim().toLowerCase(),
      "role": role,
    };

    try {
      var response = await ApiClient.postData(ApiUrl.signUp, jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        signUpLoading.value = false;
        refresh();

        Map<String, dynamic> jsonResponse;

        if (response.body is String) {
          // If it's a string, decode it
          jsonResponse = jsonDecode(response.body);
        } else {
          // If it's already a Map (which it is from your ApiClient), use it directly
          jsonResponse = response.body as Map<String, dynamic>;
        }

        // Show success message
        showCustomSnackBar(jsonResponse['message']?.toString() ?? "Registration successful! Please verify your email.", isError: false);
        // Navigate to OTP screen
        Get.toNamed(
          AppRoutes.otpScreen,
          arguments: SignUpAuthModel(
            emailController.value.text,
            AppStrings.signUp,
          ),
        );

        // Clear signup data
        clearSignUpData();
      } else {
        signUpLoading.value = false;
        refresh();

        if (response.statusText == ApiClient.somethingWentWrong) {
          showCustomSnackBar(AppStrings.checknetworkconnection, isError: true);
        } else {
          ApiChecker.checkApi(response);
        }
      }
    } catch (e) {
      signUpLoading.value = false;
      refresh();
      showCustomSnackBar("An error occurred. Please try again.", isError: true);
      debugPrint("SignUp Error: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    //loginEmailController.value.text = "fdafdfda";
    loginEmailController.value.text = "dabatoshpaul48@gmail.com" ;
    loginPasswordController.value.text = "123456789";
  }

  Future<void> loginUser() async {
    loginLoading.value = true;

    try {
      // Get device FCM token
      final deviceFcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint("Device FCM Token: $deviceFcmToken");

      // Login request body
      Map<String, String> body = {
        "email": loginEmailController.value.text.trim(),
        "password": loginPasswordController.value.text.trim(),
        "fcmToken": deviceFcmToken ?? "",
      };

      var response = await ApiClient.postData(
        ApiUrl.signIn,
        jsonEncode(body),
      );

      loginLoading.value = false;
      refresh();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse =
        response.body is String ? jsonDecode(response.body) : response.body;

        showCustomSnackBar(jsonResponse['message'] ?? "Login successful", isError: false);

        // Store tokens & user info
        final data = jsonResponse['data'];
        String accessToken = data['accessToken'];
        await SharePrefsHelper.setString(AppConstants.bearerToken, accessToken);

        final decoded = JwtDecoder.decode(accessToken);
        String userId = decoded['id'];
        String userRole = decoded['role'];
        await SharePrefsHelper.setString(AppConstants.userId, userId);
        await SharePrefsHelper.setString(AppConstants.role, userRole);

        // Backend saved FCM token (debug)
        String backendFcmToken = data['user']?['fcmToken'] ?? "";
        debugPrint("✅ Backend Saved FCM Token: $backendFcmToken");

        // Navigate based on role
        if (userRole == "VENDOR") {
          Get.offAllNamed(AppRoutes.vendorHomeScreen);
        } else {
          Get.offAllNamed(AppRoutes.userHomeScreen);
        }

        // Listen to FCM token refresh
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
          debugPrint("🔄 FCM Token refreshed: $newToken");
          await ApiClient.postData(
            ApiUrl.signIn,
            jsonEncode({
              "userId": userId,
              "fcmToken": newToken,
            }),
          );
        });

      } else {
        Map<String, dynamic> errorResponse =
        response.body is String ? jsonDecode(response.body) : response.body;

        showCustomSnackBar(errorResponse['message'] ?? "Login failed", isError: true);
      }
    } catch (e) {
      loginLoading.value = false;
      refresh();
      showCustomSnackBar("An error occurred. Please try again.", isError: true);
      debugPrint("Login Error: $e");
    }
  }

  ///========== Forgot Password (Step 1) ==========
  Future<void> forgetPassword() async {
    forgetPasswordLoading.value = true;
    Map<String, String> body = { "email": forgetPasswordController.value.text.trim() };

    try {
      var response = await ApiClient.postData(ApiUrl.forgotPassword, jsonEncode(body));
      forgetPasswordLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Check your email for OTP", isError: false);
        Get.toNamed(AppRoutes.otpScreen, arguments: AppStrings.forgetPassword);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      forgetPasswordLoading.value = false;
      showCustomSnackBar("An error occurred.", isError: true);
    }
  }

  ///========== Verify OTP (Step 2) ==========
  Future<void> verifyOtp({required String screenName}) async {
    otpLoading.value = true;

    if (otpController.value.text.isEmpty) {
      otpLoading.value = false;
      showCustomSnackBar("OTP cannot be empty.", isError: true);
      return;
    }

    Map<String, dynamic> body = { "otp": otpController.value.text.trim() };

    try {
      var response = await ApiClient.postData(ApiUrl.verifyOtp, jsonEncode(body));
      otpLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;
        showCustomSnackBar("Verified successfully!", isError: false);
        otpController.value.clear();

        if (screenName == AppStrings.forgetPassword) {
          // === FORGOT PASSWORD FLOW ===
          if (jsonResponse['data'] != null && jsonResponse['data']['accessToken'] != null) {
            String accessToken = jsonResponse['data']['accessToken'];

            // Decode Token to get ID
            Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
            String userId = decodedToken['id'] ?? decodedToken['_id'] ?? decodedToken['userId'] ?? '';

            if (userId.isNotEmpty) {
              // Pass BOTH id and token to the next screen
              Get.toNamed(
                  AppRoutes.setNewPassword,
                  arguments: {
                    "id": userId,
                    "token": accessToken
                  }
              );
            } else {
              showCustomSnackBar("Invalid token: User ID not found", isError: true);
            }
          } else {
            showCustomSnackBar("Token not found in response", isError: true);
          }
        } else {
          // === SIGN UP FLOW ===
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      otpLoading.value = false;
      showCustomSnackBar("An error occurred.", isError: true);
    }
  }

  ///========== Reset Password (Step 3) ==========
  // Accepts token to put in Header, userId for Body
  Future<void> resetPassword({required String userId, required String token}) async {
    if (updatePasswordController.value.text != confirmNewPasswordController.value.text) {
      showCustomSnackBar("Passwords do not match", isError: true);
      return;
    }

    updatePasswordLoading.value = true;

    // Body: ID + Passwords
    Map<String, dynamic> body = {
      "id": userId,
      "password": updatePasswordController.value.text,
      "confirmPassword": confirmNewPasswordController.value.text,
    };

    // Header: Authorization Bearer Token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };

    try {
      // Pass headers manually to override default logic
      var response = await ApiClient.postData(
          ApiUrl.resetPassword,
          jsonEncode(body),
          headers: headers
      );

      updatePasswordLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Password reset successfully!", isError: false);

        updatePasswordController.value.clear();
        confirmNewPasswordController.value.clear();
        forgetPasswordController.value.clear();

        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      updatePasswordLoading.value = false;
      showCustomSnackBar("An error occurred.", isError: true);
    }
  }

  void clearSignUpData() {
    nameController.value.clear();
    emailController.value.clear();
    phoneNumberController.value.clear();
    dateOfBirthController.value.clear();
    passwordController.value.clear();
    confirmPasswordController.value.clear();
  }
}

///========== Models ==========
class SignUpAuthModel {
  final String email;
  final String screenName;

  SignUpAuthModel(
      this.email,
      this.screenName,
      );
}
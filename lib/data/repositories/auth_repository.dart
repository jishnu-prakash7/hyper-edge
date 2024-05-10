import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_media/core/utils/api_end_points.dart';
import 'package:social_media/domain/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/presentation/widgets/common_widgets.dart';

class AuthRepo {
  static var client = http.Client();
  static Future<String> signup(UserModel user) async {
    try {
      var response = await client.post(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.signUp}'),
          body: jsonEncode(user),
          headers: {'Content-Type': 'application/json'});
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return 'Successful';
      } else if (responseBody['message'] == "You already have an account.") {
        return 'You Already have an account';
      } else if (responseBody['message'] ==
          "OTP already sent within the last one minute") {
        return "OTP already sent within the last one minute";
      } else if (response.statusCode == 500) {
        return 'Something wrong please try after sometime';
      }
      return 'failed';
    } catch (e) {
      log(e.toString());
      return 'failed';
    }
  }

  static Future<String> verifyotp(String email, String otp) async {
    try {
      final user = {'email': email, 'otp': otp};
      var response = await client.post(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.verifyOtp}'),
          body: jsonEncode(user),
          headers: {'Content-Type': 'application/json'});
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return 'Successful';
      } else if (responseBody['message'] ==
          "Invalid verification code or OTP expired") {
        return 'Invalid verification code or OTP expired';
      } else if (response.statusCode == 500) {
        return 'Something went wrong please try after sometime.';
      }
      return 'failed';
    } catch (e) {
      log(e.toString());
      return 'failed';
    }
  }

  static Future userLogin(String email, String password) async {
    try {
      final user = {'email': email, 'password': password};
      var response = await client.post(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}'),
          body: jsonEncode(user),
          headers: {"Content-Type": 'application/json'});
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await setUserLoggedin(
          token: responseBody['user']['token'],
          userrole: responseBody['user']['role'],
          userid: responseBody['user']['_id'],
          userEmail: responseBody['user']['email'],
          userName: responseBody['user']['userName'],
          userprofile: responseBody['user']['profilePic'],
        );
        return responseBody;
      } else {
        return responseBody;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:social_media/core/utils/urls.dart';
import 'package:social_media/data/repositories/post_repository.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;

class UserRepo {
  static var client = http.Client();
  //Fetch loggedIn user posts
  static Future fetchUserPosts({String? userId}) async {
    try {
      final loggineduserId = await getUserId();
      var response = await client.get(Uri.parse(
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getPostByUserId}/${userId == '' ? loggineduserId : userId}'));
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//Fetch loggedIn user details
  static Future fetchLoggedInUserDetails() async {
    try {
      final token = await getUsertoken();
      var response = await client.get(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.logginedUser}'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//Edit Profile
  static Future editProfile(
      {required image,
      String? name,
      String? bio,
      String? imageUrl,
      String? bgImageUrl,
      required bgImage}) async {
    try {
      dynamic cloudinaryimageUrl;
      dynamic cloudinarybgimageUrl;
      if (imageUrl == '') {
        cloudinaryimageUrl = await PostRepo.uploadImage(image);
      }
      if (bgImageUrl == '') {
        cloudinarybgimageUrl = await PostRepo.uploadImage(bgImage);
      }
      final token = await getUsertoken();
      final details = {
        "name": name ?? '',
        "bio": bio ?? '',
        "image": imageUrl == '' ? cloudinaryimageUrl : imageUrl,
        "backGroundImage": bgImageUrl == '' ? cloudinarybgimageUrl : bgImageUrl
      };
      var response = await client.put(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.editProfile}'),
          body: jsonEncode(details),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return response;
    } catch (e) {
      log(e.toString());
    }
    // final image
  }

//fetch followers
  static Future fetchFollowers() async {
    try {
      final token = await getUsertoken();
      var response = client.get(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.getFollowers}'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  //fetch followers
  static Future fetchFollowing() async {
    try {
      final token = await getUsertoken();
      var response = client.get(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.getFollowing}'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//follow user
  static Future followUser({required String followeesId}) async {
    try {
      final token = await getUsertoken();
      var response = client.post(
          Uri.parse(
              '${ApiEndpoints.baseUrl}${ApiEndpoints.followUser}/$followeesId'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  //unfollow user
  static Future unfollowUser({required String followeesId}) async {
    try {
      final token = await getUsertoken();
      var response = client.put(
          Uri.parse(
              '${ApiEndpoints.baseUrl}${ApiEndpoints.unfollowUser}/$followeesId'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//fetchsuggession user
  static Future fetchSuggessionUser() async {
    try {
      final token = await getUsertoken();
      var response = client.get(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.suggessions}'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//get single user
  static Future getSingleUser({required String userid}) async {
    try {
      final token = await getUsertoken();
      var response = client.get(
          Uri.parse(
              '${ApiEndpoints.baseUrl}${ApiEndpoints.getSingleUser}/$userid'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//get connections
  static Future getConnections({required String userId}) async {
    try {
      final token = await getUsertoken();
      var response = client.get(
          Uri.parse(
              '${ApiEndpoints.baseUrl}${ApiEndpoints.getConnections}/$userId'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

// search all users
  static Future searchAllUsers({required String query}) async {
    try {
      final token = await getUsertoken();
      var response = await client.get(
          Uri.parse(
              '${ApiEndpoints.baseUrl}${ApiEndpoints.searchAllUsers}$query'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }
}

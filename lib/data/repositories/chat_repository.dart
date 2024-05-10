import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:social_media/core/utils/api_end_points.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class ChatRepo {
  static var client = http.Client();

//Create conversation
  static Future createConversation({required List<String> members}) async {
    try {
      final token = await getUsertoken();
      final body = {"members": members};
      var response = client.post(
          Uri.parse(
              '${ApiEndpoints.baseUrl}${ApiEndpoints.createConversation}'),
          body: jsonEncode(body),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': "application/json"
          });
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//get all conversations
  static Future getAllConversations() async {
    try {
      final token = await getUsertoken();
      var response = client.get(
          Uri.parse(
              '${ApiEndpoints.baseUrl}${ApiEndpoints.getAllConversations}'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//Add message
  static Future addMessage(
      {required String recieverId,
      required String text,
      required String conversationId,
      required String senderId}) async {
    try {
      final token = await getUsertoken();
      final body = {
        "senderId": senderId,
        "conversationId": conversationId,
        "text": text,
        "recieverId": recieverId
      };
      var response = client.post(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.addMessage}'),
          body: jsonEncode(body),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-Type": 'application/json'
          });
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

//get all Messages
  static Future getAllMessages({required String conversationId}) async {
    try {
      final token = await getUsertoken();
      var response = client.get(
          Uri.parse(
              '${ApiEndpoints.baseUrl}${ApiEndpoints.getAllMessages}/$conversationId'),
          headers: {'Authorization': 'Bearer $token'});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }
}

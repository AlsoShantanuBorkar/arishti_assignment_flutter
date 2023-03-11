import 'dart:convert';
import 'dart:developer';

import 'package:arishti_assignment_flutter/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageServiceProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  List<String> _users = [];
  List<String> get users => _users;

  Future<void> getAllMessages(
      String senderEmail, String receiverEmail, token) async {
    _isLoading = true;
    notifyListeners();
    http.Response response = await http.post(
        Uri.parse(
          "${ApiConstants.baseURL}${ApiConstants.messages}",
        ),
        body: {
          "sender_email": senderEmail,
          "receiver_email": receiverEmail,
        },
        headers: {
          "token": token
        });
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> decodedResponse =
          (jsonDecode(response.body) as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();

      _messages = decodedResponse;
      _isLoading = false;
      notifyListeners();
    } else {
      log(response.body);
    }
  }

  Future<void> getUsers() async {
    http.Response response = await http
        .get(Uri.parse("${ApiConstants.baseURL}${ApiConstants.users}"));
    _isLoading = true;
    notifyListeners();
    if (response.statusCode == 200) {
      List<String> data = [];
      var decodedResponse = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>);
      for (var element in decodedResponse) {
        data.add(element['email']);
      }
      _users = data;
      _isLoading = false;
      notifyListeners();
    }
  }

  void addMessage(Map<String, dynamic> message) {
    _messages.add(message);
    notifyListeners();
  }
}

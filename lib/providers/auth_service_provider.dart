// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:arishti_assignment_flutter/api_constants.dart';
import 'package:arishti_assignment_flutter/providers/message_service_provider.dart';
import 'package:arishti_assignment_flutter/providers/socket_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthServiceProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;

  Map<String, String?> _userData = {};
  Map<String, String?> get userData => _userData;

  Future<void> authenticateUser(
      Map<String, String?> data, bool isLogin, BuildContext context) async {
    _userData = data;
    _isLoading = true;
    notifyListeners();
    http.Response response = await http.post(
      Uri.parse(
        "${ApiConstants.baseURL}${isLogin ? ApiConstants.login : ApiConstants.register}",
      ),
      body: data,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse =
          jsonDecode(response.body) as Map<String, dynamic>;

      token = decodedResponse["token"]!;
      _isLoading = false;

      SocketServiceProvider socketServiceProvider =
          Provider.of<SocketServiceProvider>(context, listen: false);
      socketServiceProvider.setUserData(data['email']!);
      socketServiceProvider.setToken(token);
      socketServiceProvider.initSocket();

      Provider.of<MessageServiceProvider>(context, listen: false).getUsers();
      notifyListeners();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      log(response.body);
      _isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.body.toString(),
          ),
        ),
      );
      notifyListeners();
    }
  }
}

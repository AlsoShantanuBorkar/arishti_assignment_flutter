// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:arishti_assignment_flutter/providers/message_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:arishti_assignment_flutter/api_constants.dart';

class SocketServiceProvider extends ChangeNotifier {
  late io.Socket socket;
  late String _jwtToken;
  late String userData;
  final BuildContext context;
  SocketServiceProvider(this.context);

  void setToken(String token) {
    _jwtToken = token;
  }

  void setUserData(String data) {
    userData = data;
  }

  void initSocket() async {
    debugPrint('Attempting to connect');
    try {
      socket = io.io(
        ApiConstants.baseURL,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setExtraHeaders({"token": _jwtToken})
            .build(),
      );

      socket.onConnect((data) {
        debugPrint("Connected");
      });

      socket.on(userData, (data) {
        Provider.of<MessageServiceProvider>(context, listen: false)
            .addMessage(data);
      });

      socket.on("disconnect", (data) => log(data.toString()));
    } catch (e) {
      log(e.toString());
    }
  }

  void sendMessage(String receiverEmail, String message) {
    socket.emit("send_message", {
      "userOne": userData,
      "userTwo": receiverEmail,
      "from": userData,
      "message": message,
    });
  }
}

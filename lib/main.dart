import 'dart:developer';

import 'package:arishti_assignment_flutter/firebase_options.dart';
import 'package:arishti_assignment_flutter/providers/auth_service_provider.dart';
import 'package:arishti_assignment_flutter/providers/message_service_provider.dart';
import 'package:arishti_assignment_flutter/providers/socket_service_provider.dart';
import 'package:arishti_assignment_flutter/screens/home.dart';
import 'package:arishti_assignment_flutter/screens/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print("message : ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  log('User granted permission: ${settings.authorizationStatus}');

  messaging.getToken().then(
        (value) => log(value.toString()),
      );

  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      // log(message.data);
    },
  );

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SocketServiceProvider(context),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/auth",
        routes: {
          '/auth': (context) => const AuthScreen(isLogin: false),
          '/home': (context) => const Home(),
        },
      ),
    );
  }
}

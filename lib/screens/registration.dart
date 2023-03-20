import 'package:arishti_assignment_flutter/providers/auth_service_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.isLogin});
  final bool isLogin;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServiceProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.isLogin ? "Login" : "Register"),
        ),
        body: value.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                      ),
                    ),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String? fcmToken =
                            await FirebaseMessaging.instance.getToken();
                        // ignore: use_build_context_synchronously
                        await value.authenticateUser({
                          "first_name": firstNameController.text,
                          "last_name": lastNameController.text,
                          "email": emailController.text,
                          "password": passwordController.text,
                          "fcm_token": fcmToken,
                        }, widget.isLogin, context);
                      },
                      child: const Text("Submit"),
                    ),
                    !widget.isLogin
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AuthScreen(isLogin: true),
                                ),
                              );
                            },
                            child: const Text("Have An Account? Login!"),
                          )
                        : Container()
                  ],
                ),
              ),
      ),
    );
  }
}

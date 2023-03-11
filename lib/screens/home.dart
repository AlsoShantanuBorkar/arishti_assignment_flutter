import 'package:arishti_assignment_flutter/providers/auth_service_provider.dart';
import 'package:arishti_assignment_flutter/providers/message_service_provider.dart';
import 'package:arishti_assignment_flutter/screens/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    AuthServiceProvider authServiceProvider =
        Provider.of<AuthServiceProvider>(context);
    return Consumer<MessageServiceProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
        ),
        body: value.users.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text("Fetching Users")
                    ]),
              )
            : ListView.builder(
                itemCount: value.users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          value.getAllMessages(
                              authServiceProvider.userData['email']!,
                              value.users[index],
                              authServiceProvider.token);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessageScreen(
                                        chattingWith: value.users[index],
                                      )));
                        },
                        title: Text(value.users[index]),
                      ),
                    ),
                  );
                }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            value.getUsers();
          },
          tooltip: 'Increment',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

import 'package:arishti_assignment_flutter/providers/message_service_provider.dart';
import 'package:arishti_assignment_flutter/providers/socket_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key, required this.chattingWith});
  final String chattingWith;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SocketServiceProvider socketServiceProvider =
        Provider.of<SocketServiceProvider>(context);
    return Consumer<MessageServiceProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.chattingWith),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (messageController.text.isNotEmpty) {
              socketServiceProvider.sendMessage(
                  widget.chattingWith, messageController.text);
              value.addMessage(
                {
                  "userOne": socketServiceProvider.userData,
                  "message": messageController.text
                },
              );
              messageController.clear();
            }
          },
          child: const Icon(Icons.send),
        ),
        body: value.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(value.messages[index]
                                              ['from'] ==
                                          socketServiceProvider.userData
                                      ? 0
                                      : 16),
                                  topRight: Radius.circular(
                                      value.messages[index]['from'] !=
                                              socketServiceProvider.userData
                                          ? 0
                                          : 16),
                                  bottomLeft: const Radius.circular(16),
                                  bottomRight: const Radius.circular(16),
                                ),
                                color: value.messages[index]['from'] ==
                                        socketServiceProvider.userData
                                    ? Colors.greenAccent
                                    : Colors.blueAccent,
                              ),
                              child: Text(
                                value.messages[index]['message'],
                                textAlign: value.messages[index]['from'] ==
                                        widget.chattingWith
                                    ? TextAlign.left
                                    : TextAlign.right,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          controller: messageController,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

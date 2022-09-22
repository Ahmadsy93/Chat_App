// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatPage extends StatelessWidget {
  final String email;
  ChatPage(this.email);

  final _controller = ScrollController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('createdAt').snapshots(),
        builder: (context, snapshot) {
          //print(snapshot.data!['New']);

          if (snapshot.hasData) {
            //print(snapshot.data!.docs[0]['New']);
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('Chat App'),
                  backgroundColor: Color.fromARGB(255, 13, 112, 192),
                  centerTitle: true,
                ),
                backgroundColor: Colors.black,
                body: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/wallpaper.jpg'))),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return messagesList[index].id == email
                                ?
                                //messagesList[index].id == email
                                chatWidget(message: messagesList[index])
                                : chatWidgetReceiver(
                                    message: messagesList[index]);
                            //         message: messagesList[index],
                            //       )
                            //     : ;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: controller,
                          onSubmitted: (value) {
                            if (value.isEmpty) {
                            } else {
                              messages.add(
                                {
                                  'message': value,
                                  'createdAt': DateTime.now(),
                                  'id': email
                                },
                              );
                              controller.clear();
                              _controller.animateTo(
                                // animateTo or jumpTo
                                _controller.position.maxScrollExtent,
                                duration: Duration(
                                    seconds:
                                        1), // another solution to scroll the listView
                                curve: Curves.fastLinearToSlowEaseIn,
                              );
                            }
                          },
                          decoration: InputDecoration(
                              hintText: 'Send message',
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: Color.fromARGB(255, 13, 112, 192),
                                  ),
                                  onPressed: () {}),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white))),
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            return Text('Loading');
          }
        });
  }
}

class chatWidget extends StatelessWidget {
  const chatWidget({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(
          left: 15,
          top: 16,
          bottom: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Text(
          message.message,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class chatWidgetReceiver extends StatelessWidget {
  const chatWidgetReceiver({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(
          left: 15,
          top: 16,
          bottom: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
          color: Colors.blueAccent,
        ),
        child: Text(
          message.message,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

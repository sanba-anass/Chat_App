import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:fun_chat_app/widgets/current_user_message.dart';
import 'package:fun_chat_app/widgets/other_user_messages.dart';
import 'package:provider/provider.dart';

// hide my message for all users expect this user whom i'm talking to
class Messages extends StatefulWidget {
  static final db = FirebaseFirestore.instance;
  static final currrentUserId = FirebaseAuth.instance.currentUser!.uid;

  Messages({
    Key? key,
  }) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  static final currrentUserId = FirebaseAuth.instance.currentUser!.uid;

  /* var _future;
  init() {
    _future = FirebaseFirestore.instance.collection('messages').get();
  } */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: Messages.db
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.hasData) {
            final messages = snapshot.data!;

            return ListView.builder(
                reverse: true,
                itemCount: messages.docs.length,
                itemBuilder: (context, index) {
                  bool isMe = messages.docs[index].data()['userId'] ==
                      Messages.currrentUserId;
                  return isMe
                      ? CurrentUserMessage(messages: messages, index: index)
                      : OtherUserMessages(messages: messages, index: index);
                });
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              value: 4.0,
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:zing_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String message;

  void getCurrentUser() {
    try{
      final user = _auth.currentUser!;
      loggedInUser = user;
    } catch(e){
      print(e);
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs){
  //     print(message.data());
  //   }
  // }
  
  // void messageStream() async {
  //   await for(var snapshot in _firestore.collection('messages').snapshots()){
  //     for(var message in snapshot.docs){
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Padding(
          padding: EdgeInsets.only(right: 25.0),
          child: Center(
              child: Text(
                  '⚡️Chat',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
          ),
        ),
        backgroundColor: kAppColor,
      ),
      body: SafeArea(
        child: Container(
          color: kAppColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: kBackgroundColor,
                  ),
                  child: const Column(
                    children: [
                      MessageStream(),
                    ],
                  ),
                ),
              ),
              Container(
                color: kBackgroundColor,
                child: Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            message = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          messageTextController.clear();
                          try {
                            String senderDisplayName = loggedInUser.displayName ?? 'User';
                            senderDisplayName = capitalizeFirstLetter(senderDisplayName);
                            await _firestore.collection('messages').add({
                              'text': message,
                              'senderName': senderDisplayName,
                              'senderEmail': loggedInUser.email,
                              'time': DateTime.now(),
                            });
                          } catch (e) {
                            print('Error adding message to Firestore: $e');
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: kAppColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.isOwner, required this.name});

  final String text;
  final String name;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isOwner ? 'You' : name,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isOwner ? const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ) : const BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isOwner ? kAppColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                  text,
                style: TextStyle(
                  color: isOwner ? Colors.white : Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy("time", descending: false).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: kAppColor,
            ),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<MessageBubble> messageBubbles= [];
        for(var message in messages!){
          final messageBlock = message.data() as Map;
          final messageText = messageBlock['text'];
          final messageSenderEmail = messageBlock['senderEmail'];
          final messageSenderName = messageBlock['senderName'];
          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubble(
            text: messageText,
            name: messageSenderName,
            isOwner: currentUser == messageSenderEmail,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}



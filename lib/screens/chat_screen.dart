import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_buddy/screens/group_info_screen.dart';
import 'package:message_buddy/widgets/constants.dart';
import 'package:message_buddy/widgets/messages_tile.dart';
import 'package:sizer/sizer.dart';
import '../service/database_service.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'ChatScreen';

  final String groupId;
  final String groupName;
  final String userName;

  const ChatScreen(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chats;
  String admin = '';
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getChatandAdmin;
    super.initState();
  }

  getChatandAdmin() {
    DataBaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
      DataBaseService().getGroupAdmin(widget.groupId).then((value) {
        setState(() {
          admin = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.groupName,
          style: smallHeading.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        leading: IconButton(
          tooltip: 'Go back to the previous screen',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            tooltip: 'Group Info',
            onPressed: () {
              nextScreenReplacement(
                  context,
                  GroupInfoScreen(
                    groupId: widget.groupId,
                    userName: widget.userName,
                    groupName: widget.groupName,
                  ));
            },
            icon: const Icon(
              Icons.info_outlined,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 2.h),
              color: Colors.black.withOpacity(0.1),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.newline,
                      controller: messageController,
                      autofocus: false,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Start a message...',
                        prefixIcon: const Icon(
                          Icons.message_rounded,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessages();
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessagesTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Center(
                child: Text(
                  'Start a conversation...',
                  style: smallHeading,
                ),
              );
      },
    );
  }

  sendMessages() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        'message': messageController.text,
        'sender': widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      DataBaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}

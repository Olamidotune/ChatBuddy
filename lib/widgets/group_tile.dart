import 'package:flutter/material.dart';
import 'package:message_buddy/screens/chat_screen.dart';
import 'package:message_buddy/widgets/constants.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile({
    super.key,
    required this.userName,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
          context,
          ChatScreen(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.userName,
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                style: smallHeading,
              ),
            ),
            title: Text(
              widget.groupName,
              style: smallHeading,
            ),
            subtitle: Text(
              'Join the conversation as ${widget.userName}',
              style: normalText,
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

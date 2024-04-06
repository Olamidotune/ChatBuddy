import 'package:flutter/material.dart';
import 'package:message_buddy/widgets/constants.dart';
class MessagesTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessagesTile(
      {Key? key,
      required this.sender,
      required this.message,
      required this.sentByMe})
      : super(key: key);

  @override
  State<MessagesTile> createState() => _MessagesTileState();
}

class _MessagesTileState extends State<MessagesTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 30),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: widget.sentByMe ? Colors.red : Colors.green,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: normalText,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: smallHeading,
            )
          ],
        ),
      ),
    );
  }
}

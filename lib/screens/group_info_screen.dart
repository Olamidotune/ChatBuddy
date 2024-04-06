import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_buddy/screens/home_screen.dart';
import 'package:message_buddy/service/auth_service.dart';
import 'package:message_buddy/service/database_service.dart';
import 'package:message_buddy/widgets/constants.dart';
import 'package:sizer/sizer.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const GroupInfoScreen(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  AuthService authService = AuthService();
  User? user;

  void getMembers() async {
    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Leave group',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      content: Text(
                        'Are you sure you want to leave "${widget.groupName}" group?',
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            //to exit the current group.
                            DataBaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                            )
                                .toggleGroupJoin(
                                  getName(widget.userName),
                                  widget.groupId,
                                  widget.groupName,
                                )
                                .whenComplete(
                                  () => Navigator.of(context)
                                      .popAndPushNamed(HomeScreen.routeName),
                                );
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        )
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.logout),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.groupName,
          style: smallHeading.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            tileColor: Colors.black,
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 30,
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                style: smallHeading.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            title: Text("Group: ${widget.groupName}", style: smallHeading),
            subtitle: Text('Admin: ${widget.userName}', style: smallHeading),
          ),
          const SizedBox(
            height: 10,
          ),
          memberList()
        ],
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['members'].length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ListTile(
                      tileColor: Colors.white38,
                      leading: CircleAvatar(
                        radius: 25,
                        child: Text(
                          widget.userName.substring(0, 1).toUpperCase(),
                          style: smallHeading,
                        ),
                      ),
                      title: Text(
                        getName(
       
                          snapshot.data['members'][index],
                        ),
                      ),
                      subtitle: const Text('Member'),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('There are no members'),
              );
            }
          } else {
            return const Center(
              child: Text('There are no members'),
            );
          }
        } else {
          return const CircularProgressIndicator(
            color: Colors.blue,
          );
        }
      },
    );
  }
}


// come back and refactor the admin and member's tile.
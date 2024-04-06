import 'package:flutter/material.dart';
import 'package:message_buddy/screens/home_screen.dart';
import 'package:message_buddy/service/auth_service.dart';
import 'package:message_buddy/widgets/constants.dart';
import 'package:sizer/sizer.dart';
import '../auth/login_screen.dart';
import '../helper/helper_functions.dart';
import '../widgets/drawer_button.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
 final String email;

  static const String routeName = 'Profile Screen';

  const ProfileScreen({Key? key, required this.userName, required this.email})
      : super(key: key);

  @override

  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService authService = AuthService();
  String email = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailfromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunctions.getUserNamefromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 20,
        width: 55.w,
        child: ListView(
          children: <Widget>[
            const Icon(Icons.account_circle, size: 50),
            SizedBox(
              height: 1.h,
            ),
            Text(
              userName,
              style: smallHeading.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 1.h,
            ),
            const Divider(
              thickness: 1,
              color: Colors.black54,
            ),
            MyButton(
              selected: false,
              icon: Icons.group,
              action: 'Groups',
              onTap: () {
                Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
              },
            ),
            SizedBox(
              height: 1.h,
              child: const Divider(
                thickness: 1,
                color: Colors.black54,
              ),
            ),
            MyButton(
              selected: true,
              icon: Icons.account_circle_sharp,
              action: 'Profile',
              onTap: () {
                Navigator.of(context).popAndPushNamed(ProfileScreen.routeName);
              },
            ),
            SizedBox(
              height: 1.h,
              child: const Divider(
                thickness: 1,
                color: Colors.black54,
              ),
            ),
            MyButton(
              icon: Icons.logout,
              action: 'Logout',
              onTap: () async {
                myDialog(context);
              },
              selected: false,
            ),
            SizedBox(
              height: 1.h,
              child: const Divider(
                thickness: 1,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
          style: heading.copyWith(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 80,
              child: Icon(
                Icons.person,
                size: 100,
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fullname:',
                  style: smallHeading,
                ),
                Text(
                  userName,
                  style: smallHeading,
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email: ',
                  style: smallHeading,
                ),
                Text(
                  email,
                  style: smallHeading,
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> myDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text(
              'Are you sure you want to logout?',
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
                  await authService.signOut();

                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false);
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.green,
                ),
              )
            ],
          );
        });
  }
}

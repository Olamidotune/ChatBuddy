import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:message_buddy/helper/helper_functions.dart';
import 'package:message_buddy/screens/chat_screen.dart';
import 'package:message_buddy/screens/profile_screen.dart';
import 'package:message_buddy/screens/register_screen.dart';
import 'package:message_buddy/auth/login_screen.dart';
import 'package:message_buddy/screens/home_screen.dart';
import 'package:message_buddy/screens/search_screen.dart';
import 'package:message_buddy/shared/constants.dart';
import 'package:sizer/sizer.dart';

void main() async {
  if (kIsWeb) {
    // run app for web
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    // run app for Android and iOS
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    userLoggedInStatus();
  }

  userLoggedInStatus() async {
    HelperFunctions.userLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: _isSignedIn ? const HomeScreen() : const LoginScreen(),
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            ProfileScreen.routeName: (context) =>
                const ProfileScreen(email: '', userName: ''),
            ChatScreen.routeName: (context) => const ChatScreen(
                  groupId: '',
                  groupName: '',
                  userName: '',
                )
          },
        );
      },
    );
  }
}

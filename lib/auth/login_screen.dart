import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:message_buddy/screens/register_screen.dart';
import 'package:message_buddy/service/auth_service.dart';
import 'package:message_buddy/service/database_service.dart';
import 'package:message_buddy/widgets/button.dart';
import 'package:message_buddy/widgets/constants.dart';
import 'package:sizer/sizer.dart';
import '../helper/helper_functions.dart';
import '../screens/home_screen.dart';
import '../widgets/snackbar.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool obscureText = true;
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.green,
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Message Buddy',
                          style: heading,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'Log in to continue',
                        style: smallHeading,
                      ),
                      Image.asset('assets/logo.png'),
                      SizedBox(
                        height: 1.h,
                      ),
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Email',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black38,
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          return RegExp(
                            (r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                          ).hasMatch(value!)
                              ? null
                              : 'Please enter a valid e-mail';
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextFormField(
                        obscureText: obscureText,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black38,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  obscureText = !obscureText;
                                },
                              );
                            },
                            icon: obscureText
                                ? const Icon(
                                    Icons.visibility_rounded,
                                    color: Colors.black38,
                                  )
                                : const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.black38,
                                  ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Password should be at least 6 charaters';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Button(
                        action: 'Log in',
                        buttonColor: Colors.blue,
                        onPressed: () {
                          login();
                        },
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: normalText,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Register here',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).popAndPushNamed(
                                      RegisterScreen.routeName);
                                },
                              style: normalText.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w900,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

// this function is to validate the data entered in the forms.
  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .signInUserWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving our value to the shared prefences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullname']);

          if (!mounted) return;
          Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

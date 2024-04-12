// no email
// only google, kakao, naver
import 'package:dondonkkaseu/components/rounded_asset_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:dondonkkaseu/screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                    child: Image.asset('assets/images/dondon_512.png',
                        width: 100, height: 100, fit: BoxFit.cover),
                  ),
                  const Text(
                    ' dondon ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                ],
              ),
              const SizedBox(
                height: 48.0,
              ),
              AssetRoundedButton(
                title: 'Login',
                colour: Colors.lightBlueAccent,
                icon: 'assets/images/google.png',
                onPressed: () async {
                  var googleUser = await signInWithGoogle();

                  if (googleUser != null) {
                    // db filter

                    var emailCheck = await FirebaseDatabase.instance
                        .ref()
                        .child('users')
                        .child(FirebaseAuth.instance.currentUser!.uid)
                        .get();

                    if (emailCheck.exists == false) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('users')
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .set({"email": googleUser.user!.email});
                    }

                    Navigator.pushNamedAndRemoveUntil(
                        context, MapScreen.id, (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<UserCredential?> signInWithGoogle() async {
  // Trigger the authentication flow

  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  if (googleUser != null) {
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } else {
    return null;
  }

  // Create a new credential
}

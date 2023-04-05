import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants/app_constants.dart';
import '../../../service/navigation_service.dart';
import '../../home/presentation/home_screen.dart';
import '../data/all_social_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AllTypeLogin allTypeLogin = AllTypeLogin();
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterSocialButton(
            buttonType: ButtonType.google,
            onTap: () async {
              User? user = await allTypeLogin.onPressedGoogleLogin();
              if (user != null) {
                await storage.write(AppConstants.kKeyIsLoggedIn, true);
                Navigator.of(NavigationService.context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              }
            },
          ),
          FlutterSocialButton(
            buttonType: ButtonType.facebook,
            onTap: () async {
              User? user = await allTypeLogin.signInWithFacebook();

              if (user != null) {
                await storage.write(AppConstants.kKeyIsLoggedIn, true);
                Navigator.of(NavigationService.context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              }
            },
          ),
          FlutterSocialButton(
            buttonType: ButtonType.linkedin,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Firebase Sign-in Methods dosn\'t support LinkedIn'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../constants/app_constants.dart';
import '../../../service/navigation_service.dart';
import '../../../widgets/custom_snackbar.dart';

class AllTypeLogin {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  final _storage = GetStorage();

  //google login
  Future<User?> onPressedGoogleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser.authentication;
      String? accessToken = googleSignInAuthentication.accessToken;
      String? idToken = googleSignInAuthentication.idToken;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: accessToken, idToken: idToken);
      log('access token : ${accessToken!}');
      _storage.writeIfNull(AppConstants.kKeyGoogleAuthToken, accessToken);

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        _storage.write(
            AppConstants.kKeyPhotoUrl,
            user?.photoURL ??
                "https://pinnacle.works/wp-content/uploads/2022/06/dummy-image.jpg");
        _storage.write(AppConstants.kKeyUserName, user?.displayName ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          CustomSnackbar(
              context: NavigationService.context,
              content:
                  'The account already exists with a different credential.',
              backgroundColor: Colors.red);
        } else if (e.code == 'invalid-credential') {
          CustomSnackbar(
              context: NavigationService.context,
              content: 'Error occurred while accessing credentials. Try again.',
              backgroundColor: Colors.red);
        }
      } catch (e) {
        CustomSnackbar(
            context: NavigationService.context,
            content: 'Error occurred using Google Sign-In. Try again.',
            backgroundColor: Colors.red);
      }
    }
    return user;
  }

//facebook login
  Future<User?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      // Once signed in, return the UserCredential
      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        _storage.write(
            AppConstants.kKeyPhotoUrl,
            user?.photoURL ??
                "https://pinnacle.works/wp-content/uploads/2022/06/dummy-image.jpg");
        _storage.write(AppConstants.kKeyUserName, user?.displayName ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          CustomSnackbar(
              context: NavigationService.context,
              content:
                  'The account already exists with a different credential.',
              backgroundColor: Colors.red);
        } else if (e.code == 'invalid-credential') {
          CustomSnackbar(
              context: NavigationService.context,
              content: 'Error occurred while accessing credentials. Try again.',
              backgroundColor: Colors.red);
        }
      } catch (e) {
        CustomSnackbar(
            context: NavigationService.context,
            content: 'Error occurred using Google Sign-In. Try again.',
            backgroundColor: Colors.red);
      }
    }
    return user;
  }
}

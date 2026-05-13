import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetEmailController {
Future<String> sendResetEmail(String email) async {
  try {
    final auth = FirebaseAuth.instance;

    // Prepare ActionCodeSettings — adapt values below
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://psychologyapp-login-33bd3.web.app', // continue url
      iOSBundleId: 'com.aakaa.mentalhealth',         // iOS bundle id
      androidPackageName: 'com.aakaa.mentalhealth',  // Android package name
      androidInstallApp: false,
    );

    await auth.sendPasswordResetEmail(email: email.trim(), actionCodeSettings: actionCodeSettings);
    return 'OK';
  } on FirebaseAuthException catch (e) {
    return e.message ?? e.code;
  } catch (e) {
    return e.toString();
  }
}
}

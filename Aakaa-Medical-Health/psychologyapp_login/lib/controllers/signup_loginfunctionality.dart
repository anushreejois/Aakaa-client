import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupLoginFunctionality{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(String email, String confirmpassword) async {
    String result = "Something went wrong";

    try{
      // Creating new user with email and password
      final usercred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: confirmpassword,
    );
    final userdoc = {
      // Store the user details in Firestore
      'Identifier': email,
      'uid': usercred.user?.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('Users').doc(usercred.user?.uid).set(userdoc);
    result = "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          result = 'That email is already in use.';
          break;
        case 'invalid-email':
          result = 'The email address is badly formatted.';
          break;
        case 'weak-password':
          result = 'The password is too weak.';
          break;
        case 'operation-not-allowed':
          result = 'Email/password accounts are not enabled.';
          break;
        default:
          result = e.message ?? e.code;
      }
    }
    catch(e){
      try {
        final currentUser = _auth.currentUser;
        if (currentUser != null) await currentUser.delete();
      } catch (_) {}
      result = e.toString();
    }
    return result;
  }

  Future<String> loginUser(String email, String password) async {
    String result ="Something went wrong";

    try{
      // Logging in user with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      result = "Login successful";

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          result = 'No user found for that email.';
          break;
        case 'wrong-password':
          result = 'Wrong password provided.';
          break;
        case 'invalid-email':
          result = 'The email address is badly formatted.';
          break;
        default:
          result = e.message ?? e.code;
      }
    } catch(e){
      result = e.toString();
    }
    return result;
  }
}
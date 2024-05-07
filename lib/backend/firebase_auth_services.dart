import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signup logic
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("An error occurred during sign up: $e");
      return null;
    }
  }

  // Sign in logic
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        // Retrieve the user type
        String? userType = await getUserType(user.uid);

        // Return the user along with the userType
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("An error occurred during sign in: $e");
      return null;
    }
  }

  Future<String?> getUserType(String userId) async {
    try {
      // Retrieve the user document from the 'users' collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if userSnapshot contains data
      if (userSnapshot.exists) {
        // Retrieve the userType field from the user document
        dynamic data = userSnapshot.data();
        String? userType = data != null ? data['userType'] : null;
        if (userType != null) {
          return userType;
        }
      }

      // If user document is not found in the 'users' collection,
      // try retrieving it from the 'schools' collection
      DocumentSnapshot schoolSnapshot = await FirebaseFirestore.instance
          .collection('schools')
          .doc(userId)
          .get();

      // Check if schoolSnapshot contains data
      if (schoolSnapshot.exists) {
        // Retrieve the userType field from the school document
        dynamic data = schoolSnapshot.data();
        String? userType = data != null ? data['userType'] : null;
        if (userType != null) {
          return userType;
        }
      }

      // If user document is not found in both collections
      print("User document not found in 'users' and 'schools' collections");
      return null;
    } catch (e) {
      print("Error retrieving user type: $e");
      return null;
    }
  }
}

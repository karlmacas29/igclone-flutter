import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:igclone/models/user_model.dart';
import 'package:igclone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        if (username.isNotEmpty && bio.isNotEmpty) {
          if (file != null) {
            //register
            UserCredential cred = await _auth.createUserWithEmailAndPassword(
                email: email, password: password);

            String photoURL = await StorageMethods()
                .uploadImageToStorage('profilePics', file, false);
            //add user
            UserModel user = UserModel(
              uid: cred.user!.uid,
              username: username,
              email: email,
              bio: bio,
              followers: [],
              following: [],
              photoURL: photoURL,
            );

            await _firestore
                .collection('users')
                .doc(cred.user!.uid)
                .set(user.toJson());

            res = "success";
          } else {
            res = "Profile Picture are Required!";
          }
        } else {
          res = "Username and Bio are Required!";
        }
      } else {
        res = "Please Fill All The Field";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = "The Email is Badly Formatted";
      } else if (e.code == 'weak-password') {
        res = "Password Should Be Alteast 6 Characters";
      } else if (e.code == 'email-already-in-use') {
        res = "This Email is Already Taken";
      } else if (e.code == 'operation-not-allowed') {
        res = "This Account Was Disabled Contact To The Admin";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please Fill All the Field";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = "The Email is Badly Formatted";
      } else if (e.code == 'weak-password') {
        res = "Password Should Be Alteast 6 Characters";
      } else if (e.code == 'user-not-found') {
        res = "This Account Does Not Exist!";
      } else if (e.code == 'wrong-password') {
        res = "Wrong Password Try Again!";
      } else if (e.code == 'user-disabled') {
        res = "This Account Was Disabled Contact to the Admin";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOutAccount() async {
    try {
      await _auth.signOut();
      await _auth.currentUser!.reload();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> updateUser(
    String uid,
    String username,
    String bio,
  ) async {
    String res = "Some Error Occured";
    try {
      Map<String, dynamic> data = {
        'username': username,
        'bio': bio,
      };

      await _firestore.collection('users').doc(uid).update(data);

      // Get the post document by uid using where clause
      QuerySnapshot postQuery = await _firestore
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      // Check if the query has any documents
      if (postQuery.docs.isNotEmpty) {
        // Get the first document from the query
        for (DocumentSnapshot postDoc in postQuery.docs) {
          await postDoc.reference.update({'username': username});
        }

        // Update the profImage field with the user's photoURL
      }

      res = "success";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}

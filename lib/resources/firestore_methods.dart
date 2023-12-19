import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igclone/models/post.dart';
import 'package:igclone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload Post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some Error Occured";
    try {
      String photoURL =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postID = const Uuid().v1();

      UserPost post = UserPost(
        description: description,
        uid: uid,
        username: username,
        postID: postID,
        datePublished: DateTime.now(),
        postURL: photoURL,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postID).set(
            post.toJson(),
          );

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //comments
  Future<void> postComments(String postID, String text, String uid,
      String username, String profImage) async {
    try {
      if (text.isNotEmpty) {
        String commentID = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .set({
          'profImage': profImage,
          'username': username,
          'text': text,
          'commentID': commentID,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is Empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followID) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followID)) {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followID])
        });
      } else {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followID])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> updatePost(
    String description,
    String uid,
  ) async {
    String res = "Some Error Occured";
    try {
      Map<String, dynamic> data = {
        "description": description,
        "datePublished": DateTime.now(),
      };
      await _firestore.collection('posts').doc(uid).update(data);

      res = "success";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<String> updatePicture(
      String uid, String oldUrl, Uint8List file) async {
    String res = "Some Error Occured";

    try {
      String photoURl = await StorageMethods()
          .updateImageToStorage('profilePics', oldUrl, file, false);
      Map<String, dynamic> data = {
        'photoURL': photoURl,
      };
      await _firestore.collection('users').doc(uid).update(data);

      // Get the post document by uid using where clause
      QuerySnapshot postQuery = await _firestore
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      // Check if the query has any documents
      if (postQuery.docs.isNotEmpty) {
        for (DocumentSnapshot postDoc in postQuery.docs) {
          // Update the profImage field with the user's photoURL
          await postDoc.reference.update({'profImage': photoURl});
        }
      }

      res = "success";
    } on FirebaseException catch (e) {
      print(e.toString());
      res = "null";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}

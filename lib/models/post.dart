import 'package:cloud_firestore/cloud_firestore.dart';

class UserPost {
  final String uid;
  final String description;
  final String username;
  final String postID;
  final datePublished;
  final String postURL;
  final String profImage;
  final likes;

  const UserPost({
    required this.uid,
    required this.description,
    required this.username,
    required this.postID,
    required this.datePublished,
    required this.postURL,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'description': description,
        'username': username,
        'postID': postID,
        'datePublished': datePublished,
        'postURL': postURL,
        'profImage': profImage,
        'likes': likes,
      };

  static UserPost fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserPost(
      uid: snapshot['uid'],
      description: snapshot['description'],
      username: snapshot['username'],
      postID: snapshot['postID'],
      datePublished: snapshot['datePublished'],
      postURL: snapshot['postURL'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}

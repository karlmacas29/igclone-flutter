import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/edit_user.dart';
import 'package:igclone/Screen/loading_animation.dart';
import 'package:igclone/Screen/login_screen.dart';
import 'package:igclone/Screen/view_image_bypost.dart';
import 'package:igclone/resources/auth_methods.dart';
import 'package:igclone/resources/firestore_methods.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/utils.dart';
import 'package:igclone/widgets/follow_button.dart';
import 'package:igclone/widgets/skeletal_load_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    getData();
    _stream = FirebaseFirestore.instance.collection('users').snapshots();
    _stream = FirebaseFirestore.instance.collection('posts').snapshots();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //getpostlen

      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postsnap.docs.length;
      userData = usersnap.data()!;
      followers = usersnap.data()!['followers'].length;
      following = usersnap.data()!['following'].length;

      isFollowing = usersnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _stream = FirebaseFirestore.instance.collection('users').snapshots();
      _stream = FirebaseFirestore.instance.collection('posts').snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const ProfLoad()
        : RefreshIndicator(
            onRefresh: _refreshData,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  FirebaseAuth.instance.currentUser!.uid == widget.uid
                      ? IconButton(
                          onPressed: () async {
                            await AuthMethods().signOutAccount();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                            showSnackBar("Sign Out", context);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.rightFromBracket,
                            color: Colors.black,
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            FontAwesomeIcons.user,
                            color: Colors.black,
                          ),
                        )
                ],
                elevation: 0,
                backgroundColor: Colors.white,
                title: Row(children: [
                  FirebaseAuth.instance.currentUser!.uid == widget.uid
                      ? const Text('')
                      : IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.black,
                          ),
                        ),
                  Text(
                    userData['username'],
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ]),
                centerTitle: false,
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userData['photoURL']),
                              backgroundColor: Colors.grey,
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(postLen, 'Posts'),
                                      buildStatColumn(followers, 'Followers'),
                                      buildStatColumn(following, 'Following'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? FollowButton(
                                              text: 'Edit Profile',
                                              backgroundColor: primaryColor,
                                              textColor: mobileBackground,
                                              borderColor: Colors.grey,
                                              function: () async {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateUser(
                                                      bio: userData['bio'],
                                                      uid: userData['uid'],
                                                      oldUrl:
                                                          userData['photoURL'],
                                                      username:
                                                          userData['username'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  text: 'Unfollow',
                                                  backgroundColor: primaryColor,
                                                  textColor: mobileBackground,
                                                  borderColor: Colors.grey,
                                                  function: () async {
                                                    await FirestoreMethod()
                                                        .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userData['uid']);
                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  text: 'Follow',
                                                  backgroundColor: blueColor,
                                                  textColor: primaryColor,
                                                  borderColor: blueColor,
                                                  function: () async {
                                                    await FirestoreMethod()
                                                        .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userData['uid']);

                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            userData['username'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            userData['bio'],
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: LoadingScreenAnimation(),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            return Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ViewPostImage(
                                        pid: snapshot.data!.docs[index].data(),
                                      ),
                                    ),
                                  );
                                },
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      (snap['postURL']),
                                    )),
                              ),
                            );
                          },
                        );
                      })
                ],
              ),
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}

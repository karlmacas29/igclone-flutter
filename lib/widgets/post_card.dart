import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/comment_screen.dart';
import 'package:igclone/Screen/profile_screen.dart';
import 'package:igclone/Screen/update_post_card.dart';
import 'package:igclone/Screen/view_image.dart';
import 'package:igclone/models/user_model.dart';
import 'package:igclone/providers/user_provider.dart';
import 'package:igclone/resources/firestore_methods.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/utils/utils.dart';
import 'package:igclone/widgets/like_animation.dart';
import 'package:igclone/widgets/skeletal_load_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postID'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } on Exception catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return widget.snap == null
        ? const SkeletalCard()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(
                  color: MediaQuery.of(context).size.width > webScreenSize
                      ? Colors.grey
                      : Colors.white),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                          .copyWith(right: 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: widget.snap['uid'],
                            ),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(widget.snap['profImage']),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      uid: widget.snap['uid'],
                                    ),
                                  ),
                                ),
                                child: Text(
                                  widget.snap['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    DateFormat.yMMMd().format(
                                        widget.snap['datePublished'].toDate()),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    DateFormat.jm().format(
                                        widget.snap['datePublished'].toDate()),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                insetAnimationCurve: Curves.bounceInOut,
                                child: widget.snap['uid'] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? ListView(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 12),
                                        children: [
                                            SimpleDialogOption(
                                              onPressed: () async {
                                                await FirestoreMethod()
                                                    .deletePost(
                                                        widget.snap['postID']);
                                                Navigator.of(context).pop();
                                                showSnackBar(
                                                    'Post Deleted', context);
                                              },
                                              child: const Row(children: [
                                                Icon(CupertinoIcons.trash),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Delete'),
                                              ]),
                                            ),
                                            SimpleDialogOption(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdatePost(
                                                      file: widget
                                                          .snap['postURL'],
                                                      description: widget
                                                          .snap['description'],
                                                      pid:
                                                          widget.snap['postID'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Row(children: [
                                                Icon(CupertinoIcons.pen),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Edit'),
                                              ]),
                                            ),
                                            SimpleDialogOption(
                                              onPressed:
                                                  Navigator.of(context).pop,
                                              child: const Row(children: [
                                                Icon(CupertinoIcons.xmark),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Cancel'),
                                              ]),
                                            )
                                          ])
                                    : ListView(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shrinkWrap: true,
                                        children: [
                                          SimpleDialogOption(
                                            onPressed:
                                                Navigator.of(context).pop,
                                            child: const Row(children: [
                                              Icon(CupertinoIcons.xmark),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Cancel'),
                                            ]),
                                          )
                                        ],
                                      ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.more_vert)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageView(
                          file: widget.snap['postURL'],
                        ),
                      ),
                    );
                  },
                  onDoubleTap: () async {
                    await FirestoreMethod().likePost(
                        widget.snap['postID'], user.uid, widget.snap['likes']);
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            child: Image.network(widget.snap['postURL'],
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          isAnimating: isLikeAnimating,
                          duration: const Duration(milliseconds: 400),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          child: const Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.pink,
                            size: 120,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: [
                      LikeAnimation(
                        isAnimating: widget.snap['likes'].contains(user.uid),
                        smallLike: true,
                        child: IconButton(
                          onPressed: () async {
                            await FirestoreMethod().likePost(
                                widget.snap['postID'],
                                user.uid,
                                widget.snap['likes']);
                          },
                          icon: widget.snap['likes'].contains(user.uid)
                              ? const Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.pink,
                                )
                              : const Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                      Text('${widget.snap['likes'].length}'),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              snap: widget.snap,
                            ),
                          ),
                        ),
                        icon: const Icon(FontAwesomeIcons.comment),
                      ),
                      Text('$commentLen'),
                      Expanded(
                          child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(FontAwesomeIcons.bookmark),
                          onPressed: () {},
                        ),
                      ))
                    ],
                  ),
                ),
                //
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 8),
                          child: RichText(
                              text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                TextSpan(
                                    text: '${widget.snap['username']} ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: widget.snap['description'],
                                ),
                              ])),
                        ),
                      ]),
                )
              ],
            ),
          );
  }
}

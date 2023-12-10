import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/loading_animation.dart';
import 'package:igclone/models/user_model.dart';
import 'package:igclone/providers/user_provider.dart';
import 'package:igclone/resources/firestore_methods.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commController.dispose();
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    // Assign the stream variable to the firebase collection snapshots stream
    _stream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postID'])
        .collection('comments')
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  // Define a function that returns a Future<void> and updates the stream variable
  Future<void> _refreshData() async {
    setState(() {
      _stream = FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postID'])
          .collection('comments')
          .orderBy('datePublished', descending: true)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromRGBO(237, 240, 246, 1),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black)),
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postID'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingScreenAnimation(),
            );
          }
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap: (snapshot.data! as dynamic).docs[index].data(),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 8),
              child: TextField(
                controller: _commController,
                decoration: InputDecoration(
                    hintText: 'Comment as ${user.username}',
                    border: InputBorder.none),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                await FirestoreMethod().postComments(
                  widget.snap['postID'],
                  _commController.text,
                  user.uid,
                  user.username,
                  user.photoURL,
                );
                setState(() {
                  _commController.text = "";
                });
              },
              icon: const Icon(FontAwesomeIcons.solidPaperPlane,
                  color: Colors.black))
        ]),
      )),
    );
  }
}

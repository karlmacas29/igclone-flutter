import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/loading_animation.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Declare a stream variable
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    // Assign the stream variable to the firebase collection snapshots stream
    _stream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  // Define a function that returns a Future<void> and updates the stream variable
  Future<void> _refreshData() async {
    setState(() {
      _stream = FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 240, 246, 1),
      appBar: MediaQuery.of(context).size.width > webScreenSize
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: const Color.fromRGBO(237, 240, 246, 1),
              centerTitle: true,
              title: const Icon(
                FontAwesomeIcons.instagram,
                color: Colors.black,
                size: 30,
              ),
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingScreenAnimation(),
            );
          } else if (snapshot.data == null) {
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
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > webScreenSize
                      ? MediaQuery.of(context).size.width * 0.3
                      : 10,
                  vertical: MediaQuery.of(context).size.width > webScreenSize
                      ? 15
                      : 5,
                ),
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

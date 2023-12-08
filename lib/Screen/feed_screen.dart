import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/loading_animation.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 240, 246, 1),
      appBar: MediaQuery.of(context).size.width > webScreenSize
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: const Color.fromRGBO(237, 240, 246, 1),
              centerTitle: false,
              leading: const Icon(
                FontAwesomeIcons.instagram,
                color: Colors.black,
              ),
              actions: [
                IconButton(
                  icon:
                      const Icon(FontAwesomeIcons.message, color: Colors.black),
                  onPressed: () {},
                )
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingScreenAnimation(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: LoadingScreenAnimation(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width > webScreenSize
                              ? MediaQuery.of(context).size.width * 0.3
                              : 10,
                      vertical:
                          MediaQuery.of(context).size.width > webScreenSize
                              ? 15
                              : 5,
                    ),
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ));
        },
      ),
    );
  }
}

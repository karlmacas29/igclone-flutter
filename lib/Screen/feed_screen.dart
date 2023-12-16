import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:igclone/utils/dimension.dart';
import 'package:igclone/widgets/post_card.dart';
import 'package:igclone/widgets/skeletal_load_card.dart';

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
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.instagram,
                    color: Colors.black,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "InstaClone",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Billabong',
                      color: Colors.black,
                    ),
                  )
                ],
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
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > webScreenSize
                    ? MediaQuery.of(context).size.width * 0.3
                    : 10,
                vertical:
                    MediaQuery.of(context).size.width > webScreenSize ? 15 : 5,
              ),
              child: const SkeletalCard(),
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
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const SkeletalCard()
                    : snapshot.connectionState == ConnectionState.done
                        ? const SkeletalCard()
                        : PostCard(
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

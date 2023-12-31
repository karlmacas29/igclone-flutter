import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/loading_animation.dart';
import 'package:igclone/Screen/profile_screen.dart';
import 'package:igclone/Screen/view_image_bypost.dart';
import 'package:igclone/utils/colors.dart';

class SearcScreen extends StatefulWidget {
  const SearcScreen({super.key});

  @override
  State<SearcScreen> createState() => _SearcScreenState();
}

class _SearcScreenState extends State<SearcScreen> {
  final TextEditingController searchCon = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    searchCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(237, 240, 246, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: primaryColor,
          title: TextFormField(
            controller: searchCon,
            decoration: const InputDecoration(
                icon: Icon(FontAwesomeIcons.magnifyingGlass),
                hintText: 'Search a User'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUser = true;
              });
            },
          ),
        ),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: searchCon.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: LoadingScreenAnimation(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: LoadingScreenAnimation(),
                    );
                  }

                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid']),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoURL']),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: LoadingScreenAnimation(),
                    );
                  }

                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewPostImage(
                              pid: snapshot.data!.docs[index].data(),
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                          (snapshot.data! as dynamic).docs[index]['postURL']),
                    ),
                    staggeredTileBuilder: (index) => StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  );
                },
              ));
  }
}

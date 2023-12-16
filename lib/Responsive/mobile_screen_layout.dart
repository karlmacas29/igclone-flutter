import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:igclone/Screen/add_post_screen.dart';
import 'package:igclone/Screen/feed_screen.dart';
import 'package:igclone/Screen/notification_screen.dart';
import 'package:igclone/Screen/profile_screen.dart';
import 'package:igclone/Screen/search_screen.dart';

class MobileView extends StatefulWidget {
  const MobileView({super.key});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  int _page = 0;
  late PageController pageCon;

  @override
  void initState() {
    super.initState();
    pageCon = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageCon.dispose();
  }

  void navigationTapped(int page) {
    pageCon.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    //UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      extendBody: true,
      body: PageView(
        //disable scroll next page
        physics: const NeverScrollableScrollPhysics(),
        controller: pageCon,
        onPageChanged: onPageChanged,
        children: [
          const FeedScreen(),
          const SearcScreen(),
          const NotiScreen(),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(205, 72, 107, 1),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(
          CupertinoIcons.add_circled_solid,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashRadius: 45,
        leftCornerRadius: 10,
        rightCornerRadius: 10,
        notchSmoothness: NotchSmoothness.softEdge,
        splashColor: const Color.fromRGBO(205, 72, 107, 1),
        iconSize: 30,
        activeColor: const Color.fromRGBO(205, 72, 107, 1),
        height: 65,
        gapLocation: GapLocation.center,
        icons: const [
          CupertinoIcons.house_alt,
          CupertinoIcons.search,
          CupertinoIcons.heart,
          CupertinoIcons.person_crop_circle
        ],
        activeIndex: _page,
        onTap: navigationTapped,
      ),
    );
  }
}

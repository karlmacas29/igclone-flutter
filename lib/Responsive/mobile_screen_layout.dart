import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/add_post_screen.dart';
import 'package:igclone/Screen/feed_screen.dart';
import 'package:igclone/Screen/profile_screen.dart';
import 'package:igclone/Screen/search_screen.dart';

import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/widgets/gradient_icon.dart';

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
          const AddPostScreen(),
          const Center(child: Text("Working Progress...")),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: primaryColor,
          type: BottomNavigationBarType.fixed,
          iconSize: 25,
          items: [
            BottomNavigationBarItem(
                icon: _page == 0
                    ? const GradientIcon(
                        icon: FontAwesomeIcons.house,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(76, 104, 215, 1),
                            Color.fromRGBO(205, 72, 107, 1)
                          ],
                        ),
                        size: 24,
                      )
                    : const Icon(FontAwesomeIcons.house, color: Colors.black),
                label: '',
                tooltip: 'Home',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: _page == 1
                    ? const GradientIcon(
                        icon: FontAwesomeIcons.magnifyingGlass,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(76, 104, 215, 1),
                            Color.fromRGBO(205, 72, 107, 1)
                          ],
                        ),
                        size: 24,
                      )
                    : const Icon(FontAwesomeIcons.magnifyingGlass,
                        color: Colors.black),
                label: '',
                tooltip: 'Search',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: _page == 2
                    ? const GradientIcon(
                        icon: FontAwesomeIcons.circlePlus,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(76, 104, 215, 1),
                            Color.fromRGBO(205, 72, 107, 1)
                          ],
                        ),
                        size: 24,
                      )
                    : const Icon(FontAwesomeIcons.circlePlus,
                        color: Colors.black),
                label: '',
                tooltip: 'Add Post',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: _page == 3
                    ? const GradientIcon(
                        icon: FontAwesomeIcons.solidHeart,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(76, 104, 215, 1),
                            Color.fromRGBO(205, 72, 107, 1)
                          ],
                        ),
                        size: 24,
                      )
                    : const Icon(FontAwesomeIcons.solidHeart,
                        color: Colors.black),
                label: '',
                tooltip: 'Notification',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: _page == 4
                    ? const GradientIcon(
                        icon: FontAwesomeIcons.solidUser,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(76, 104, 215, 1),
                            Color.fromRGBO(205, 72, 107, 1)
                          ],
                        ),
                        size: 24,
                      )
                    : const Icon(FontAwesomeIcons.solidUser,
                        color: Colors.black),
                label: '',
                tooltip: 'Profile',
                backgroundColor: primaryColor),
          ],
          onTap: navigationTapped,
        ),
      ),
    );
  }
}

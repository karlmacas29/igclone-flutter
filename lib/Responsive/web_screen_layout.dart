import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/add_post_screen.dart';
import 'package:igclone/Screen/feed_screen.dart';
import 'package:igclone/Screen/notification_screen.dart';
import 'package:igclone/Screen/profile_screen.dart';
import 'package:igclone/Screen/search_screen.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/widgets/gradient_icon.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
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
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          leading: const Icon(
            FontAwesomeIcons.instagram,
            color: Colors.black,
          ),
          actions: [
            IconButton(
              tooltip: 'Home',
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
                      size: 22,
                    )
                  : const Icon(FontAwesomeIcons.house, color: Colors.black),
              onPressed: () => navigationTapped(0),
            ),
            IconButton(
              tooltip: 'Search',
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
                      size: 22,
                    )
                  : const Icon(FontAwesomeIcons.magnifyingGlass,
                      color: Colors.black),
              onPressed: () => navigationTapped(1),
            ),
            IconButton(
              tooltip: 'Add Post',
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
                      size: 22,
                    )
                  : const Icon(FontAwesomeIcons.circlePlus,
                      color: Colors.black),
              onPressed: () => navigationTapped(2),
            ),
            IconButton(
              tooltip: 'Notification',
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
                      size: 22,
                    )
                  : const Icon(FontAwesomeIcons.solidHeart,
                      color: Colors.black),
              onPressed: () => navigationTapped(3),
            ),
            IconButton(
              tooltip: 'Profile',
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
                      size: 22,
                    )
                  : const Icon(FontAwesomeIcons.solidUser, color: Colors.black),
              onPressed: () => navigationTapped(4),
            ),
          ],
        ),
        body: PageView(
          controller: pageCon,
          onPageChanged: onPageChanged,
          children: [
            const FeedScreen(),
            const SearcScreen(),
            const AddPostScreen(),
            const NotiScreen(),
            ProfileScreen(
              uid: FirebaseAuth.instance.currentUser!.uid,
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';

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
              icon: Icon(
                FontAwesomeIcons.house,
                color: _page == 0 ? blueColor : mobileBackground,
              ),
              onPressed: () => navigationTapped(0),
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: _page == 1 ? blueColor : mobileBackground,
              ),
              onPressed: () => navigationTapped(1),
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.circlePlus,
                color: _page == 2 ? blueColor : mobileBackground,
              ),
              onPressed: () => navigationTapped(2),
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.solidHeart,
                color: _page == 3 ? blueColor : mobileBackground,
              ),
              onPressed: () => navigationTapped(3),
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.solidUser,
                color: _page == 4 ? blueColor : mobileBackground,
              ),
              onPressed: () => navigationTapped(4),
            ),
          ],
        ),
        body: PageView(
          controller: pageCon,
          onPageChanged: onPageChanged,
          children: homeScreenItems,
        ));
  }
}

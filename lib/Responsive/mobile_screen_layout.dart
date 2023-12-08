import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';

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
      body: PageView(
        //disable scroll next page
        physics: const NeverScrollableScrollPhysics(),
        controller: pageCon,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.house,
                color: _page == 0 ? blueColor : mobileBackground,
              ),
              label: '',
              tooltip: 'Home',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: _page == 1 ? blueColor : mobileBackground,
              ),
              label: '',
              tooltip: 'Search',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.circlePlus,
                color: _page == 2 ? blueColor : mobileBackground,
              ),
              label: '',
              tooltip: 'Post',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.solidHeart,
                color: _page == 3 ? blueColor : mobileBackground,
              ),
              label: '',
              tooltip: 'Notification',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.solidUser,
                color: _page == 4 ? blueColor : mobileBackground,
              ),
              label: '',
              tooltip: 'profile',
              backgroundColor: primaryColor),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}

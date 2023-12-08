import 'package:flutter/material.dart';
import 'package:igclone/providers/user_provider.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:provider/provider.dart';

class ResponsiveMode extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveMode(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveMode> createState() => _ResponsiveModeState();
}

class _ResponsiveModeState extends State<ResponsiveMode> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        //webscreen
        return widget.webScreenLayout;
      } else {
        //mobilescreen
        return widget.mobileScreenLayout;
      }
    });
  }
}

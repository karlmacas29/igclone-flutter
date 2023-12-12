import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/widgets/post_card.dart';

class ViewPostImage extends StatefulWidget {
  const ViewPostImage({super.key, required this.pid});
  final pid;

  @override
  State<ViewPostImage> createState() => _ViewPostImageState();
}

class _ViewPostImageState extends State<ViewPostImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: PostCard(snap: widget.pid),
      ),
    );
  }
}

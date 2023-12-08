import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igclone/Screen/add_post_screen.dart';
import 'package:igclone/Screen/feed_screen.dart';
import 'package:igclone/Screen/profile_screen.dart';
import 'package:igclone/Screen/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearcScreen(),
  const AddPostScreen(),
  const Center(child: Text("Working Progress...")),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

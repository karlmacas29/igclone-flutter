import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/models/user_model.dart';
import 'package:igclone/providers/user_provider.dart';
import 'package:igclone/resources/firestore_methods.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionCon = TextEditingController();
  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethod().uploadPost(
          _descriptionCon.text, _file!, uid, username, profileImage);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // _selectImage(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: const Text("Create Post"),
  //           children: [
  //             SimpleDialogOption(
  //               padding: const EdgeInsets.all(20),
  //               child: const Text("Take A Photo"),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 Uint8List file = await pickImage(ImageSource.camera);
  //                 setState(() {
  //                   _file = file;
  //                 });
  //               },
  //             ),
  //             SimpleDialogOption(
  //               padding: const EdgeInsets.all(20),
  //               child: const Text("Choose From Gallery"),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 Uint8List file = await pickImage(ImageSource.gallery);
  //                 setState(() {
  //                   _file = file;
  //                 });
  //               },
  //             ),
  //             SimpleDialogOption(
  //               padding: const EdgeInsets.all(20),
  //               child: const Text("Cancel"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  @override
  void dispose() {
    super.dispose();
    _descriptionCon.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Scaffold(
            appBar: MediaQuery.of(context).size.width > webScreenSize
                ? null
                : AppBar(
                    elevation: 0,
                    backgroundColor: primaryColor,
                    leading: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: mobileBackground,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: const Text(
                      "Post",
                      style: TextStyle(color: mobileBackground),
                    ),
                    centerTitle: false,
                    automaticallyImplyLeading: true,
                  ),
            backgroundColor: const Color.fromRGBO(237, 240, 246, 1),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Uint8List file =
                        await pickImage(ImageSource.camera, context);
                    setState(() {
                      _file = file;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(205, 72, 107, 1),
                      fixedSize: const Size.fromHeight(50)),
                  child: const Text(
                    "Take A Photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Uint8List file =
                        await pickImage(ImageSource.gallery, context);
                    setState(() {
                      _file = file;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(205, 72, 107, 1),
                      fixedSize: const Size.fromHeight(50)),
                  child: const Text(
                    "Choose From Gallery",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
                // IconButton(
                //   icon: const Icon(FontAwesomeIcons.upload),
                //   onPressed: () => _selectImage(context),
                // ),
                ),
          )
        //when choosing photo
        : Scaffold(
            backgroundColor: const Color.fromRGBO(237, 240, 246, 1),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: mobileBackground,
                ),
                onPressed: clearImage,
              ),
              title: const Text(
                "Post To",
                style: TextStyle(color: mobileBackground),
              ),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.username, user.photoURL),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: blueColor, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(205, 72, 107, 1),
                      )
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionCon,
                        decoration: const InputDecoration(
                            hintText: 'Write a Caption...',
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}

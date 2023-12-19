import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Screen/loading_animation.dart';
import 'package:igclone/resources/auth_methods.dart';
import 'package:igclone/resources/firestore_methods.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/utils/utils.dart';
import 'package:igclone/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({
    super.key,
    required this.bio,
    required this.uid,
    required this.oldUrl,
    required this.username,
  });
  final String uid;
  final String username;
  final String oldUrl;
  final String bio;

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final TextEditingController _bioCont = TextEditingController();
  final TextEditingController _usernameCont = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;

  @override
  void initState() {
    _bioCont.text = widget.bio;
    _usernameCont.text = widget.username;
    super.initState();
  }

  void selectImage() async {
    setState(() {
      _isLoading = true;
    });
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });

    String res = await FirestoreMethod()
        .updatePicture(widget.uid, widget.oldUrl, _image!);

    if (res == "success") {
      showSnackBar("Update Profile Success", context);
    } else if (res == "null") {
      setState(() {
        _isLoading = false;
      });
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void upUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().updateUser(
      widget.uid,
      _usernameCont.text,
      _bioCont.text,
    );

    if (res == "success") {
      showSnackBar("Update Information Success", context);
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.instagram,
                  size: 80,
                ),
                const SizedBox(
                  width: 20,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(_image!),
                            radius: 40,
                          )
                        : CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(widget.oldUrl),
                          ),
                    Positioned(
                        left: 50,
                        top: 50,
                        child: IconButton(
                          color: primaryColor,
                          iconSize: 20,
                          onPressed: selectImage,
                          icon: const Icon(
                            FontAwesomeIcons.camera,
                            color: Colors.pink,
                          ),
                        ))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            //TextInput
            CustomTextInput(
                textEditingController: _usernameCont,
                hintText: 'Username',
                textInputType: TextInputType.text),
            const SizedBox(
              height: 20,
            ),

            CustomTextInput(
                textEditingController: _bioCont,
                hintText: 'Bio',
                textInputType: TextInputType.text),
            const SizedBox(
              height: 20,
            ),
            //Button Login
            InkWell(
              onTap: upUser,
              mouseCursor: MaterialStateMouseCursor.clickable,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)))),
                child: _isLoading
                    ? const Center(
                        child: ProgressAnimation(),
                      )
                    : const Text(
                        "Update",
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            Flexible(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Responsive/mobile_screen_layout.dart';
import 'package:igclone/Responsive/responsive_layout_screen.dart';
import 'package:igclone/Responsive/web_screen_layout.dart';
import 'package:igclone/Screen/loading_animation.dart';
import 'package:igclone/Screen/login_screen.dart';
import 'package:igclone/resources/auth_methods.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/utils/utils.dart';
import 'package:igclone/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();
  final TextEditingController _bioCont = TextEditingController();
  final TextEditingController _usernameCont = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailCont.dispose();
    _passwordCont.dispose();
    _bioCont.dispose();
    _usernameCont.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailCont.text,
        password: _passwordCont.text,
        username: _usernameCont.text,
        bio: _bioCont.text,
        file: _image!);

    if (res != "success") {
      showSnackBar(res, context);
    } else {
      showSnackBar(res, context);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveMode(
              webScreenLayout: WebView(), mobileScreenLayout: MobileView())));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignIn() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        : const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                              size: 30,
                            ),
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
                textEditingController: _emailCont,
                hintText: 'Email',
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            CustomTextInput(
              textEditingController: _passwordCont,
              hintText: 'Password',
              textInputType: TextInputType.visiblePassword,
              isPass: true,
            ),
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
              onTap: signUpUser,
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
                        "Create Account",
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already Have An Account? "),
                TextButton(
                    onPressed: navigateToSignIn,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                          color: blueColor, fontWeight: FontWeight.bold),
                    ))
              ],
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

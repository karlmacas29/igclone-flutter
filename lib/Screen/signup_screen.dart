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
    Uint8List im = await pickImage(ImageSource.gallery, context);
    setState(() {
      _image = im;
      _isLoading = false;
    });
  }

  void signUpUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailCont.text,
        password: _passwordCont.text,
        username: _usernameCont.text,
        bio: _bioCont.text,
        file: _image);

    setState(() {
      _isLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
    } else {
      showSnackBar("Account Created Successfully!", context);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveMode(
              webScreenLayout: WebView(), mobileScreenLayout: MobileView())));
    }
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
                  size: 100,
                ),
                const SizedBox(
                  width: 20,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: Colors.pink,
                            radius: 50,
                          )
                        : const CircleAvatar(
                            backgroundImage: AssetImage("assets/profile.png"),
                            backgroundColor: Colors.pink,
                            radius: 50,
                          ),
                    Positioned(
                        left: 55,
                        top: 55,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.pink,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: IconButton(
                            tooltip: 'Upload A Picture',
                            color: primaryColor,
                            iconSize: 20,
                            onPressed: selectImage,
                            icon: const Icon(
                              FontAwesomeIcons.camera,
                              color: Colors.white,
                            ),
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/Responsive/mobile_screen_layout.dart';
import 'package:igclone/Responsive/responsive_layout_screen.dart';
import 'package:igclone/Responsive/web_screen_layout.dart';
import 'package:igclone/Screen/signup_screen.dart';
import 'package:igclone/resources/auth_methods.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:igclone/utils/utils.dart';
import 'package:igclone/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailCont.dispose();
    _passwordCont.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods()
        .loginUser(email: _emailCont.text, password: _passwordCont.text);

    if (res == "success") {
      showSnackBar(res, context);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveMode(
              webScreenLayout: WebView(), mobileScreenLayout: MobileView())));
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
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
            const Icon(
              FontAwesomeIcons.instagram,
              size: 80,
            ),
            const SizedBox(
              height: 40,
            ),
            //TextInput
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
              height: 30,
            ),
            //Button Login
            InkWell(
              focusColor: primaryColor,
              onTap: loginUser,
              mouseCursor: MaterialStateMouseCursor.clickable,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)))),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text(
                        "Sign In",
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
                const Text("Don't Have An Account? "),
                TextButton(
                    onPressed: navigateToSignUp,
                    child: const Text(
                      'Sign Up',
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

import 'package:elexir/screens/homePagePharma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constants/fonts.dart';
import '../services/authServices/authServices.dart';
import '../services/firestoreServices/firestore_service.dart';
import '../widgets/button.dart';
import '../widgets/corner_arc.dart';
import '../widgets/text_field.dart';
import 'homePage.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  static const String routeName = "signin";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  void initState() {
    super.initState();
    passNotVisible = true;
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  late bool passNotVisible;

  void login(BuildContext context) async {
    final authService = AuthService();
    final firestoreService = FirestoreService();

    try {
      UserCredential userCredential = await authService.signInWithEmailAndPass(
        _emailController.text, _passController.text,
      );
      String userId = userCredential.user!.uid;

      bool isPharmacy = await firestoreService.isPharmacy(userId);

      if (isPharmacy) {
        // Navigate to Pharmacy Home Page
       Get.off(HomePagePharmacy());
      } else {
        // Navigate to User Home Page
        Get.off(HomePage());
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error Logging in "),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    arc(),
                  ],
                ),
                Positioned(
                  top: 110,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Log in",
                            style: MyFonts.heading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Field(
                    passVisible: false,
                    isPass: false,
                    name: "Email",
                    controller: _emailController,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  Field(
                    passVisible: passNotVisible,
                    isPass: true,
                    name: "Password",
                    controller: _passController,
                    onPressed: () => setState(() {
                      passNotVisible = !passNotVisible;
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text("Forgot Password?", style: MyFonts.smallLink),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.21,
                  ),
                  MyButton(
                    text: "Log in",
                    onPressed: () => login(context),
                    isOutline: false,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an Account? ",
                  style: MyFonts.smallFontBlue,
                ),
                TextButton(
                  child: Text("Create Account", style: MyFonts.smallLink),
                  onPressed: () {
                    Navigator.pushNamed(context, SignUp.routeName);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

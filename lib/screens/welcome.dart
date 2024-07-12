import 'package:elexir/screens/sign_up_pharmacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/color.dart';
import '../constants/fonts.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import '../widgets/button.dart';



class Welcome extends StatelessWidget {
  const Welcome({super.key});

  static const String routeName = "welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.4,
                decoration: const BoxDecoration(
                  color: MyColors.lPrimary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(190, 70),
                    bottomRight: Radius.elliptical(190, 70),
                  ),
                ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/elixir-logo.png',
                      height: MediaQuery.of(context).size.height * 0.21,
                      width: MediaQuery.of(context).size.width * 0.43,
                      fit: BoxFit.contain, // or BoxFit.cover, BoxFit.fill, etc. based on your requirement
                    ),
                  ),
                ),
             Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to ',
                        style: MyFonts.heading,
                      ),
                      Text('Elixir',
                      style: MyFonts.headingOrange,)
                    ],
                  ),
                  Text(
                    'Your pocket pharmacy',
                    style: MyFonts.smallFontBlue,
                  ),
                ],
              ),
            ),
            MyButton(text: "Create Account", onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp(),));}, isOutline: false),
            MyButton(
                text: "Log in",
                onPressed: () {
                  Navigator.pushNamed(context, SignIn.routeName);
                },
                isOutline: true),
            TextButton(onPressed: (){Navigator.pushNamed(context, SignUpPharmacy.routeName);}, child: Text("I am a pharmacy owner", style: MyFonts.smallLink,))
          ],
        ),
      ),
    );
  }
}

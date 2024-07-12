import 'package:flutter/material.dart';
import 'package:elexir/services/display_image_users.dart';
import '../constants/color.dart';
import '../constants/fonts.dart';
import '../services/SharedPref.dart';
import '../services/authServices/authServices.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  static const String routeName = "more";

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  late Map<String, String?> userData = {};

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    Map<String, String?> loadedUserData = await SharedPref().getUserDataFromSharedPreferences();
    setState(() {
      userData = loadedUserData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    userData['name']!,
                    style: MyFonts.heading,
                  ),
          Container(
              width: 150,
              decoration: BoxDecoration(
                  color: MyColors.lPrimary,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  child: DisplayImageUser(
                    userId: AuthService().getCurrentUser()!.uid,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              )),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text("Email: ", style: MyFonts.outlineButton),
                Text(userData['email'] ?? 'No email found', style: MyFonts.normalText),
              ],
            ),
            Row(
              children: [
                Text("Phone number: ", style: MyFonts.outlineButton),
                Text(userData['phone'] ?? 'No phone number found', style: MyFonts.normalText),
              ],
            ),
            // Additional fields can be added here as needed
          ],
        ),
      ),
    );
  }
}

import 'package:elexir/screens/homePagePharma.dart';

import 'package:elexir/screens/sign_up_pharmacy.dart';
import 'package:elexir/screens/cart.dart';
import 'package:elexir/services/authServices/AuthGate.dart';
import 'package:elexir/services/authServices/authServices.dart';
import 'package:elexir/services/firestoreServices/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/welcome.dart';
import '../screens/morePharmacy.dart';

import 'controllers/MedicineController.dart';
import 'firebase_options.dart';
import 'screens/sign_up.dart';
import 'screens/sign_in.dart';
import 'screens/homePage.dart';

final getIt = GetIt.instance;
SharedPreferences? sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthService()); // Initialize AuthService
  Get.put(FirestoreService()); // Initialize AuthService
  Get.put(MedicineController()); // Initialize MedicineController
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        theme: ThemeData(fontFamily: 'OpenSans'),
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
        routes: {
          SignUpPharmacy.routeName: (context) => SignUpPharmacy(),
          Welcome.routeName: (context) => const Welcome(),
          SignIn.routeName: (context) => const SignIn(),
          SignUp.routeName: (context) => SignUp(),
          HomePage.routeName: (context) => const HomePage(),
          HomePagePharmacy.routeName: (context) =>  HomePagePharmacy(),
          MorePharmacy.routeName: (context) => const MorePharmacy()
        },
      ),
    );
  }
}

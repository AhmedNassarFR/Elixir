import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elexir/services/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/color.dart';
import '../screens/homePage.dart';
import '../constants/fonts.dart';
import '../services/authServices/authServices.dart';
import '../widgets/button.dart';
import '../widgets/corner_arc.dart';
import '../widgets/text_field.dart';
import 'sign_in.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  static const String routeName = "signup";

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late SharedPref sharedPref;

  final ImagePicker _picker = ImagePicker();
  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Firebase Storage instance

  @override
  void initState() {
    super.initState();
    sharedPref = SharedPref();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference storageRef = _storage.ref().child('users_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(image);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> signup(BuildContext context) async {
    final _auth = AuthService();

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passController.text.isEmpty ||
        _confirmPassController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          icon: Icon(Icons.error),
          iconColor: Colors.black,
          title: Text("Please fill in all fields", style: TextStyle(color: Colors.black)),
        ),
      );
      return;
    }

    if (_passController.text != _confirmPassController.text) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          icon: Icon(Icons.error),
          iconColor: Colors.white,
          title: Text("Passwords do not match", style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    try {
      await _auth.signOut(); // Sign out current user if any
      UserCredential userCredential = await _auth.signUpWithEmailAndPass(_emailController.text, _passController.text);

      // Upload image if selected
      String? imageURL;
      if (_image != null) {
        imageURL = await uploadImage(_image!);
      }

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'imagePath': imageURL ?? '', // Default empty string if imageURL is null
      });

      // Save user data to SharedPreferences
      await sharedPref.saveUserDataToSharedPreferences(
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        imageURL ?? '', // Default empty string if imageURL is null
      );

      // Navigate to home page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.error),
          iconColor: Colors.white,
          title: Text('Error: $e', style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }


  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool passNotVisible = true;
  bool confirmPassNotVisible = true;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

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
                            "Register",
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
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      backgroundColor: MyColors.lPrimary,
                      radius: 75,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.camera_alt, color: MyColors.lBackground, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Field(
                    isPass: false,
                    name: "Name",
                    controller: _nameController,
                    onPressed: () {},
                    passVisible: false,
                  ),
                  const SizedBox(height: 20),
                  Field(
                    isPass: false,
                    name: "Email",
                    controller: _emailController,
                    onPressed: () {},
                    passVisible: false,
                  ),
                  const SizedBox(height: 20),
                  Field(
                    isPass: false,
                    name: "Phone Number",
                    controller: _phoneController,
                    onPressed: () {},
                    passVisible: false,
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
                  const SizedBox(height: 20),
                  Field(
                    passVisible: confirmPassNotVisible,
                    isPass: true,
                    name: "Confirm Password",
                    controller: _confirmPassController,
                    onPressed: () => setState(() {
                      confirmPassNotVisible = !confirmPassNotVisible;
                    }),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Create Account",
                    onPressed: () => signup(context),
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
                  "Already have an Account? ",
                  style: MyFonts.smallFontBlue,
                ),
                TextButton(
                  child: Text("Log in", style: MyFonts.smallLink),
                  onPressed: () {
                    Navigator.pushNamed(context, SignIn.routeName);
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
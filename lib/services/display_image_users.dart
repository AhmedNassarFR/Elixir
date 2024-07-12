import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayImageUser extends StatefulWidget {
  final String userId;

  DisplayImageUser({required this.userId});

  @override
  _DisplayImageUserState createState() => _DisplayImageUserState();
}

class _DisplayImageUserState extends State<DisplayImageUser> {
  late Future<String?> imageUrlFuture;

  @override
  void initState() {
    super.initState();
    imageUrlFuture = getImageUrl();
  }

  Future<String?> getImageUrl() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (doc.exists && doc.data() != null) {
        return (doc.data() as Map<String, dynamic>)['imagePath'];
      }
    } catch (e) {
      print('Error fetching user image URL: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return Icon(Icons.account_circle, size: 85);  // Placeholder icon
        } else {
          return Image.network(snapshot.data!, fit: BoxFit.cover);
        }
      },
    );
  }
}

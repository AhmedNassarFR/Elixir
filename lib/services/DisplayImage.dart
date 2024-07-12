import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatefulWidget {
  final String pharmacyId;

  DisplayImage({required this.pharmacyId});

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  late Future<String?> imageUrlFuture;

  @override
  void initState() {
    super.initState();
    imageUrlFuture = getImageUrl();
  }

  Future<String?> getImageUrl() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('pharmacies').doc(widget.pharmacyId).get();
      if (doc.exists && doc.data() != null) {
        return (doc.data() as Map<String, dynamic>)['imagePath'];
      }
    } catch (e) {
      print('Error fetching image URL: $e');
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
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('No image found.');
        } else {
          return Image.network(snapshot.data!);
        }
      },
    );
  }
}

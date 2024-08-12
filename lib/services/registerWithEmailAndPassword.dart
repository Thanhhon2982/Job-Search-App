// ignore_for_file: empty_catches, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:my_flutter_app/Profile%20Components/Logine.dart';

Future<void> registerWithEmailAndPassword(String email, String name,
    String username, String address, String phoneNumber) async {
  try {
    User? userid = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('userdata')
        .doc(userid!.uid)
        .set({
      'uid': userid.uid,
      'email': email,
      'name': name,
      'username': username,
      'address': address,
      'phoneNumber': phoneNumber,
    });
    await FirebaseFirestore.instance.collection('users').doc(userid.uid).set({
      'uid': userid.uid,
      'email': email,
      'name': name,
      'username': username,
      'address': address,
      'phoneNumber': phoneNumber,
    }).then((value) => {
          FirebaseAuth.instance.signOut(),
          Get.to(() => LoginPage()),
        });
  } catch (e) {}
}

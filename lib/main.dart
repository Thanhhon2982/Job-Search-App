// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_cast, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:my_flutter_app/Jobs/ListAllJobs.dart';
import 'package:my_flutter_app/Profile%20Components/Logine.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    print(user?.uid.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng cổng thông tin tìm việc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data as User?;
            if (user == null) {
              return LoginPage();
            } else {
              return jobsList();
            }
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}

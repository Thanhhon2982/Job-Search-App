// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ví dụ về dữ liệu người dùng Firestore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserDataScreen(),
    );
  }
}

class UserDataScreen extends StatefulWidget {
  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController headlineController = TextEditingController();

  String name = '';
  String email = '';
  String phoneNumber = '';
  String bio = '';
  String headline = '';
  String profileImageUrl = 'https://example.com/placeholder.jpg';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      CollectionReference userDataCollection =
          FirebaseFirestore.instance.collection('userdata');

      try {
        DocumentSnapshot userData = await userDataCollection.doc(userId).get();

        if (userData.exists) {
          Map<String, dynamic> userDataMap =
              userData.data() as Map<String, dynamic>;
          setState(() {
            name = userDataMap['name'];
            email = userDataMap['email'];
            phoneNumber = userDataMap['phone'];
            bio = userDataMap['bio'];
            headline = userDataMap['headline'];
          });
        } else {
          print("Tài liệu không tồn tại");
        }
      } catch (e) {
        print("Lỗi tìm nạp dữ liệu: $e");
      }
    }
  }

  void showEditModal(String fieldName, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Trường không thể trống';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updateUserData(fieldName, controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Lưu'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  void updateUserData(String fieldName, String value) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      CollectionReference userDataCollection =
          FirebaseFirestore.instance.collection('userdata');

      try {
        await userDataCollection.doc(userId).update({
          fieldName: value,
        });
        fetchUserData();
      } catch (e) {
        print("Lỗi cập nhật dữ liệu: $e");
      }
    }
  }

  Map<String, Color> fieldColors = {
    'Name': Colors.blue,
    'Email': Colors.green,
    'Phone Number': Colors.orange,
    'Bio': Colors.purple,
    'Headline': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage('assets/2.jpg'),
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 16.0),
            buildEditableField('Name', name, nameController),
            buildEditableField('Email', email, emailController),
            buildEditableField(
                'Phone Number', phoneNumber, phoneNumberController),
            buildEditableField('Headline', headline, headlineController),
            Container(
              color: Color.fromARGB(255, 170, 218, 102),
              child: ListTile(
                title: Text('Bio:'),
                subtitle: Text(bio),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    bioController.text = bio;
                    showEditModal('Bio', bioController);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(
      String fieldName, String fieldValue, TextEditingController controller) {
    return ListTile(
      title: Text('$fieldName: $fieldValue'),
      tileColor: fieldColors[fieldName],
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          controller.text = fieldValue;
          showEditModal(fieldName, controller);
        },
      ),
    );
  }
}

// ignore_for_file: unused_import, use_key_in_widget_constructors, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/Profile%20Components/ProfilePage.dart';
import 'package:my_flutter_app/formsForFirst/education.dart';

class AddExperiencePage extends StatefulWidget {
  @override
  _AddExperiencePageState createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  String _message = '';
  Future<void> _addExperience() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final uid = user.uid;

      final experienceData = {
        'companyName': _companyController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'description': _descriptionController.text,
        'skills': _skillsController.text,
      };

      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(uid)
          .collection('experiences')
          .add(experienceData);

      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(uid)
          .update({'formdone': 0});

      setState(() {
        _message = 'Data added successfully';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kinh nghiệm',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 6, 60, 74),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: 'Tên công ty',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền tên công ty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      labelText: 'Ngày bắt đầu',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền ngày bắt đầu';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText: 'Ngày kết thúc',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền ngày kết thúc';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Mô tả',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Hãy mô tả';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _skillsController,
                    decoration: InputDecoration(
                      labelText: 'Kỹ năng',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền kĩ năng';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 169, 186, 190),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _addExperience();
                      }
                    },
                    child: Text('Thêm'),
                  ),
                  SizedBox(height: 20),
                  if (_message.isNotEmpty)
                    Text(
                      _message,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0), backgroundColor: Color.fromARGB(255, 6, 60, 74),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobProfilePage(),
                        ),
                      );
                    },
                    child: Text(
                      'Hoàn thành',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

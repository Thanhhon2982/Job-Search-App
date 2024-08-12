// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/formsForFirst/jobdata.dart';

class AddEducationPage extends StatefulWidget {
  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  String _message = '';
  Future<void> _addEducation() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final uid = user.uid;

      final educationDetails = {
        'educationType': _companyController.text,
        'college/university': _startDateController.text,
        'completion': _endDateController.text,
        'course': _descriptionController.text,
        'cgpa': _skillsController.text,
      };

      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(uid)
          .collection('Educations')
          .add(educationDetails);

      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(uid)
          .update({'formdone': 1});

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
          'Học vấn',
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
                      labelText: 'Trình độ học vấn',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền trình độ học vấn';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      labelText: 'Cao đẳng và Đại học',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền tên trường';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText: 'Tốt nghiệp',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền thời gian tốt nghiệp';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Niên khóa',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền niên khóa';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _skillsController,
                    decoration: InputDecoration(
                      labelText: 'Điểm trung bình',
                      icon: Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền điểm trung bình';
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
                        await _addEducation();
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
                          builder: (context) => AddExperiencePage(),
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

class temppage extends StatefulWidget {
  const temppage({super.key});

  @override
  State<temppage> createState() => _temppageState();
}

class _temppageState extends State<temppage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

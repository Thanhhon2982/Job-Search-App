// ignore_for_file: unused_import, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/formsForFirst/education.dart';
import 'package:my_flutter_app/formsForFirst/jobdata.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin người dùng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 6, 60, 74),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              await _signOut();
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _nameController,
                  labelText: 'Họ và tên',
                  icon: Icons.person,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                _buildTextFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng điền email';
                    } else if (!value.contains('@')) {
                      return 'Email phải chứa @';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                _buildTextFormField(
                  controller: _phoneController,
                  labelText: 'Số điện thoại',
                  icon: Icons.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    } else if (value.length != 10) {
                      return 'Số điện thoại phải 10 kí tự';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Địa chỉ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      _buildTextFormField(
                        controller: _pincodeController,
                        labelText: 'Pin code',
                        icon: Icons.location_on,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập pincode';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      _buildTextFormField(
                        controller: _cityController,
                        labelText: 'Thành phố',
                        icon: Icons.location_city,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập tên thành phố';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      _buildTextFormField(
                        controller: _countryController,
                        labelText: 'Quốc gia',
                        icon: Icons.location_on,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập tên Quốc gia';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0), backgroundColor: Color.fromARGB(255, 6, 60, 74),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveUserDataToFirestore();
                    }
                  },
                  child: Text(
                    'Lưu',
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
    );
  }

  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(
          icon,
          color: Colors.orange,
        ),
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  Future<void> _saveUserDataToFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': {
          'pincode': _pincodeController.text,
          'city': _cityController.text,
          'country': _countryController.text,
        },
      };
      final docId = currentUser.uid;
      final userRef =
          FirebaseFirestore.instance.collection('userdata').doc(docId);

      await userRef.set(userData);

      await userRef.update({'formdone': 2});

      _showSuccessMessage();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEducationPage(),
        ),
      );
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thông tin người dùng lưu thành công.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}

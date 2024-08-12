// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SkillsPage(),
    );
  }
}

class SkillsPage extends StatefulWidget {
  @override
  _SkillsPageState createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  List<String> _userSkills = [];

  final List<Color> _itemColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      _getUserSkills(user.uid);
    }
  }

  Future<void> _getUserSkills(String uid) async {
    final userData = await _firestore.collection('userdata').doc(uid).get();
    if (userData.exists) {
      final skills = userData['skills'] as List<dynamic>;
      setState(() {
        _userSkills = skills.cast<String>();
      });
    }
  }

  Future<void> _deleteSkill(int index) async {
    final uid = _currentUser!.uid;
    final skills = List<String>.from(_userSkills);
    skills.removeAt(index);

    await _firestore.collection('userdata').doc(uid).update({
      'skills': skills,
    });

    setState(() {
      _userSkills = skills;
    });
  }

  Future<void> _addSkill(String newSkill) async {
    final uid = _currentUser!.uid;
    final skills = List<String>.from(_userSkills);
    skills.add(newSkill);

    await _firestore.collection('userdata').doc(uid).update({
      'skills': skills,
    });

    setState(() {
      _userSkills = skills;
    });
  }

  void _showAddSkillDialog(BuildContext context) {
    String newSkill = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Thêm kỹ năng',
            style: TextStyle(fontSize: 18), // Adjust font size as needed
          ),
          content: TextField(
            onChanged: (value) {
              newSkill = value;
            },
            decoration: InputDecoration(
              labelText: 'Tên kỹ năng',
              labelStyle: TextStyle(fontSize: 16), // Adjust font size as needed
            ),
            style: TextStyle(fontSize: 16), // Adjust font size as needed
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Hủy',
                style: TextStyle(fontSize: 14), // Adjust font size as needed
              ),
            ),
            TextButton(
              onPressed: () {
                _addSkill(newSkill);
                Navigator.of(context).pop();
              },
              child: Text(
                'Thêm',
                style: TextStyle(fontSize: 14), // Adjust font size as needed
              ),
            ),
          ],
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kỹ năng người dùng'),
      ),
      body: _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : _userSkills.isEmpty
              ? Center(child: Text('Không tìm thấy kỹ năng.'))
              : ListView.builder(
                  itemCount: _userSkills.length,
                  itemBuilder: (context, index) {
                    final color = _itemColors[index % _itemColors.length];

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.all(2.0),
                      child: ListTile(
                        title: Text(
                          _userSkills[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteSkill(index);
                          },
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 12, 12, 12),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: InkWell(
          onTap: () {
            _showAddSkillDialog(context);
          },
          child: Text(
            'Thêm kỹ năng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

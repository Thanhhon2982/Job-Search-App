// ignore_for_file: unused_field, file_names, use_key_in_widget_constructors, avoid_print, unnecessary_cast, prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EditExperience());
}

class EditExperience extends StatefulWidget {
  @override
  State<EditExperience> createState() => _EditExperienceState();
}

class _EditExperienceState extends State<EditExperience> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  List<Map<String, dynamic>> _experiences = [];
  List<DocumentReference> _experiences2 = [];
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });

      final experiencesData = await _firestore
          .collection('userdata')
          .doc(user.uid)
          .collection('experiences')
          .get();
      _experiences2 = experiencesData.docs.map((doc) => doc.reference).toList();
      setState(() {
        _experiences = experiencesData.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    }
  }

  void _openAddExperienceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExperienceDialog(
          onAddExperience: (newExperience) {
            _addExperience(newExperience);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _addExperience(Map<String, dynamic> newExperience) async {
    if (_user != null) {
      final userUid = _user!.uid;

      await _firestore
          .collection('userdata')
          .doc(userUid)
          .collection('experiences')
          .add(newExperience);

      setState(() {
        _experiences.add(newExperience);
      });
    }
  }

  void _deleteExperience(Map<String, dynamic> experienceToDelete) async {
    if (_user != null) {
      final userUid = _user!.uid;

      try {
        final experiencesData = await _firestore
            .collection('userdata')
            .doc(userUid)
            .collection('experiences')
            .where('companyName', isEqualTo: experienceToDelete['companyName'])
            .where('description', isEqualTo: experienceToDelete['description'])
            .get();

        if (experiencesData.docs.isNotEmpty) {
          final documentReference = experiencesData.docs.first.reference;
          await documentReference.delete();
        }

        setState(() {
          _experiences.remove(experienceToDelete);
        });
      } catch (e) {
        print("Error deleting experience: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 15, 136, 116),
          title: Text('Hồ sơ công việc'),
        ),
        backgroundColor: Color.fromARGB(255, 228, 232, 231),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _openAddExperienceDialog();
                },
                child: Text("Thêm kinh nghiệm"),
              ),
              for (var experience in _experiences)
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(16),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Kinh nghiệm',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                ListTile(
                                  leading: Icon(
                                    Icons.work,
                                    color: Colors.amber,
                                  ),
                                  title: Text(
                                      'Công ty: ${experience['companyName'] ?? 'N/A'}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tên công ty: ${experience['companyName'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        'Địa chỉ: ${experience['description'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        'Ngày bắt đầu: ${experience['startDate'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        'Ngày kết thúc: ${experience['endDate'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        'Kỹ năng: ${experience['skills'] ?? 'N/A'}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteExperience(experience);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddExperienceDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddExperience;

  AddExperienceDialog({required this.onAddExperience});

  @override
  _AddExperienceDialogState createState() => _AddExperienceDialogState();
}

class _AddExperienceDialogState extends State<AddExperienceDialog> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Thêm kinh nghiệm",
        style: TextStyle(fontSize: 18), // Adjust font size as needed
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: "Tên công ty",
                labelStyle: TextStyle(fontSize: 16), // Adjust font size as needed
              ),
              style: TextStyle(fontSize: 16), // Adjust font size as needed
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Địa chỉ",
                labelStyle: TextStyle(fontSize: 16), // Adjust font size as needed
              ),
              style: TextStyle(fontSize: 16), // Adjust font size as needed
            ),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                labelText: "Ngày bắt đầu",
                labelStyle: TextStyle(fontSize: 16), // Adjust font size as needed
              ),
              style: TextStyle(fontSize: 16), // Adjust font size as needed
            ),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(
                labelText: "Ngày kết thúc",
                labelStyle: TextStyle(fontSize: 16), // Adjust font size as needed
              ),
              style: TextStyle(fontSize: 16), // Adjust font size as needed
            ),
            TextField(
              controller: _skillsController,
              decoration: InputDecoration(
                labelText: "Kỹ năng",
                labelStyle: TextStyle(fontSize: 16), // Adjust font size as needed
              ),
              style: TextStyle(fontSize: 16), // Adjust font size as needed
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Hủy",
            style: TextStyle(fontSize: 14), // Adjust font size as needed
          ),
        ),
        TextButton(
          onPressed: () {
            final newExperience = {
              'Tên công ty': _companyNameController.text,
              'Địa chỉ': _descriptionController.text,
              'Ngày bắt đầu': _startDateController.text,
              'Ngày kết thúc': _endDateController.text,
              'Kỹ năng': _skillsController.text,
            };

            widget.onAddExperience(newExperience);
          },
          child: Text(
            "Thêm",
            style: TextStyle(fontSize: 14), // Adjust font size as needed
          ),
        ),
      ],
    );

  }
}

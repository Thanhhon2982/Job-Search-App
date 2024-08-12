// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/Components/BottomNavigator.dart';
import 'package:my_flutter_app/Jobs/SeeAllJobPostedByCurrentUser.dart';

class JobPostingPage extends StatefulWidget {
  @override
  _JobPostingPageState createState() => _JobPostingPageState();
}

class _JobPostingPageState extends State<JobPostingPage> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _profileLinkController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Tuyển dụng',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 3, 53, 41),
          actions: [
            IconButton(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => JobsPostedPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiêu đề công việc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _jobTitleController,
                  decoration: InputDecoration(
                    hintText: 'Ghi tiêu đề công việc',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Địa chỉ làm việc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _jobDescriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Điền địa chỉ làm việc',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tên công ty',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _companyNameController,
                  decoration: InputDecoration(
                    hintText: 'Điền tên công ty',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Profile Link',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _profileLinkController,
                  decoration: InputDecoration(
                    hintText: 'Điền profile link',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Lương',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _salaryController,
                  decoration: InputDecoration(
                    hintText: 'Điền salary',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Kỹ năng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _skillsController,
                  decoration: InputDecoration(
                    hintText: 'Điền các yêu cầu về kỹ năng',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _postJobToFirestore();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 3, 53, 41), // Button color
                  ),
                  child: Text(
                    'Đăng tuyển dụng',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(),
      ),
    );
  }

  void _postJobToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    String uid = user.uid;

    CollectionReference jobsCollection =
        FirebaseFirestore.instance.collection('jobsposted');

    Map<String, dynamic> jobData = {
      'jobTitle': _jobTitleController.text,
      'jobDescription': _jobDescriptionController.text,
      'companyName': _companyNameController.text,
      'profileLink': _profileLinkController.text,
      'salary': _salaryController.text,
      'skills': _skillsController.text.split(','),
      'postedBy': uid,
      'postedDate': DateTime.now().toLocal().toString(),
    };

    try {
      await jobsCollection.add(jobData);

      _showSuccessMessage(context);

      _clearTextFields();
    } catch (e) {
      print('Error posting job: $e');
    }
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Job posted successfully!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearTextFields() {
    _jobTitleController.clear();
    _jobDescriptionController.clear();
    _companyNameController.clear();
    _profileLinkController.clear();
    _salaryController.clear();
    _skillsController.clear();
  }
}

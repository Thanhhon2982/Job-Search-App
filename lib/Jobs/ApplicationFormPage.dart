// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication

class ApplicationFormPage extends StatelessWidget {
  final String jobId;
  final User? currentUser; // User object to hold the current user

  ApplicationFormPage({required this.jobId, required this.currentUser});

  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _salaryExpectationController =
      TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Apply for Job',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 3, 53, 41),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why should I hire you?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _experienceController,
              decoration: InputDecoration(
                hintText: 'Years of experience...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Have you worked on any projects?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _projectController,
              decoration: InputDecoration(
                hintText: 'Enter project details...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16.0),
            Text(
              'Salary Expectation',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _salaryExpectationController,
              decoration: InputDecoration(
                hintText: 'Enter your salary expectation...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Are you available immediately?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _availabilityController,
              decoration: InputDecoration(
                hintText: 'Yes or No',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String experience = _experienceController.text;
                String projects = _projectController.text;
                String salaryExpectation = _salaryExpectationController.text;
                String availability = _availabilityController.text;

                if (experience.isNotEmpty &&
                    projects.isNotEmpty &&
                    salaryExpectation.isNotEmpty &&
                    availability.isNotEmpty) {
                  String userUid = currentUser?.uid ?? '';
                  FirebaseFirestore.instance
                      .collection('jobsposted')
                      .doc(jobId)
                      .collection('applications')
                      .doc(userUid)
                      .set({
                    'experience': experience,
                    'projects': projects,
                    'salaryExpectation': salaryExpectation,
                    'availability': availability,
                  }).then((_) {
                    print('Application submitted for jobId: $jobId');
                    print('User UID: $userUid');
                    print('Experience: $experience');
                    print('Projects: $projects');
                    print('Salary Expectation: $salaryExpectation');
                    print('Availability: $availability');
                    Navigator.pop(context, true);
                  }).catchError((error) {
                    print('Error submitting application: $error');
                  });
                }
              },
              child: Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }
}

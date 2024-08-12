// ignore_for_file: unnecessary_import, file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/Jobs/ApplicationFormPage.dart';

class JobDetailPage extends StatefulWidget {
  final String jobId;

  JobDetailPage({required this.jobId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  bool hasApplied = false;
  bool shouldReload = false;
  @override
  void initState() {
    super.initState();
    checkApplicationStatus();
  }

  void checkApplicationStatus() async {
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('jobsposted')
          .doc(widget.jobId)
          .collection('applications')
          .doc(user!.uid)
          .get();

      setState(() {
        hasApplied = snapshot.exists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết công việc',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 3, 53, 41),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('jobsposted')
            .doc(widget.jobId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var jobData = snapshot.data!.data() as Map<String, dynamic>;
          var jobTitle =
              jobData['jobTitle'] as String? ?? 'Job Title Not Provided';
          var companyName =
              jobData['companyName'] as String? ?? 'Company Name Not Provided';
          var jobDescription = jobData['jobDescription'] as String? ??
              'Job Description Not Provided';
          var salary = jobData['salary'] as String? ?? 'Salary Not Provided';
          var companyImageURL = jobData['companyImageURL'] as String? ?? '';
          var skills = jobData['skills'] as List<dynamic>?;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          'assets/1.jpg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Công ty: $companyName',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Lương: $salary',
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: 450,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Địa chỉ làm việc',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              jobDescription,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (companyImageURL.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          companyImageURL,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                if (skills != null && skills.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kỹ năng cần',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            Wrap(
                              spacing: 8.0,
                              children: skills.map((skill) {
                                    return Chip(
                                      label: Text(
                                        skill,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.indigo,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4.0,
                                        horizontal: 8.0,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      )),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!hasApplied) {
                        final shouldReloadFromSecondPage = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplicationFormPage(
                              jobId: widget.jobId,
                              currentUser: user,
                            ),
                          ),
                        );
                        if (shouldReloadFromSecondPage == true) {
                          setState(() {
                            shouldReload = true;
                          });
                        }
                      }
                    },
                    child: Text(hasApplied ? 'Đã ứng tuyển' : 'Ứng tuyển'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasApplied ? Colors.grey : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

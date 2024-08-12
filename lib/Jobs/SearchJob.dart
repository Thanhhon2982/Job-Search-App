// ignore_for_file: unnecessary_import, file_names, use_key_in_widget_constructors, deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/Components/BottomNavigator.dart';
import 'package:my_flutter_app/Jobs/JobDetails.dart';

class JobSearchPage extends StatelessWidget {
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
            'Tìm việc',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 3, 53, 41),
        ),
        body: JobList(),
        bottomNavigationBar: BottomNavigatorExample(),
      ),
    );
  }
}

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> jobDocs = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
            ),
            decoration: InputDecoration(
              hintText: 'Tìm việc',
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              _searchJobs(value);
            },
          ),
        ),
        Expanded(
          child: jobDocs.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/animation_lmm6bvuc.json',
                    width: 350,
                    repeat: true,
                    reverse: false,
                    animate: true,
                  ),
                )
              : ListView.builder(
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    var job = jobDocs[index].data() as Map<String, dynamic>;
                    var jobId = jobDocs[index].id;

                    var jobTitle =
                        job['jobTitle'] as String? ?? 'Job Title Not Provided';
                    var companyName = job['companyName'] as String? ??
                        'Company Name Not Provided';
                    var salary =
                        job['salary'] as String? ?? 'Salary Not Provided';
                    var postedDate = job['postedDate'] as String? ?? 'no date';
                    var skills = job['skills'] as List<dynamic>?;
                    var skillsText = skills != null
                        ? skills.join(', ')
                        : 'Skills Not Provided';
                    return Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 161, 216, 211),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        title: Text(
                          jobTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Công ty: $companyName',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 26, 4, 107),
                              ),
                            ),
                            Text(
                              'Lương: $salary',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 94, 15),
                              ),
                            ),
                            Text(
                              'Kỹ năng: $skillsText',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 176, 60, 132),
                              ),
                            ),
                            Text(
                              'Ngày đăng: $postedDate',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 44, 123, 214),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailPage(jobId: jobId),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _searchJobs(String query) {
    final CollectionReference jobsCollection =
        FirebaseFirestore.instance.collection('jobsposted');

    jobsCollection
        .where('jobTitle', isGreaterThanOrEqualTo: query)
        .where('jobTitle', isLessThan: query + 'z')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        jobDocs = querySnapshot.docs;
      });
    }).catchError((error) {
      print("Error getting documents: $error");
    });
  }
}

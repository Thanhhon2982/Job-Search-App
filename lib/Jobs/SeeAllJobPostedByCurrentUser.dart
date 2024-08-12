// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/Jobs/seeSpecificJobByCurrentUser.dart';

class JobsPostedPage extends StatefulWidget {
  @override
  _JobsPostedPageState createState() => _JobsPostedPageState();
}

class _JobsPostedPageState extends State<JobsPostedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.amber,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Công việc được đăng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 3, 53, 41),
      ),
      body: FutureBuilder<User?>(
        future: _auth.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final currentUser = snapshot.data;

            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('jobsposted')
                  .where('postedBy', isEqualTo: currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Không tìm thấy công việc được đăng.',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final document = snapshot.data!.docs[index];
                      final jobTitle = document['jobTitle'];
                      final postedDate = document['postedDate'];
                      final documentId = document.id;

                      return Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 169, 215, 213),
                          borderRadius: BorderRadius.circular(10),
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
                          subtitle: Text(
                            'Ngày đăng: $postedDate',
                            style: TextStyle(
                              color: Color.fromARGB(255, 210, 78, 11),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeeSpecificJobApplicants(
                                  documentId: documentId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: JobsPostedPage(),
  ));
}

// ignore_for_file: file_names, use_key_in_widget_constructors, unnecessary_cast, avoid_print, deprecated_member_use, prefer_const_constructors, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Components/BottomNavigator.dart';
import 'package:my_flutter_app/Jobs/SeeAllJobPostedByCurrentUser.dart';
import 'package:my_flutter_app/UpdateProfile/EditExperience.dart';
import 'package:my_flutter_app/UpdateProfile/UpdateBio.dart';
import 'package:my_flutter_app/UpdateProfile/updateskills.dart';
import 'package:my_flutter_app/formsForFirst/education.dart';
import 'package:my_flutter_app/formsForFirst/jobdata.dart';
import 'package:my_flutter_app/formsForFirst/userInfoData.dart';
import 'package:my_flutter_app/Profile%20Components/Logine.dart';
void main() {
  runApp(JobProfilePage());
}

class JobProfilePage extends StatefulWidget {
  @override
  State<JobProfilePage> createState() => _JobProfilePageState();
}

class _JobProfilePageState extends State<JobProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  List<Map<String, dynamic>> _experiences = [];
  Map<String, dynamic>? _userData;
  List<dynamic> _skills = [];
  int _formDone = 0;
  List<Color> skillColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    // Add more colors as needed
  ];
  @override
  void initState() {
    super.initState();
    checkform();
    _getUserData();
  }

  Future<void> checkform() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('userdata')
          .doc(_user!.uid) // Use the current user's UID as the document ID
          .get();

      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('formdone')) {
          // If 'formdone' field is present, set its value
          setState(() {
            _formDone = userData['formdone'];
          });
        } else {
          // If 'formdone' field is not present, set it to 5
          _firestore
              .collection('userdata')
              .doc(_user!.uid)
              .set({'formdone': 3}, SetOptions(merge: true));

          setState(() {
            _formDone = 3;
          });
        }
      }
    }
  }

  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
      final userData =
          await _firestore.collection('userdata').doc(user.uid).get();
      if (userData.exists) {
        final userDataMap = userData.data() as Map<String, dynamic>;

        final experiencesData = await _firestore
            .collection('userdata')
            .doc(user.uid)
            .collection('experiences')
            .get();
        setState(() {
          _experiences = experiencesData.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });

        // Fetch the "skills" field from the user's Firestore document
        final skills = userDataMap['skills'] as List<dynamic>;
        setState(() {
          _skills = skills; // Assign the skills to the _skills list
        });

        // Now you can access the 'email' property from userDataMap
        print('User Email: ${userDataMap['email']}');

        // Update your widget with the user data
        setState(() {
          _userData = userDataMap;
        });
      }
    }
  }
  Future<void> _signOut() async {
    final currentContext = context;
    await _auth.signOut();
    setState(() {
      _user = null;
    });
    if (currentContext.mounted) {
      Navigator.pushReplacement(
        currentContext,
        MaterialPageRoute(
          builder: (currentContext) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _formDone == 0
        ? MaterialApp(
            home: WillPopScope(
              onWillPop: () async {
                // Return true to allow navigation back, return false to prevent it
                return false; // Prevent back navigation
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 3, 53, 41),
                  title: Text('Thông tin người dùng',
                    style: TextStyle(color: Colors.white)) ,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: _signOut,
                    ),
                  ],
                ),
                backgroundColor: Color.fromARGB(255, 3, 53, 41),
                body: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      // Background Gradient
                      Stack(
                        alignment: Alignment
                            .bottomCenter, // Align the white border and shading to the bottom
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/nen.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.2, // Match the height of the image container
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 4.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUserDataPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    AssetImage('assets/nth1.png'),
                              ),
                            ),
                            SizedBox(height: 4),
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(6),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 161, 216, 211),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${_userData?['name'] ?? 'N/A'}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color:
                                              Color.fromARGB(255, 84, 30, 210),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Bio: ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${_userData?['bio'] ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 59, 183, 25),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.all(16),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(6),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 135, 212, 229),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Hồ sơ công việc',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              for (var experience
                                                  in _experiences)
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.work,
                                                    color: Colors.amber,
                                                  ),
                                                  title: Text(
                                                      'Công ty: ${experience['companyName'] ?? 'N/A'}'),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Tên công ty: ${experience['companyName'] ?? 'N/A'}',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        'Địa chỉ: ${experience['description'] ?? 'N/A'}',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        'Ngày bắt đầu: ${experience['startDate'] ?? 'N/A'}',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        'Ngày kết thúc: ${experience['endDate'] ?? 'N/A'}',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        'Kỹ năng: ${experience['skills'] ?? 'N/A'}',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditExperience(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.all(16),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(6),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 135, 212, 229),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Kỹ năng',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8.0,
                                                runSpacing: 8.0,
                                                children: _skills
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  final skill = entry.value;
                                                  final skillIndex = entry.key;
                                                  final skillColor =
                                                      skillColors[skillIndex %
                                                          skillColors.length];

                                                  return Chip(
                                                    label: Text(skill),
                                                    backgroundColor: skillColor,
                                                    labelStyle: TextStyle(
                                                        color: Colors.white),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SkillsPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavigatorExample(),
              ),
            ),
          )
        : _buildPageForFormDoneValue(_formDone);
  }

  Widget _buildPageForFormDoneValue(int formDone) {
    switch (formDone) {
      case 1:
        return AddExperiencePage();
      case 2:
        return AddEducationPage();
      case 3:
        return UserInfoPage();
      default:
        return Text('Invalid formdone value: $formDone');
    }
  }
}


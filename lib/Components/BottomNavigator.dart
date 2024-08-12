// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:my_flutter_app/Jobs/ListAllJobs.dart';
import 'package:my_flutter_app/Jobs/SearchJob.dart';
import 'package:my_flutter_app/Jobs/PostAJob.dart';
import 'package:my_flutter_app/Profile%20Components/ProfilePage.dart';
import 'package:my_flutter_app/map/Jobmap.dart';

class BottomNavigatorExample extends StatefulWidget {
  @override
  _BottomNavigatorExampleState createState() => _BottomNavigatorExampleState();
}

class _BottomNavigatorExampleState extends State<BottomNavigatorExample> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color.fromARGB(255, 3, 53, 41),
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Đăng tuyển dụng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Bản đồ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Thông tin người dùng',
          ),

        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => jobsList()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobSearchPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobPostingPage()),
            );
          } else if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Jobmap()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobProfilePage()),
            );
          }
        },
      ),
    );
  }
}

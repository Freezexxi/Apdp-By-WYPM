import 'package:apdpbywypm/models/attendenceStar.dart';
import 'package:apdpbywypm/models/courseStar.dart';
import 'package:flutter/material.dart';
import 'package:apdpbywypm/subPage/attendanceStarPage.dart';
import 'package:apdpbywypm/subPage/homeStarPage.dart';
import 'package:apdpbywypm/subPage/courseStarPage.dart';
import 'package:apdpbywypm/subPage/studentStarPage.dart';

class MainStarPage extends StatefulWidget {
  const MainStarPage({super.key});

  @override
  State<MainStarPage> createState() => _MainStarPageState();
}

class _MainStarPageState extends State<MainStarPage> {
  int _nowIndex = 0;

  final List<Widget> _subPage = [
    HomeStarPage(),
    CourseStarPage(),
    StudentStarPage(),
    AttendenceStarPage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _nowIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _subPage[_nowIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orangeAccent,
        type: BottomNavigationBarType.fixed,
        currentIndex: _nowIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_max_outlined), label: 'Star Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_online_outlined), label: 'Star Course'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined), label: 'Star Student'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind_outlined),
              label: 'Star Attendance'),
        ],
      ),
    );
  }
}

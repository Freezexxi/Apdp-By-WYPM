import 'package:flutter/material.dart';

class AttendanceStarPage extends StatefulWidget {
  const AttendanceStarPage({super.key});

  @override
  State<AttendanceStarPage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendanceStarPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Attendance Page"),
    );
  }
}

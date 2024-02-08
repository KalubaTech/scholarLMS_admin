import 'package:flutter/material.dart';

class TimetableEntry {
  String day;
  String course;
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimetableEntry({
    required this.day,
    required this.course,
    required this.startTime,
    required this.endTime,
  });
}
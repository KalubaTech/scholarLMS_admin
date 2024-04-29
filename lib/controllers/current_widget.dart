import 'package:flutter_timetable/flutter_timetable.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:stdominicsadmin/views/admin/manage_students.dart';
import 'package:stdominicsadmin/views/admin/settings.dart';
import 'package:stdominicsadmin/views/my_classes.dart';
import 'package:stdominicsadmin/views/pages/dashboard/dashboard.dart';
import 'package:stdominicsadmin/views/report_forms.dart';

import '../views/admin/timetable.dart';

class CurrentWidget extends GetxController{
  var currentWidget = 'Dashboard'.obs;


  Widget getWidget(value){
    switch(value){
      case "Dashboard":
        return Dashboard();
      case "Timetable":
        return ManageTimetable();
      case "Manage Students":
        return ManageStudents();
      case "My Courses":
        return MyClasses();
      case "Report Forms":
        return ReportForms();
      case "Settings":
        return SettingsScreen([]);
      default:
        return Dashboard();

    }


  }
}
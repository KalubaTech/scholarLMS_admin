import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stdominicsadmin/controllers/announcements_controller.dart';
import 'package:stdominicsadmin/controllers/current_widget.dart';
import 'package:stdominicsadmin/controllers/my_classes_controller.dart';
import 'package:stdominicsadmin/controllers/results_controller.dart';
import 'package:stdominicsadmin/controllers/teacher_controller.dart';
import 'package:stdominicsadmin/views/home.dart';
import 'package:get/get.dart';
import 'dart:ui_web' as ui;
import 'package:stdominicsadmin/views/sign_in.dart';
import 'package:stdominicsadmin/views/welcome.dart';
import 'controllers/guardians_controller.dart';
import 'controllers/reasons_controller.dart';
import 'controllers/scroll_behaviour/scroll_behaviour.dart';
import 'controllers/selectedCourseController.dart';
import 'controllers/selectedItemsController.dart';
import 'controllers/selected_guardian_controller.dart';
import 'controllers/selected_timetable.dart';
import 'controllers/students_controller.dart';
import 'controllers/teachers_controller.dart';
import 'controllers/timetable_controller.dart';
import 'controllers/tutorController.dart';
import 'controllers/institution_controller.dart';
import 'helpers/quick_sign_in.dart';

void main() async{
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBqw8ZR0SHyBePygK5f9qqX3ygI9AwueSY",
        authDomain: "st-dominics-a6ecd.firebaseapp.com",
        projectId: "st-dominics-a6ecd",
        storageBucket: "st-dominics-a6ecd.appspot.com",
        messagingSenderId: "792189478168",
        appId: "1:792189478168:web:8ecda3e2ba970e061dea6d",
        measurementId: "G-YW86KHSGR4"
      )
  );
  await Get.put(TutorController());
  await Get.put(InstitutionController());
  await Get.put(SelectedCourseController());
  await Get.put(TeacherController());
  await Get.put(TeachersController());
  await Get.put(StudentsController());
  await Get.put(MyClassesController());
  await Get.put(ResultsController());
  await Get.put(ReasonsController());
  await Get.put(GuardiansController());
  await Get.put(AnnouncementsController());
  await Get.put(SelectedGuardianController());
  await Get.put(CurrentWidget());
  await Get.put(TimetableDataController());
  await Get.put(SelectedTimetable());


  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


 /*   if(GetStorage().hasData('email')){
      QuickSignIn().signIn();
    }*/
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Admin | Tutor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xf0a3462)),
        useMaterial3: true,
      ),
      home: Welcome(), //GetStorage().hasData('email')?Home():
    );
  }
}

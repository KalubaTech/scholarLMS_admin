

import 'package:get/get.dart';

import '../models/student_model.dart';

class StudentsController extends GetxController{
  var students = <StudentModel>[].obs;

  void updateStudents(List<StudentModel> students){
    this.students.value = students;

    update();
  }

}
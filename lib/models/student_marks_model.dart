
import 'package:stdominicsadmin/models/result_model.dart';
import 'package:stdominicsadmin/models/student_model.dart';

class StudentMarksModel{
  StudentModel student;
  List<ResultModel> results;

  StudentMarksModel({required this.student, required this.results});
}
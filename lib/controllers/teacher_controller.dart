import 'package:get/get.dart';
import '../models/teacher_model.dart';

class TeacherController extends GetxController{
  var teacher = TeacherModel(uid: '', fullname: '', email: '', institutionID: '', photo: '', password: '').obs;
}
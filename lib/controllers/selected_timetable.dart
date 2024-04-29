import 'package:get/get.dart';
import 'package:stdominicsadmin/controllers/timetable_controller.dart';
import 'package:stdominicsadmin/models/timetable_model.dart';

class SelectedTimetable extends GetxController{


  var selectedTimetable = TimetableModel(
      id: '',
      title: '',
      description: '',
      audience: [],
      days: [],
      data: [],
      teacher: '',
      datetime: ''
  ).obs;
}
import 'package:get/get.dart';


class SelectedCourseController extends GetxController{

  var selectedCourse = ''.obs;

  void updateSelectedCourse(String course){
    this.selectedCourse.value = course;

    update();
  }

}
import 'package:get/get.dart';
import 'package:stdominicsadmin/models/tutorModel.dart';

class TutorController extends GetxController{

  var tutor = TutorModel(uid: '', email: '', password: '', name: '', courses: [], institutionID: '').obs;

  void notifyTutor(TutorModel tutor){
    this.tutor.value = tutor;
    update();
  }


}
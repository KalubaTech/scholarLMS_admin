import 'package:get/get.dart';
import '../models/TutorModel.dart';

class TutorController extends GetxController{

  var tutor = TutorModel(uid: '', email: '', password: '', name: '', courses: [], institutionID: '', photo: '').obs;

  void notifyTutor(TutorModel tutor){
    this.tutor.value = tutor;
    update();
  }


}
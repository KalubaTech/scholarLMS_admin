import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:stdominicsadmin/controllers/tutorController.dart';
import 'package:stdominicsadmin/models/tutorModel.dart';
import 'package:stdominicsadmin/views/home.dart';

import '../controllers/selectedCourseController.dart';
import '../models/institution_model.dart';
import 'methods.dart';



class QuickSignIn{

  TutorController _tutorController = Get.find();
  InstitutionController _institutionController = Get.find();
  SelectedCourseController _selectedCourseController = Get.find();

  Methods _methods = Methods();

  signIn()async{

    String email = await GetStorage().read('email');

    await FirebaseFirestore.instance.collection('tutor').where('email', isEqualTo: email).get()
    .then((value){
      if(value.size>0){ 
        FirebaseFirestore.instance.collection('institutions').doc(value.docs.first.get('institutionID')).get().then((value){
          _institutionController.institution.value =
              InstitutionModel(id: value.id, name: value.get('name'), admin: value.get('admin'), logo: value.get('logo'), motto: value.get('motto'),type: value.get('type'));

        });

        _methods.preselectCourse();
        TutorModel tutor = TutorModel(uid: value.docs.first.id, email:value.docs.first.get('email'),password: value.docs.first.get('password'), name: value.docs.first.get('name'), courses: value.docs.first.get('courses'), institutionID: value.docs.first.get('institutionID'));
        _tutorController.notifyTutor(tutor) ;
      }
    });

  }
}
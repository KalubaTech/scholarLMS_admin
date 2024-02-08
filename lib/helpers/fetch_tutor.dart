import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:stdominicsadmin/controllers/selectedCourseController.dart';
import 'package:stdominicsadmin/controllers/tutorController.dart';

import 'package:get/get.dart';
import 'package:stdominicsadmin/models/tutorModel.dart';

import '../models/institution_model.dart';
import 'methods.dart';

  TutorController _tutorController = Get.find();

  InstitutionController _institutionController = Get.find();
  SelectedCourseController _selectedCourseController = Get.find();

  Methods _methods = Methods();


  fetchTutor(String email)async{

     await FirebaseFirestore.instance.collection('tutor').where('email', isEqualTo: email).get().then((value)async{

       FirebaseFirestore.instance.collection('institutions').doc(value.docs.first.get('institutionID')).get().then((value){
         _institutionController.institution.value =
             InstitutionModel(id: value.id, name: value.get('name'), admin: value.get('admin'), logo: value.get('logo'), motto: value.get('motto'), type: value.get('type'));

       });

       await _methods.preselectCourse();
       TutorModel tutor = TutorModel(uid: value.docs.first.id, email:value.docs.first.get('email'),password: value.docs.first.get('password'), name: value.docs.first.get('name'), courses: value.docs.first.get('courses'), institutionID: value.docs.first.get('institutionID'));
       _tutorController.notifyTutor(tutor) ;
     });



  }
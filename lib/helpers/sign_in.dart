import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/teacher_model.dart';

class SignHelper{
  FirebaseFirestore fs = FirebaseFirestore.instance;

  signIn(email,password)async{
    var teacherModel = TeacherModel(uid: '', fullname: '', email: email, institutionID: '', photo: '', password: '');

    try {
      var teacher = await fs.collection('tutor').where("email",isEqualTo: email).where('password', isEqualTo: password).get();
     // print(teacher);
      if(teacher.docs.isNotEmpty){
        teacherModel = TeacherModel(
            uid: teacher.docs.first.id,
            fullname: teacher.docs.first.get('name'),
            email: teacher.docs.first.get('email'),
            institutionID: teacher.docs.first.get('institutionID'),
            photo: teacher.docs.first.get('photo'),
            password: teacher.docs.first.get('password')
        );

      }
    } on Exception catch (e) {
      // TODO

    }

    return teacherModel;
  }

}
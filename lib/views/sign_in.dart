import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stdominicsadmin/models/institution_model.dart';
import 'package:stdominicsadmin/models/tutorModel.dart';
import 'package:stdominicsadmin/views/home.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/selectedCourseController.dart';
import '../controllers/tutorController.dart';
import '../controllers/institution_controller.dart';
import '../helpers/methods.dart';


class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {

  Methods _methods = Methods();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TutorController _tutorController = Get.find();
  InstitutionController _institutionController = Get.find();
  SelectedCourseController _selectedCourseController = Get.find();
  

  bool onerror = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kara.Colors.background,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white70
        ),
        child: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black54,blurRadius: 1,spreadRadius: 1,offset: Offset(0, 1))
                  ]
              ),
              width: 400,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/scholar.png', width: 90),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.grey.withOpacity(0.1),
                      child: Center(child: Text('SIGN IN', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: kara.Colors.green),))
                  ),
                  onerror?Container(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Text('EMAIL OR PASSWORD IS INCORRECT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
                        ],
                      )
                  ):Container(),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('  Email:', style: TextStyle(
                          fontWeight: FontWeight.bold
                      )),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                                controller: emailController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none
                                )
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Text('  Password:', style: TextStyle(
                          fontWeight: FontWeight.bold
                      )),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Column(
                          children: [
                            TextField(
                                controller: passwordController,
                                textAlign: TextAlign.center,
                                obscureText: true,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none
                                )
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 40,
                        child: TouchRippleEffect(
                          onTap: ()async{
                            onerror = false;
                            Get.defaultDialog(
                                title: '',
                                content: Center(
                                  child: LoadingAnimationWidget.flickr(
                                    size: 60,
                                    leftDotColor: Colors.lightBlue,
                                    rightDotColor: Colors.redAccent,
                                  ),
                                ),
                                backgroundColor: Colors.transparent
                            );
                            if(emailController.text.isNotEmpty&&passwordController.text.isNotEmpty){
                              await FirebaseFirestore.instance.collection('tutor')
                                  .where('email', isEqualTo: emailController.text)
                                  .where('password', isEqualTo: passwordController.text).get()
                                  .then((value){
                                if(value.size>0){

                                  TutorModel tutor = TutorModel(uid: value.docs.first.id, email:value.docs.first.get('email'),password: value.docs.first.get('password'), name: value.docs.first.get('name'), courses: value.docs.first.get('courses'), institutionID: value.docs.first.get('institutionID'));
                                  _tutorController.notifyTutor(tutor) ;
                                  _methods.preselectCourse();
                                  FirebaseFirestore.instance.collection('institutions').doc(value.docs.first.get('institutionID')).get().then((value){
                                    _institutionController.institution.value =
                                        InstitutionModel(id: value.id, name: value.get('name'), admin: value.get('admin'), logo: value.get('logo'), motto: value.get('motto'),type: value.get('type'));

                                  });

                                  GetStorage().write('email',emailController.text);
                                  Get.offAll(()=>Home());

                                }else{

                                  Get.back();
                                  setState(() {
                                    onerror = true;
                                  });
                                }
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(10),
                          rippleColor: Colors.greenAccent,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: kara.Colors.primary,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                child: Text('Log In', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              )
          ),
        )
      )
    );
  }
}

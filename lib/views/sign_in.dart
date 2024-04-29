import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stdominicsadmin/models/institution_model.dart';
import 'package:stdominicsadmin/views/home.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/selectedCourseController.dart';
import '../controllers/tutorController.dart';
import '../controllers/institution_controller.dart';
import '../helpers/methods.dart';
import '../helpers/sign_in.dart';
import '../models/TutorModel.dart';
import '../models/teacher_model.dart';


class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {

  Methods _methods = Methods();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Methods methods = Methods();
  SignHelper signHelper = SignHelper();

  bool onerror = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Kara.background,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white70
        ),
        child: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black38,blurRadius: 1,spreadRadius: 1,offset: Offset(0, 1))
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
                      child: Center(child: Text('SIGN IN', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Kara.green),))
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
                            if(emailController.text.isNotEmpty&&passwordController.text.isNotEmpty){
                              Get.dialog(
                                  Center(
                                     child: LoadingAnimationWidget.discreteCircle(
                                          color: Kara.primary,
                                          size: 30)
                                  ),
                                  barrierColor: Colors.white70.withOpacity(0.2),
                                  barrierDismissible: false
                              );
                              TeacherModel teacher = await signHelper.signIn(emailController.text, passwordController.text);


                              if(teacher.uid==''){
                                //print('ERROR LOGIN');
                                Get.back();
                              }else{
                                //print('SUCCESS');

                                await GetStorage().write('user', teacher.uid);
                                _methods.signInSilently(teacher.uid);

                              }
                            }

                           /* if(emailController.text.isNotEmpty&&passwordController.text.isNotEmpty){
                              await FirebaseFirestore.instance.collection('tutor')
                                  .where('email', isEqualTo: emailController.text)
                                  .where('password', isEqualTo: passwordController.text).get()
                                  .then((value){
                                if(value.size>0){

                                  TutorModel tutor = TutorModel(uid: value.docs.first.id, email:value.docs.first.get('email'),password: value.docs.first.get('password'), name: value.docs.first.get('name'), courses: value.docs.first.get('courses'), institutionID: value.docs.first.get('institutionID'), photo: value.docs.first.get('photo'));
                                  _tutorController.notifyTutor(tutor) ;
                                  _methods.preselectCourse();
                                  FirebaseFirestore.instance.collection('institutions').doc(value.docs.first.get('institutionID')).get().then((value){
                                    _institutionController.institution.value =
                                        InstitutionModel(
                                            uid: value.id,
                                            name: value.get('name'),
                                            admin: value.get('admin'),
                                            logo: value.get('logo'),
                                            motto: value.get('motto'),
                                            type: value.get('type'),
                                            status: value.get('status'),
                                            province: value.get('province'),
                                            district: value.get('district'),
                                            country: value.get('country'),
                                            subscriptionType: value.get('subscription'),
                                        );

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
                            }*/
                          },
                          borderRadius: BorderRadius.circular(10),
                          rippleColor: Colors.greenAccent,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Kara.primary,
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

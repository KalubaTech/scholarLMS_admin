import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stdominicsadmin/controllers/current_widget.dart';
import 'package:stdominicsadmin/customs/tab_menu_component.dart';
import 'package:stdominicsadmin/models/institution_model.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import 'package:get/get.dart';
import 'package:stdominicsadmin/styles/font_sizes.dart';
import 'package:stdominicsadmin/views/pages/dashboard/dashboard.dart';
import 'package:stdominicsadmin/views/report_forms.dart';
import 'package:stdominicsadmin/views/sign_in.dart';
import 'package:stdominicsadmin/views/tab_pages/assessments_page.dart';
import 'package:stdominicsadmin/views/tab_pages/books_page.dart';
import 'package:stdominicsadmin/views/tab_pages/results_page.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/institution_controller.dart';
import '../controllers/selectedCourseController.dart';
import '../controllers/students_controller.dart';
import '../controllers/teacher_controller.dart';
import '../controllers/tutorController.dart';
import 'package:flexible_expansion_list/flexible_expansion_list.dart';
import '../customs/sidebar.dart';
import '../helpers/date_formater.dart';
import '../helpers/methods.dart';
import '../helpers/time_ago_str.dart';
import '../models/student_model.dart';
import 'about_us.dart';
import 'admin/manage_students.dart';
import 'admin/settings.dart';
import 'admin/super_admin.dart';
import 'admin/timetable.dart';
import 'assessment_reader.dart';
import 'my_classes.dart';
import 'tab_pages/notice_board.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  TabController? _tabController;

  TeacherController _tutorController = Get.find();
  InstitutionController _institutionController = Get.find();

  String attachmentUrl = '';

  TextEditingController newPasswordController = TextEditingController();
  StudentsController _studentsController = Get.find();

  CurrentWidget currentWidget = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.delayed(Duration(seconds: 5), ()=>setState((){}));
    if(_tutorController.teacher.value.password == '123456'){
      Future.delayed(Duration(seconds: 5),(){
        Get.defaultDialog(
          title: 'Set New Password',
            titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
          titlePadding: EdgeInsets.symmetric(vertical: 20),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Text('WELCOME', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('${_tutorController.teacher.value.fullname}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green))
                ),
                Text('You Are Required To Change Your Password', style:TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)
                  ),
                  child: TextField(
                    controller: newPasswordController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'New Password'
                    )

                  ),
                ),
                SizedBox(height: 15,),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TouchRippleEffect(
                    onTap: (){
                      if(newPasswordController.text.isNotEmpty){
                        FirebaseFirestore.instance.collection('tutor').doc(_tutorController.teacher.value.uid)
                            .update({'password':newPasswordController.text})
                        .then((value){
                          Get.back();
                        });
                        ;
                      }
                    },
                    rippleColor: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                    ),
                  ),
                )
              ],
            )
          )
        );
      });
    }
  }

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  String assessmentID = '';

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

    String result = '';
    Methods methods = Methods();
    SelectedCourseController _selectedCourseController = Get.find();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CurrentWidget>(
      builder: (controller) {
        return Scaffold(
          key: _scaffoldState,
          body: Container(
            padding: EdgeInsets.all(0),
            child: Container(
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Kara.primary,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0))
                    ),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('institutions').doc(_tutorController.teacher.value.institutionID).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                InstitutionModel institution = InstitutionModel(
                                    uid: snapshot.data!.id,
                                    name: snapshot.data!.get('name'),
                                    admin: snapshot.data!.get('admin'),
                                    logo: snapshot.data!.get('logo'),
                                    motto: snapshot.data!.get('motto'),
                                    type: snapshot.data!.get('type'),
                                    status: snapshot.data!.get('status'),
                                    province: snapshot.data!.get('province'),
                                    district: snapshot.data!.get('district'),
                                    country: snapshot.data!.get('country'),
                                    subscriptionType: snapshot.data!.get('subscription')
                                );
                                _institutionController.updateInstitution(institution);
                                return Text('${snapshot.data!.get('name')}', style: TextStyle(color: Colors.white, fontSize: 14));
                              } else {
                                return Text('${_institutionController.institution.value.name}', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500));
                              }
                            }
                          ),
                          Spacer(),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: TouchRippleEffect(
                              onTap: () async{
                                await FirebaseFirestore.instance.collection('institutions').doc(_tutorController.teacher.value.institutionID).get()
                                    .then((value){
                                 List<String> academic_years = value.get('academic_years').map<String>((e)=>e.toString()).toList();

                                 Get.to(()=>SettingsScreen(academic_years));

                                });


                              },
                              rippleColor: Colors.grey.withOpacity(0.4),
                              child: Row(
                                children: [
                                  Icon(Icons.settings, color: Colors.white, size: 15,),
                                  SizedBox(width: 6),
                                  Text('Settings', style: TextStyle(color: Colors.white, fontSize: FontSize.mediumheadertext))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: TouchRippleEffect(
                              onTap: ()=>Get.to(()=>AboutUsPage()),
                              rippleColor: Colors.grey.withOpacity(0.4),
                              child: Row(
                                children: [
                                  Icon(Icons.info, color: Colors.white, size: 15,),
                                  SizedBox(width: 6),
                                  Text('About', style: TextStyle(color: Colors.white, fontSize: FontSize.mediumheadertext))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 30)
                        ],
                      )
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 220,
                            child: Sidebar(),
                          ),
                          Expanded(
                            child: Obx(
                                ()=> Container(
                                color: Kara.background,
                                child: currentWidget.getWidget(currentWidget.currentWidget.value)
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          )
        );
      }
    );


  }
}

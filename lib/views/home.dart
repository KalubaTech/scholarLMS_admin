import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stdominicsadmin/models/institution_model.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;
import 'package:get/get.dart';
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
import '../controllers/tutorController.dart';
import 'package:flexible_expansion_list/flexible_expansion_list.dart';
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

  TutorController _tutorController = Get.find();
  InstitutionController _institutionController = Get.find();

  String attachmentUrl = '';

  TextEditingController newPasswordController = TextEditingController();
  StudentsController _studentsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.delayed(Duration(seconds: 5), ()=>setState((){}));
    if(_tutorController.tutor.value.password == '123456'){
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
                    child: Text('${_tutorController.tutor.value.name}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green))
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
                        FirebaseFirestore.instance.collection('tutor').doc(_tutorController.tutor.value.uid)
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

    return Scaffold(
      key: _scaffoldState,
      body: Container(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              border: Border.all(color: Colors.grey,)
          ),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: kara.Colors.primary,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0))
                ),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('institutions').doc(_tutorController.tutor.value.institutionID).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            InstitutionModel institution = InstitutionModel(id: snapshot.data!.id, name: snapshot.data!.get('name'), admin: snapshot.data!.get('admin'), logo: snapshot.data!.get('logo'), motto: snapshot.data!.get('motto'),type: snapshot.data!.get('type'));
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
                            await FirebaseFirestore.instance.collection('institutions').doc(_tutorController.tutor.value.institutionID).get()
                                .then((value){
                             List<String> academic_years = value.get('academic_years').map<String>((e)=>e.toString()).toList();

                             Get.to(()=>SettingsScreen(academic_years));

                            });


                          },
                          rippleColor: Colors.grey.withOpacity(0.4),
                          child: Row(
                            children: [
                              Icon(Icons.settings, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Settings', style: TextStyle(color: Colors.white))
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
                              Icon(Icons.info, color: Colors.white),
                              SizedBox(width: 6),
                              Text('About', style: TextStyle(color: Colors.white))
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
                  child: ResizableContainer(
                    direction: Axis.horizontal,
                    children: [
                      ResizableChildData(
                        startingRatio: 0.20,
                        minSize: 150,
                        child: Container(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('assets/profile_background.webp'),
                                                fit: BoxFit.cover
                                            ),
                                        color: Colors.blue.withOpacity(0.3),
                                    )
                                  ), 
                                  Center(
                                    child: _tutorController.tutor.value.uid.isNotEmpty?Center(
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection('tutor').doc(_tutorController.tutor.value.uid).snapshots(),
                                        builder: (context, snapshot) {

                                          return snapshot.hasData&&snapshot.data!.exists?Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 30),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(150),
                                              child: CachedNetworkImage(
                                                height: 100,
                                                width: 100,
                                                imageUrl: '${snapshot.data!.get('photo')}',
                                                placeholder:(c,i)=> CircleAvatar(
                                                  radius: 50,
                                                  child: Center(child: CircularProgressIndicator()),
                                                ),
                                                errorWidget:(c,i,e)=> CircleAvatar(
                                                  radius: 50,
                                                  child: Icon(Icons.person, color: Colors.grey, size: 60,),
                                                ),
                                              ),
                                            ),
                                          ):
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                                            child: CircleAvatar(
                                              radius: 50,
                                              child: Icon(Icons.person, color: Colors.grey, size: 60,),
                                            ),
                                          );
                                        }
                                      ),
                                    ):
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                                      child: Shimmer.fromColors(
                                          baseColor: Colors.grey.withOpacity(0.2),
                                          highlightColor: Colors.grey.withOpacity(0.4),
                                        child: CircleAvatar(
                                          radius: 50
                                        )
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20, 
                                    right: 90,
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: TouchRippleEffect(
                                        onTap: (){
                                          methods.pickProfile(context);
                                        },
                                          borderRadius: BorderRadius.circular(90),
                                          rippleColor: Colors.grey.withOpacity(0.3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(90),
                                              color: Colors.white
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          child: Icon(Icons.edit, color: kara.Colors.primary)
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.shade500, blurRadius: 1, offset: Offset(0, 1))
                                        ]
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('${_tutorController.tutor.value.name}' ,style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text('${_tutorController.tutor.value.email}' ,style: TextStyle(fontSize: 11),),
                                            Divider(),
                                            MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: TouchRippleEffect(
                                                onTap: (){
                                                  Get.to(()=>MyClasses());
                                                },
                                                rippleColor: Colors.grey.withOpacity(0.3),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      border: BorderDirectional(
                                                          bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                      )
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.border_color_outlined, size: 20, color: Colors.blue.withOpacity(0.6)),
                                                      SizedBox(width: 10),
                                                      Text('My ${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'}'),
                                                      SizedBox(width: 5),
                                                      StreamBuilder(
                                                          stream: FirebaseFirestore.instance.collection('my_classes').where('tutor', isEqualTo: _tutorController.tutor.value.uid).snapshots(),
                                                          builder: (context, snapshot) {
                                                            return snapshot.hasData&&snapshot.data!.docs.isNotEmpty?Text('(${snapshot.data!.docs.map((e)=>e.get('course')).toSet().length})', style: TextStyle(fontSize: 12)):Container();
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ),
                                            _tutorController.tutor.value.email==_institutionController.institution.value.admin
                                                ?
                                            MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: TouchRippleEffect(
                                                  onTap: (){
                                                    Get.to(()=>ManageStudents());
                                                  },
                                                  rippleColor: Colors.grey.withOpacity(0.3),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        border: BorderDirectional(
                                                            bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                        )
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.school, size: 20, color: Colors.blue.withOpacity(0.6)),
                                                        SizedBox(width: 10),
                                                        Text('Manage ${_institutionController.institution.value.type=='primary'?'Pupils':'Students'}'),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            ):Container(),
                                            MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: TouchRippleEffect(
                                                  onTap: (){
                                                    Get.to(()=>ManageTimetable());
                                                  },
                                                  rippleColor: Colors.grey.withOpacity(0.3),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        border: BorderDirectional(
                                                            bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                        )
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.calendar_month_outlined, size: 20, color: Colors.blue.withOpacity(0.6)),
                                                        SizedBox(width: 10),
                                                        Text('Timetable'),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            ),
                                            Spacer(),
                                            MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: TouchRippleEffect(
                                                  onTap: ()=>Get.to(()=>ReportForms()),
                                                  rippleColor: Colors.grey.withOpacity(0.3),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        border: BorderDirectional(
                                                            bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                        )
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.chrome_reader_mode, size: 20, color: Colors.blue.withOpacity(0.6)),
                                                        SizedBox(width: 10),
                                                        Text('Report Forms'),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            ),
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance.collection('supper_admins').where('email', isEqualTo: _tutorController.tutor.value.email).snapshots(),
                                              builder: (context, snapshot) {
                                                if(snapshot.hasData&&snapshot.data!.size>0){
                                                  return MouseRegion(
                                                      cursor: SystemMouseCursors.click,
                                                      child: TouchRippleEffect(
                                                        onTap: ()=>Get.to(()=>SuperAdmin()),
                                                        rippleColor: Colors.grey.withOpacity(0.3),
                                                        child: Container(
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                              border: BorderDirectional(
                                                                  bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                              )
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.security, size: 20, color: Colors.blue),
                                                              SizedBox(width: 10),
                                                              Text('Super Admin'),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  );
                                                }else{
                                                  return Container();
                                                }
                                              }
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child:   TouchRippleEffect(
                                    borderRadius: BorderRadius.circular(20),
                                    rippleColor: Colors.greenAccent,
                                    onTap: (){
                                      GetStorage().remove('email');
                                      Get.offAll(()=>Sign()); 
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Container(
                                      width: 150,
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        color: kara.Colors.green,
                                        borderRadius: BorderRadius.circular(30)
                                      ),
                                      child: Center(
                                        child: Text('Log Out', style: TextStyle(color: Colors.white),),
                                      ),),
                                    ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ResizableChildData(
                        startingRatio: 0.60,
                        minSize: 150,
                        child: Container(
                          child: Column(
                            children: [
                              TabBar(
                                controller: _tabController,
                                  tabs: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.book, size: 16,),
                                          SizedBox(width: 20,),
                                          Text('Books', style: TextStyle(fontSize: 14),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_note_sharp, size: 20,),
                                          SizedBox(width: 15,),
                                          Expanded(child: Text('Assignments', style: TextStyle(fontSize: 14),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.feed, size: 20,),
                                          SizedBox(width: 15,),
                                          Expanded(child: Text('Results', style: TextStyle(fontSize: 14),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.newspaper, size: 20,),
                                          SizedBox(width: 15,),
                                          Expanded(child: Text('Notice Board', style: TextStyle(fontSize: 14),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                              Expanded(
                                  child: Container(
                                    child: TabBarView(
                                      controller: _tabController,
                                        children: [
                                          BooksPage(),
                                          AssessmentsPage(_scaffoldState, context),
                                          ResultsPage(),
                                          NoticeBoard(context)
                                        ] 
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      ResizableChildData(
                        startingRatio: 0.20,
                        maxSize: 450,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: kara.Colors.background,
                                    boxShadow: [
                                    BoxShadow(color: Colors.grey, blurRadius: 2)
                                  ]
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${_institutionController.institution.value.type=='primary'?'Pupils':'Students'}', style: TextStyle(fontSize: 16)),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                    MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: TouchRippleEffect(
                                            rippleColor: Colors.grey.withOpacity(0.4),
                                            onTap: ()=>Get.to(()=>ManageStudents()),
                                            child: Icon(Icons.arrow_forward)
                                        )
                                    )
                                  ],
                                )
                              ),
                              Expanded(
                                child: Container(
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('students')
                                        .where('isfreezed', isEqualTo: false)
                                        .where('institutionID', isEqualTo: _tutorController.tutor.value.institutionID)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData&&snapshot.data!.size>0) {

                                        return StreamBuilder(
                                          stream: FirebaseFirestore.instance.collection('my_classes')
                                            .where('tutor', isEqualTo: _tutorController.tutor.value.uid).snapshots(),
                                          builder: (context, snapshot1) {
                                            if(snapshot1.hasData){

                                              try{
                                                List<StudentModel> students;

                                                if (_institutionController.institution.value.admin == _tutorController.tutor.value.email) {

                                                    students = snapshot.data!.docs.map<StudentModel>((e) {
                                                      return StudentModel(
                                                        id: e.id,
                                                        displayName: e.get('displayName'),
                                                        email: e.get('email'),
                                                        photo: e.get('photo')??'',
                                                        intake: e.get('intake'),
                                                        institutionID: e.get('institutionID'),
                                                        academic_year: e.get('academic_year'),
                                                        isFreezed: e.get('isfreezed'),
                                                        programme: e.get('programme'),
                                                        gender: e.get('gender'),
                                                      );
                                                    }).toList();
                                                } else {
                                                  students = snapshot.data!.docs.where((item)=>
                                                        snapshot1.data!.docs.map((e) => e.get('programme')).toSet().toList().contains(item.get('programme')) &&
                                                        snapshot1.data!.docs.map((e) => e.get('academic_year')).toSet().toList().contains(item.get('academic_year'))
                                                    ).map<StudentModel>((e) {
                                                      return StudentModel(
                                                        id: e.id,
                                                        displayName: e.get('displayName'),
                                                        email: e.get('email'),
                                                        photo: e.get('photo')??'',
                                                        intake: e.get('intake'),
                                                        institutionID: e.get('institutionID'),
                                                        academic_year: e.get('academic_year'),
                                                        isFreezed: e.get('isfreezed'),
                                                        programme: e.get('programme'),
                                                        gender: e.get('gender'),
                                                      );
                                                    }
                                                    ).toList();
                                                }

                                                _studentsController.updateStudents(students);
                                              }catch(d){
                                                print(d);

                                              }
                                            }

                                            return ListView.builder(
                                            itemCount: snapshot.data!.size,
                                              itemBuilder: (context,index){
                                                return Column(
                                                  children: [
                                                    index==0?SizedBox(height: 10,):Container(),
                                                    ListTile(
                                                      onTap: (){
                                                     /*   FirebaseFirestore.instance.collection('students')
                                                            .doc(snapshot.data!.docs[index].id).update(
                                                            {
                                                              'programme': 'Bachelor Computer Science',
                                                              'gender':'Male',
                                                              'academic_year':'First Year',
                                                               'intake': '${snapshot.data!.docs.first.get('intake')}',
                                                                'institutionID': '${_tutorController.tutor.value.institutionID}',
                                                                'isfreezed': false,
                                                                'statusChangedTime':'2024-01-03 20:02'
                                                            }
                                                        ).then((value)=>methods.shownackbar('modified', context));*/
                                                        methods.previewStudent(snapshot.data!.docs[index]);
                                                      },
                                                      leading: ClipRRect(
                                                        borderRadius: BorderRadius.circular(40),
                                                        child: CachedNetworkImage(
                                                          width: 40,
                                                          height: 40,
                                                          imageUrl: '${snapshot.data!.docs[index].get('photo')}',
                                                          placeholder: (c,s)=>Center(child:Text('${snapshot.data!.docs[index].get('displayName')[0]}', style: TextStyle(fontSize: 20))),
                                                          errorWidget: (e,i,s)=>Container(child: Center(child:Text('${snapshot.data!.docs[index].get('displayName')[0]}', style: TextStyle(fontSize: 20)))),
                                                        ),
                                                      ),
                                                      title: Text('${snapshot.data!.docs[index].get('displayName')}', style: TextStyle(fontSize: 12),),
                                                      trailing: snapshot.data!.docs[index].get('isOnline')?
                                                      CircleAvatar(
                                                          radius: 5,
                                                          backgroundColor: Colors.green
                                                      ):Container(
                                                        width: 21,
                                                        child: Text('${timeagostr(snapshot.data!.docs[index].get('statusChangedTime'),isSubstr: true)}')
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 0.5,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                );
                                              }
                                                                                  );
                                          }
                                        );
                                      } else {
                                        return Container(
                                        child: Center(
                                          child: Text('No ${_institutionController.institution.value.type=='primary'?'Pupils':'Students'} online')
                                        )
                                      );
                                      }
                                    }
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Column(
                                      children:  [
                                        Container(
                                          height: 1,
                                          color: Colors.grey.withOpacity(0.3)
                                        ),
                                        SizedBox(height: 10),
                                        Text('Developed by Electrisite Technologies', style: TextStyle(fontSize: 10))
                                      ]
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
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
}

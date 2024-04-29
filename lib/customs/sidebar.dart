import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timetable/flutter_timetable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stdominicsadmin/controllers/current_widget.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:stdominicsadmin/controllers/teacher_controller.dart';
import 'package:stdominicsadmin/controllers/tutorController.dart';
import 'package:stdominicsadmin/customs/kalubtn.dart';
import 'package:stdominicsadmin/customs/sidebar_list_item.dart';
import 'package:stdominicsadmin/helpers/methods.dart';
import 'package:stdominicsadmin/views/pages/dashboard/dashboard.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:get/get.dart';
import '../styles/colors.dart';
import '../styles/font_sizes.dart';
import '../views/admin/manage_students.dart';
import '../views/admin/super_admin.dart';
import '../views/admin/timetable.dart';
import '../views/my_classes.dart';
import '../views/report_forms.dart';
import '../views/sign_in.dart';

class Sidebar extends StatelessWidget {
  Sidebar({super.key});

  Methods methods = Methods();

  TeacherController _tutorController = Get.find();
  InstitutionController _institutionController = Get.find();

  CurrentWidget currentWidget = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      color: Kara.primary2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Stack(
                  children: [
                    _tutorController.teacher.value.uid.isNotEmpty?Center(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('tutor').doc(_tutorController.teacher.value.uid).snapshots(),
                          builder: (context, snapshot) {

                            return snapshot.hasData&&snapshot.data!.exists?Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  height: 50,
                                  width: 50,
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
                                child: Icon(Icons.person, color: Colors.grey, size: 50,),
                              ),
                            );
                          }
                      ),
                    ):
                    Container(),
                    Positioned(
                      bottom: 10,
                      right: 10,
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
                              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                              child: Icon(Icons.edit, color: Kara.primary, size: 10,)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_tutorController.teacher.value.fullname}' ,style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 10),),
                      Text('${_tutorController.teacher.value.email}' ,style: TextStyle(fontSize: 9, color: Kara.secondary),),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: BorderDirectional(top: BorderSide(color: Color(
                          0xFA575D69))),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: 20,),
                        SidebarListItem(
                            icon: Icon(Icons.dashboard, size: 15, color: Colors.grey.withOpacity(0.6)),
                            title: 'Dashboard',
                            onclick: (){
                                currentWidget.currentWidget.value = 'Dashboard';
                            }
                        ),
                        SidebarListItem(
                            icon: Icon(Icons.open_in_new, size: 15, color: Colors.grey.withOpacity(0.6)),
                            title: 'My ${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'}',
                            onclick: ()=>currentWidget.currentWidget.value = 'My ${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'}',
                            suffix: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('my_classes').where('tutor', isEqualTo: _tutorController.teacher.value.uid).snapshots(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData&&snapshot.data!.docs.isNotEmpty?Text('${snapshot.data!.docs.map((e)=>e.get('course')).toSet().length}', style: TextStyle(fontSize: FontSize.mediumheadertext, color: Kara.secondary)):Container();
                                }
                            ),
                        ),
                        _tutorController.teacher.value.email==_institutionController.institution.value.admin
                            ?
                            SidebarListItem(
                                icon: Icon(Icons.group, size: 15, color: Colors.grey.withOpacity(0.6)),
                                title: 'Manage Students',
                                onclick: ()=>currentWidget.currentWidget.value = 'Manage Students',
                            ):Container(),
                        SidebarListItem(
                            icon: Icon(Icons.calendar_month_outlined, size: 15, color: Colors.grey.withOpacity(0.6)),
                            title: 'Timetable',
                            onclick: ()=>currentWidget.currentWidget.value = 'Timetable',
                        ),
                        SidebarListItem(
                            icon: Icon(Icons.chrome_reader_mode, size: 15, color: Colors.grey.withOpacity(0.6)),
                            title: 'Report Forms',
                            onclick: ()=>currentWidget.currentWidget.value = 'Report Forms',
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('supper_admins').where('email', isEqualTo: _tutorController.teacher.value.email).snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData&&snapshot.data!.size>0){
                                return     SidebarListItem(
                                    icon: Icon(Icons.admin_panel_settings, size: 15, color: Colors.grey.withOpacity(0.6)),
                                    title: 'Super Admin',
                                    onclick: ()=>Get.to(()=>SuperAdmin())
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
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Kalubtn(
                      label: 'Log Out',
                      height: 25,
                      width: 100,
                      padding: EdgeInsets.zero,
                      labelStyle: TextStyle(color: Kara.secondary, fontSize: FontSize.primarytext),
                      backgroundColor: Kara.primary2,
                      borderRadius: 20,
                      border: Border.all(width: 1, color: Color(
                          0xFA575D69)),
                      onclick: (){
                        GetStorage().remove('email');
                        Get.offAll(()=>Sign());
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

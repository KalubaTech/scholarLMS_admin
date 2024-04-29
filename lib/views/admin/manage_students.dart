import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/utils/form_validation.dart';
import 'package:stdominicsadmin/controllers/selectedItemsController.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:stdominicsadmin/controllers/students_controller.dart';
import 'package:stdominicsadmin/customs/content_wrapper.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import '../../customs/StudentCard.dart';
import 'package:get/get.dart';

import '../../customs/pupil_registration_form.dart';
import '../../customs/student_registration_form.dart';
import '../../helpers/methods.dart';
import '../../models/student_model.dart';

class ManageStudents extends StatefulWidget {
  const ManageStudents({Key? key}) : super(key: key);

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {

    StudentsController _studentsController = Get.find();

  String selectedIntake = "";
  String selectedAcademicYear = "";
  String selectedProgramme = "";
  bool isAllSelected = false;

  SelectedStudentsController selectedStudents = SelectedStudentsController();

  InstitutionController _institutionController = Get.find();
  
  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        children: [
          Expanded(child: ContentWrapper())
        ],
      ),
    )

      /*Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Kara.primary,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.arrow_back, color: Colors.white)),
                        Text('MANAGE ${_institutionController.institution.value.type=='primary'?'PUPILS':'STUDENTS'}', style: TextStyle(color: Kara.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Kara.green)
                      ),
                      child: Text('Add ${_institutionController.institution.value.type=='primary'?'Pupil':'Student'}', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Kara.background,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,

                            )
                          ]
                        ),
                        height: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: _studentsController.students.value.where(
                                        (element) =>
                                    (

                                        (selectedAcademicYear == ''? true :
                                        (element.academic_year == selectedAcademicYear))  &&
                                            (selectedProgramme == '' ? true :
                                            (element.programme==selectedProgramme))
                                            &&
                                            (selectedIntake == '' ? true :
                                            (element.intake==selectedIntake))
                                    ) && !element.isFreezed

                                ).toList().isNotEmpty?CheckboxListTile(value: isAllSelected, onChanged: (value)
                                {
                                  List<String> selectedAllStudents
                                  = _studentsController.students.value.where(
                                          (element) =>
                                      (
                                          (selectedAcademicYear == ''? true :
                                          (element.academic_year == selectedAcademicYear))  &&
                                              (selectedProgramme == '' ? true :
                                              (element.programme==selectedProgramme))
                                              &&
                                              (selectedIntake == '' ? true :
                                              (element.intake==selectedIntake))
                                      )

                                  ).toList().map<String>((e) => e.id.toString()).toList();


                                  setState(() {
                                    isAllSelected = value!;

                                    if(value!){
                                      selectedStudents.selectAll(selectedAllStudents);

                                    }else{
                                      selectedStudents.unSelectAll();
                                    }

                                  });
                                },
                                  title: Text('Select all'),):CheckboxListTile(value: false, onChanged: (value)
                                {

                                },
                                  title: Text('Select all', style: TextStyle(color: Colors.grey),),)
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Obx(()=>TouchRippleEffect(
                                borderRadius: BorderRadius.circular(5),
                                rippleColor: Colors.grey.withOpacity(0.4),
                                  onTap: ()async{
                                    if (selectedStudents.selectedItems.value.isNotEmpty) {
                                      for (int i = 0; i < selectedStudents.selectedItems.length; i++) {
                                        String studentId = selectedStudents.selectedItems.value[i];

                                        await FirebaseFirestore.instance.collection('students')
                                            .doc(studentId).update({
                                          'isfreezed': true
                                        }).then((value) {
                                          int index = _studentsController.students.value
                                              .indexWhere((element) => element.id == studentId);

                                          if (index != -1) {
                                            _studentsController.students.value[index].isFreezed = true;
                                          }
                                        });
                                      }
                                    }else{
                                      return null;
                                    }
                                    _methods.shownackbar('${selectedStudents.selectedItems.length} students deactivated successfully!', context);
                                    setState(() {

                                    });
                                  },
                                    child:   MouseRegion(
                                        cursor: selectedStudents.selectedItems.value.isNotEmpty?SystemMouseCursors.click:SystemMouseCursors.forbidden,
                                        child: Container(
                                          margin: EdgeInsets.all(20),
                                          height: 30,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: selectedStudents.selectedItems.value.isNotEmpty?Kara.red:Kara.grey,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 2,
                                                ),
                                              ],
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Center(
                                            child: Text('Deactivate', style: TextStyle(color: Colors.white),),
                                          ),
                                        )),)

                                ),
                              ),
                            Container(
                              child: TextButton(
                                  onPressed: (){
                                    Get.bottomSheet(
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 15),
                                                  Expanded(child: Container(child: Text('Deativated', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)))),
                                                  Container(
                                                    width: 100,
                                                    child: TextButton(
                                                        onPressed: (){

                                                        },
                                                        child: Text('Activate All')
                                                    )
                                                  ),
                                                  SizedBox(width: 15),
                                                ],
                                              )
                                            ),
                                            Expanded(
                                              child: StatefulBuilder(
                                                builder: (context, state) {
                                                  return Container(
                                                    child: StreamBuilder(
                                                        stream: FirebaseFirestore.instance.collection('students').where('isfreezed', isEqualTo: true).where('institutionID', isEqualTo:_institutionController.institution.value.id).snapshots(),
                                                        builder: (context,snapshot)=>
                                                            snapshot.hasData?ListView.builder(
                                                          itemCount: snapshot.data!.size,
                                                          itemBuilder: (context, index){
                                                            StudentModel student = StudentModel(id: snapshot.data!.docs[index].id, displayName: snapshot.data!.docs[index].get('displayName'), email: snapshot.data!.docs[index].get('email'), photo: snapshot.data!.docs[index].get('photo')??'', institutionID: snapshot.data!.docs[index].get('institutionID'), gender: snapshot.data!.docs[index].get('gender'), programme: snapshot.data!.docs[index].get('programme'), isFreezed: snapshot.data!.docs[index].get('isfreezed'), academic_year: snapshot.data!.docs[index].get('academic_year'), intake: snapshot.data!.docs[index].get('intake'));
                                                            return Column(
                                                              children: [
                                                                ListTile(
                                                                  leading: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(40),
                                                                    child: CachedNetworkImage(
                                                                      width: 40,
                                                                      height: 40,
                                                                      imageUrl: '${student.photo}',
                                                                      errorWidget: (e,i,c)=>CircleAvatar(foregroundImage: AssetImage('assets/user-avater.png'),),
                                                                    ),
                                                                  ),
                                                                  title: Text('${student.displayName}'),
                                                                  subtitle: Text('${student.programme}, ${student.academic_year}'),
                                                                  trailing: TextButton(
                                                                    onPressed: (){
                                                                      FirebaseFirestore.instance.collection('students')
                                                                          .doc(student.id).update({
                                                                        'isfreezed': false
                                                                      }).then((value) {
                                                                        int index1 = _studentsController.students.value
                                                                            .indexWhere((element) => element.id == student.id);

                                                                        if (index1 != -1) {
                                                                          _studentsController.students.value[index1].isFreezed = false;
                                                                          _studentsController.update();
                                                                          setState(() {

                                                                          });
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Text('Activate')
                                                                  ),
                                                                ),
                                                                Container(color: Colors.grey.withOpacity(0.2), height: 0.5)
                                                              ],
                                                            );
                                                          }
                                                      ):Container(),
                                                    )
                                                  );
                                                }
                                              )
                                            )
                                          ]
                                        )
                                      ),
                                      backgroundColor: Colors.white
                                    );
                                  },
                                  child: Text('Deactivated ${_institutionController.institution.value.type=='primary'?'Pupils':'Students'}'))

                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child:LayoutBuilder(
                          builder: (context,box)=>Container(
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Kara.background,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1
                                      )
                                    ]
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Intake: ', style: TextStyle(color: Colors.grey),),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: 90,
                                            child: DropdownSearch<String>(
                                              items: [
                                                'All',
                                                ... _studentsController.students.value.map((e) => e.intake).toSet().toList()
                                              ],
                                              popupProps: PopupPropsMultiSelection.menu(
                                                fit: FlexFit.loose,
                                                showSelectedItems: true,
                                              ),
                                              selectedItem: selectedIntake,
                                              onChanged: (value){
                                                setState(() {
                                                  selectedIntake = value == 'All' ? '' : value!;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Text('${_institutionController.institution.value.type=='primary'?'Class':'Programme'}: ', style: TextStyle(color: Colors.grey),),
                                          SizedBox(width: 5),
                                          SizedBox(
                                            width: 200,
                                            child: DropdownSearch<String>(
                                              items: [
                                                'All',
                                                ... _studentsController.students.value.map((e) => e.programme).toSet().toList()
                                              ],
                                              popupProps: PopupPropsMultiSelection.menu(
                                                fit: FlexFit.loose,
                                                showSelectedItems: true,
                                              ),
                                              selectedItem: selectedProgramme,
                                              onChanged: (value){
                                                setState(() {
                                                  selectedProgramme = value == 'All' ? '' : value!;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Text('${_institutionController.institution.value.type=='primary'?'Grade':'Academic Year'}: ', style: TextStyle(color: Colors.grey),),
                                          SizedBox(width: 5),
                                          SizedBox(
                                            width: 150,
                                            child: DropdownSearch<String>(
                                              items: [
                                                'All',
                                                ... _studentsController.students.value.map((e) => e.academic_year).toSet().toList()
                                              ],
                                              popupProps: PopupPropsMultiSelection.menu(
                                                fit: FlexFit.loose,
                                                showSelectedItems: true,
                                              ),
                                              selectedItem: selectedAcademicYear,
                                              onChanged: (value){
                                                setState(() {
                                                  selectedAcademicYear = value == 'All' ? '' : value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Obx(() {
                                              return selectedStudents.selectedItems.isNotEmpty?Row(
                                                children: [
                                                  Text('Selected ${selectedStudents.selectedItems.value.length - _studentsController.students.value.where((element) => element.isFreezed).length}')
                                                ],
                                              ):Text('');
                                            }
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    child: GridView(
                                        children: _studentsController.students.value.where(
                                                (element) =>
                                                (

                                                    (selectedAcademicYear == ''? true :
                                                    (element.academic_year == selectedAcademicYear))  &&
                                                        (selectedProgramme == '' ? true :
                                                    (element.programme==selectedProgramme))
                                                        &&
                                                        (selectedIntake == '' ? true :
                                                    (element.intake==selectedIntake))
                                                ) && !element.isFreezed

                                        ).toList().map((e) =>
                                            StudentCard(student: e, isSelected: isAllSelected, controller:selectedStudents)).toList(),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: box.maxWidth<1070 ? 3 : 5,
                                            mainAxisExtent: 75,
                                            mainAxisSpacing: 20,
                                            crossAxisSpacing: 20
                                        ),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ),
                      SizedBox(width: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2
                            )
                          ]
                        ),
                        child: _institutionController.institution.value.type=='primary'
                            ?PupilRegistrationForm():StudentRegistrationForm(),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        )
      )
    )*/;
  }
}

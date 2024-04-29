import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:stdominicsadmin/helpers/methods.dart';
import 'package:stdominicsadmin/models/student_model.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import '../../controllers/selectedCourseController.dart';
import '../../controllers/students_controller.dart';
import '../../controllers/tutorController.dart';
import '../../controllers/institution_controller.dart';
import '../../customs/custom_button.dart';
import '../../helpers/creds.dart';



class ResultsPage extends StatefulWidget {



  ResultsPage();

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  Methods _methods = Methods();
  TutorController _tutorController = Get.find();
  InstitutionController _institutionController = Get.find();
  StudentsController _studentsController = Get.find();

  StudentModel? selectedStudent;
  String selectedReason = "";

  TextEditingController reasonController = TextEditingController();
  TextEditingController marksController = TextEditingController();

  SelectedCourseController _selectedCourseController = Get.find();

  @override
  Widget build(BuildContext context) {

    return Container(
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 112,
                  decoration: BoxDecoration(
                    color: Kara.background,
                      borderRadius: BorderRadius.circular(0)
                  ),
                  child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_institutionController.institution.value.type=='primary'?'Subject':'Course'}'),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: _tutorController.tutor.value.courses.isNotEmpty? StreamBuilder(
                                  stream: FirebaseFirestore.instance.
                                  collection('my_classes')
                                      .where('tutor',
                                      isEqualTo: _tutorController.tutor.value.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData ?
                                    CustomButton(
                                        Text('Select ${Creds().coursesubect()}', style: TextStyle(color: Colors.white)),
                                        width: 130,
                                        onTap: (){
                                          Get.defaultDialog(
                                              title: 'Select ${Creds().coursesubect()}',
                                              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Kara.primary),
                                              titlePadding: EdgeInsets.symmetric(vertical: 20),
                                              content: Container(
                                                height: 250,
                                                width: 250,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot.data!.docs.map<Widget>((e) =>
                                                      TouchRippleEffect(
                                                        rippleColor: Colors.grey.withOpacity(0.3),
                                                        onTap: (){
                                                          _selectedCourseController.selectedCourse.value = e.get('course');
                                                          setState(() {

                                                          });
                                                          Get.back();
                                                        },
                                                        child: MouseRegion(
                                                          cursor: SystemMouseCursors.click,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: BorderDirectional(bottom: BorderSide(color: Colors.grey.withOpacity(0.2)))
                                                            ),
                                                            child: DropdownMenuItem(
                                                                value: e.get('course'),
                                                                child: Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                    child: Text(e.get('course'))
                                                                )),
                                                          ),
                                                        ),
                                                      )
                                                  ).toSet().toList(),
                                                ),
                                              )
                                          );
                                        }
                                    ):Container();

                                  }
                              ):Container(),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_institutionController.institution.value.type=='primary'?'Pupil':'Student'}'),
                              TouchRippleEffect(
                                onTap: (){
                                  Get.defaultDialog(
                                      title: 'Select ${_institutionController.institution.value.type=='primary'?'Pupil':'Student'}',
                                      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      content: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10
                                          ),
                                          width: 350,
                                          height: 400,
                                          child: SearchableList(
                                              initialList: _studentsController.students.value,
                                              builder: (users,i,user) {
                                                return MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: TouchRippleEffect(
                                                    rippleColor: Colors.grey.withOpacity(0.4),
                                                    onTap: (){
                                                      Get.back();
                                                      setState((){
                                                        selectedStudent = user;
                                                      });
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            border: BorderDirectional(bottom: BorderSide(color: Colors.grey))
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius: BorderRadius.circular(60),
                                                                child: CachedNetworkImage(
                                                                  width: 30,
                                                                  height: 30,
                                                                  imageUrl: '${user.photo}',
                                                                  errorWidget: (c,i,e)=> CircleAvatar(
                                                                      radius:30 ,
                                                                      child: Icon(Icons.person)
                                                                  ),
                                                                )
                                                            ),
                                                            SizedBox(width: 20),
                                                            Expanded(child: Text(user.name)),
                                                          ],
                                                        )
                                                    ),
                                                  ),
                                                );
                                              },
                                              filter: (value) => _studentsController.students.value.where((element) => element.name.toLowerCase().contains(value),).toList(),
                                              emptyWidget:  Container(),
                                              inputDecoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                                labelText: "Search",
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                              )
                                          ),
                                        ),
                                      )
                                  );
                                },
                                rippleColor: Colors.grey.withOpacity(0.3),
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(child: Text('${selectedStudent == null ? "Select ${_institutionController.institution.value.type=='primary'?'Pupil':'Student'}":selectedStudent!.name}', overflow: TextOverflow.ellipsis)),
                                      ],
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Marks'),
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  width: 100,
                                  child: TextField(
                                      controller: marksController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Mark',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10)
                                      )
                                  )
                              )
                            ]
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text('Assessment')),
                                  TouchRippleEffect(
                                      onTap: (){
                                        Get.defaultDialog(
                                            title: 'Add Result Reason',
                                            titleStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                            titlePadding: EdgeInsets.symmetric(vertical: 20),
                                            content: Container(
                                                height: 300,
                                                width: 300,
                                                child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.grey),
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                                height: 50,
                                                                child: TextField(
                                                                    controller: reasonController,
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: 'Assessment / Question',
                                                                        contentPadding: EdgeInsets.symmetric(horizontal: 10)
                                                                    )
                                                                )
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          MouseRegion(
                                                            cursor: SystemMouseCursors.click,
                                                            child: TouchRippleEffect(
                                                              onTap:(){
                                                                reasonController.text.isNotEmpty?FirebaseFirestore.instance.collection('results_reason').add({
                                                                  'reason': reasonController.text,
                                                                  'institutionID':_tutorController.tutor.value.institutionID
                                                                }).then((e)=>reasonController.text=""):null;
                                                              },
                                                              rippleColor: Colors.green,
                                                              borderRadius: BorderRadius.circular(10),
                                                              child: Container(
                                                                  height: 50,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      color: Kara.green,
                                                                      borderRadius: BorderRadius.circular(10)
                                                                  ),
                                                                  child: Center(
                                                                      child: Text('Save', style: TextStyle(color: Colors.white))
                                                                  )
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: StreamBuilder(
                                                            stream: FirebaseFirestore.instance.collection('results_reason').where('institutionID', isEqualTo: _tutorController.tutor.value.institutionID).snapshots(),
                                                            builder: (context, snapshot) {
                                                              return snapshot.hasData&&snapshot.data!.size>0?Container(
                                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                  child: ListView.builder(
                                                                      shrinkWrap: true,
                                                                      itemCount: snapshot.data!.size,
                                                                      itemBuilder: (context,index){
                                                                        return Container(
                                                                            width: double.infinity,
                                                                            child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text('${snapshot.data!.docs[index].get('reason')}', style: TextStyle(fontSize: 10)),
                                                                                  MouseRegion(
                                                                                      cursor: SystemMouseCursors.click,
                                                                                      child: TouchRippleEffect(
                                                                                          onTap:(){
                                                                                            FirebaseFirestore.instance.collection('results_reason').doc(snapshot.data!.docs[index].id).delete().then((value){
                                                                                              _methods.shownackbar('Deleted Successfully!', context);
                                                                                            });
                                                                                          },
                                                                                          rippleColor: Colors.grey,
                                                                                          child: Icon(Icons.delete, color: Colors.red)
                                                                                      )
                                                                                  )
                                                                                ]
                                                                            )
                                                                        );
                                                                      }
                                                                  )
                                                              ):Container();
                                                            }
                                                        ),
                                                      ),

                                                    ]
                                                )
                                            )
                                        );
                                      },
                                      rippleColor: Colors.grey.withOpacity(0.3),
                                      child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Text('add', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline))
                                      )
                                  )
                                ],
                              ),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('results_reason')
                                    .
                                     where('institutionID', isEqualTo: _institutionController.institution.value.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData&&snapshot.data!.size>0?Container(
                                      width: 150,
                                      height: 50,
                                      child: DropdownSearch<String>(
                                        items: snapshot.data!.docs.map<String>((e) => e.get('reason').toString()).toList(),
                                        popupProps: PopupPropsMultiSelection.menu(
                                          fit: FlexFit.loose,
                                          showSelectedItems: true,
                                        ),
                                        selectedItem: snapshot.data!.docs.map<String>((e) => e.get('reason').toString()).toList().first,
                                        onChanged: (value){
                                          setState(() {
                                            selectedReason = value!;
                                          });
                                        },
                                      )
                                  ):Container();
                                }
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            SizedBox(height: 20),
                            TouchRippleEffect(
                              onTap: (){
                                if (marksController.text.isNotEmpty) {
                                  FirebaseFirestore.instance.collection('results').add(
                                      {
                                        'student':selectedStudent!.email,
                                        'student_id':selectedStudent!.uid,
                                        'course':_selectedCourseController.selectedCourse.value,
                                        'marks':marksController.text,
                                        'reason':selectedReason,
                                        'academic_year': selectedStudent!.academicYear,
                                        'tutor': _tutorController.tutor.value.uid,
                                        'datetime':'${DateTime.now()}'
                                      }
                                  ).then((value){
                                    marksController.text = '';
                                    // Display Snackbar when the button is pressed
                                    _methods.shownackbar('Successful!', context);
                                  });
                                }
                              },
                              rippleColor: Colors.green,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                    width: 100,
                                    height: 49,
                                    decoration: BoxDecoration(
                                        color: Kara.green,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Center(
                                            child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                        )
                                    ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]
                  )
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(

                    ),
                    child:  Container(
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${_institutionController.institution.value.type=='primary'?'Subject':'Course'}'),
                                  Obx(()=>Text(_selectedCourseController.selectedCourse.value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                ],
                              )
                          ),
                          Expanded(
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('results').where('course', isEqualTo: _selectedCourseController.selectedCourse.value).where('reason', isEqualTo: selectedReason).snapshots(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData&&snapshot.data!.docs.isNotEmpty?
                                  DataTable2(
                                      columnSpacing: 12,
                                      horizontalMargin: 12,
                                      minWidth: 600,
                                      columns: [
                                        DataColumn2(
                                          label: Text('SN', style: TextStyle(fontWeight: FontWeight.bold),),
                                          size: ColumnSize.S,
                                        ),
                                        DataColumn(
                                          label: Text('${_institutionController.institution.value.type=='primary'?'Pupil':'Student'}', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn(
                                          label: Text('Marks', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn(
                                          label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn(
                                          label: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                          snapshot.data!.docs.length,
                                              (index) {

                                            String formattedDate1 = DateFormat('EEE, dd MMM yyyy HH:mm').format(DateTime.parse(snapshot.data!.docs[index].get('datetime')));
                                            return DataRow(cells: [
                                              DataCell(Text('${index+1}', style: TextStyle(fontSize: 12))),
                                              DataCell(StreamBuilder(
                                                  stream: FirebaseFirestore.instance.collection('students').doc(snapshot.data!.docs[index].get('student_id')).snapshots(),
                                                  builder: (context, snapshot1) {
                                                    return snapshot1.hasData?Text('${snapshot1.data!.get('displayName')}', style: TextStyle(fontSize: 12)):Container();
                                                  }
                                              )),
                                              DataCell(Text('${snapshot.data!.docs[index].get('marks')}', style: TextStyle(fontSize: 12))),
                                              DataCell(Text('${formattedDate1}', style: TextStyle(fontSize: 12)),),
                                              DataCell(
                                                  MouseRegion(
                                                      cursor: SystemMouseCursors.click,
                                                      child: TouchRippleEffect(
                                                          onTap:(){
                                                            FirebaseFirestore.instance.collection('results').doc(snapshot.data!.docs[index].id).delete().then((value){
                                                              _methods.shownackbar('Deleted Successfully!', context);
                                                            });
                                                          },
                                                          rippleColor: Colors.grey,
                                                          child: Icon(Icons.delete, color: Colors.red)
                                                      )
                                                  )
                                              )
                                            ]);
                                          })):
                                  Container();
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ]
        )
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/students_controller.dart';
import 'admin/generate_statement.dart';

class ReportForms extends StatefulWidget {
  const ReportForms({Key? key}) : super(key: key);

  @override
  State<ReportForms> createState() => _ReportFormsState();
}

class _ReportFormsState extends State<ReportForms> {
  String selectedStudent = '';
  String selectedName = '';
  String selectedYear = '';
  String selectedReason = '';
  String selectedProgramme = '';
  String selectedAcademicYear = '';


  InstitutionController _institutionController = Get.find();
  StudentsController _studentsController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: kara.Colors.primary,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))
                ),
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TouchRippleEffect(
                        onTap: ()=>Get.back(),
                        rippleColor: Colors.grey.withOpacity(0.4),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back, color: Colors.white),
                            SizedBox(width: 10,),
                            Text('Back', style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.withOpacity(0.06),
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: [
                       Container(
                         margin: EdgeInsets.only(left: 10),
                         padding: EdgeInsets.symmetric(vertical: 20),
                        height: double.infinity,
                        width: 300,
                        child: SearchableList(
                            shrinkWrap: true,
                            initialList: _studentsController.students.value,
                            builder: (users,i,user) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: TouchRippleEffect(
                                  rippleColor: Colors.grey.withOpacity(0.4),
                                  onTap: (){

                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: selectedStudent == user.id?Colors.grey.withOpacity(0.06):Colors.white
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                                          Expanded(child: Text(user.displayName)),
                                          Container(
                                            width: 30,
                                            child: RadioListTile(value: selectedStudent == user.id?true:false, groupValue: true, onChanged: (value){
                                              setState(() {
                                                selectedStudent = user.id;
                                                selectedName = user.displayName;
                                                selectedProgramme = user.programme;
                                              });
                                            }),
                                          )
                                        ],
                                      )
                                  ),
                                ),
                              );
                            },
                            filter: (value) => _studentsController.students.where((element) => element.displayName.toLowerCase().contains(value),).toList(),
                            emptyWidget:  Container(
                              child: Center(
                                child: Text('No results'),
                              ),
                            ),
                            inputDecoration: InputDecoration(
                              labelText: "Search",
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: kara.Colors.primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(1.0),

                              ),
                            )
                        ),
                      ),
                       Expanded( 
                         child: Container(
                           margin: EdgeInsets.symmetric(vertical: 20),
                           padding: EdgeInsets.symmetric(vertical: 15),
                           decoration: BoxDecoration(

                           ),
                           child: StreamBuilder(
                             stream: FirebaseFirestore.instance.collection('results').where('student_id', isEqualTo: '$selectedStudent').snapshots(),
                             builder: (context, snapshot) {
                               return snapshot.hasData && snapshot.data!.size>0
                                   ? Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     margin: EdgeInsets.only(left: 20),
                                     padding: EdgeInsets.symmetric(horizontal: 20),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text('RESULTS', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 22),),
                                         Text('Recorded results for ${selectedName}', style: TextStyle(color: kara.Colors.primary),),
                                         SizedBox(height: 20,),
                                         Row(
                                           children: [
                                             Container(
                                               width: 150,
                                               child: DropdownSearch<String>(
                                                 items: [
                                                   ... snapshot.data!.docs.map((e) => e.get('academic_year')).toSet().toList()
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
                                               )
                                             )
                                           ]
                                         ),
                                         SizedBox(height: 10),
                                         MouseRegion(
                                           cursor: SystemMouseCursors.click,
                                           child: TouchRippleEffect(
                                             onTap: (){
                                               Get.defaultDialog(
                                                 title: 'Select Assessment',
                                                 titlePadding: EdgeInsets.symmetric(vertical: 10),
                                                 titleStyle: TextStyle(
                                                   fontSize: 14,
                                                   fontWeight: FontWeight.bold,
                                                   color: kara.Colors.primary
                                                 ),
                                                 content: Container(
                                                   child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: snapshot.data!.docs.map((e) =>
                                                         e.get('reason')).toSet()
                                                         .toList().map((e) =>
                                                         CheckboxListTile(
                                                             value: selectedReason==e?true:false,
                                                             title: Text(e),
                                                             onChanged: (value){
                                                               setState(() {
                                                                 selectedReason = e;
                                                               });
                                                               Get.back();
                                                             }
                                                         )
                                                     ).toList(),
                                                   ),
                                                 )
                                               );
                                             },
                                             rippleColor: Colors.grey.withOpacity(0.4),
                                             borderRadius: BorderRadius.circular(5),
                                             child: Container(
                                                 width: 300,
                                                 decoration: BoxDecoration(
                                                     color: Colors.white,
                                                     boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 2, offset: Offset(1, 2))],
                                                     borderRadius: BorderRadius.circular(5)
                                                 ),
                                                 padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                 child: Row(
                                                   children: [
                                                     Expanded(child: Text('${selectedReason.isEmpty?'Assessment':selectedReason}')),
                                                     Icon(Icons.arrow_drop_down_circle_outlined)
                                                   ],
                                                 )
                                             ),
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                   SizedBox(height: 10),
                                   Expanded(
                                     child: Container(
                                       margin: EdgeInsets.only(left: 20),
                                       child: DataTable(
                                           columns: [
                                             DataColumn(label: Text('${_institutionController.institution.value.type == 'primary'?'Subject':'Course'}')),
                                             DataColumn(label: Text('Marks')),
                                             DataColumn(label: Text('Grade')),
                                           ],
                                           rows: snapshot.data!.docs
                                                 .where(
                                                   (element) =>
                                                   element.get('reason')==selectedReason &&
                                                   element.get('academic_year') == selectedAcademicYear
                                           ).map<DataRow>((e)
                                           => DataRow(cells: [
                                             DataCell(Text('${e.get('course')}'.toUpperCase())),
                                             DataCell(Text('${e.get('marks')}')),
                                             DataCell(
                                                 StreamBuilder(
                                                     stream: FirebaseFirestore.instance.collection('grading_system')
                                                     .where('institutionID', isEqualTo: _institutionController.institution.value.id)
                                                     .snapshots(), 
                                                     builder: (context,snapshot){
                                                       if (snapshot.hasData && snapshot.data!.docs.length>0) {

                                                         List<DocumentSnapshot> n = snapshot.data!.docs.where((grading) =>
                                                             int.parse(e.get('marks'))>=int.parse(grading.get('from')) &&
                                                                 int.parse(e.get('marks'))<=int.parse(grading.get('to'))
                                                         ).toList();

                                                         return n.isNotEmpty?Text('${n.first.get('grade')}'):Text('not defined');
                                                       } else {
                                                         return Text('Not set');
                                                       }
                                                     }
                                                 )),
                                           ])
                                           ).toList(),
                                         horizontalMargin: 20,
                                       ),
                                     ),
                                   ),
                                   Container(
                                     margin: EdgeInsets.only(left: 20),
                                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(2)
                                     ),
                                     child: Row(
                                       children: [
                                         TouchRippleEffect(
                                           onTap: () async{
                                             final snapshot = await FirebaseFirestore.instance.collection('results')
                                             .where('student_id', isEqualTo: selectedStudent)
                                             .where('academic_year', isEqualTo: selectedAcademicYear)
                                             .get();


                                             Get.to((){
                                             return StatementGenerate(
                                                 studentName: selectedName,
                                                 studentID: selectedStudent,
                                                 assignment: selectedReason,
                                                 academic_year: selectedAcademicYear,
                                                 gradingSystem: [],
                                                 programme: selectedProgramme,
                                                 data: snapshot
                                               );
                                           });
                                           },
                                           rippleColor: Colors.grey.withOpacity(0.4),
                                           borderRadius: BorderRadius.circular(5),
                                           child: MouseRegion(
                                             cursor: SystemMouseCursors.click,
                                             child: Container(
                                               height: 30,
                                               padding: EdgeInsets.symmetric(horizontal: 20),
                                               decoration: BoxDecoration(
                                                 color: kara.Colors.primary,
                                                 borderRadius: BorderRadius.circular(5),
                                                 boxShadow: [
                                                   BoxShadow(color: Colors.black, )
                                                 ]
                                               ),
                                               child: Center(child: Text('Generate Statement', style: TextStyle(color: Colors.white),))
                                             ),
                                           ),
                                         )
                                       ]
                                     )
                                   )
                                 ],
                               )
                                   : Container();
                             }
                           ),
                         ),
                       ),
                       Expanded(
                         child: Container(
                             padding: EdgeInsets.all(10),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.end,
                               children: [
                                 Container(
                                   width: 250,
                                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                     decoration: BoxDecoration(
                                         color: kara.Colors.background,
                                         boxShadow: [
                                           BoxShadow(
                                               color: Colors.black38,
                                               blurRadius: 2,
                                           )
                                         ]
                                     ),
                                     child: Center(child: Text('Grading System'))
                                 ),
                                 /*Expanded(
                                   child: StreamBuilder(
                                     stream: FirebaseFirestore.instance.collection('results')
                                         .where('student', isEqualTo: selectedStudent)
                                         .snapshots(),
                                     builder: (context, snapshot) {
                                       int count = 0;
                                       return snapshot.hasData&&snapshot.data!.docs.isNotEmpty?Column(
                                         children: [
                                           Container(
                                             width: 300,
                                             height: 240,
                                             padding: EdgeInsets.all(10),
                                             child: BarChart(
                                                 BarChartData(
                                                     titlesData: FlTitlesData(
                                                       leftTitles: AxisTitles(
                                                         axisNameWidget: Text('Marks')
                                                       ),
                                                       bottomTitles: AxisTitles(
                                                         axisNameWidget: Text('Courses')
                                                       )
                                                     ),
                                                   maxY: 100,
                                                   barGroups: snapshot.data!.docs.map<BarChartGroupData>((e) {
                                                     return BarChartGroupData(
                                                         x:count++,
                                                         groupVertically: true,
                                                         barRods: [
                                                           BarChartRodData(
                                                               toY: double.parse(e.get('marks')),
                                                               width: 10,

                                                           )
                                                         ]
                                                     );
                                                   },
                                                   ).toList()
                                                 )
                                             ),
                                           ),
                                         ],
                                       ):Container();
                                     }
                                   )
                                 ),*/  //REMEMBER TO ADD A RATIONAL CHART HERE
                                 SizedBox(height: 20),
                                 Container(
                                   margin: EdgeInsets.only(right: 30),
                                   child: Container(
                                       child: StreamBuilder(
                                         stream: FirebaseFirestore.instance
                                             .collection('grading_system').where('institutionID', isEqualTo: _institutionController.institution.value.id)
                                             
                                             .snapshots(),
                                         builder: (BuildContext context, snapshot) {
                                           return snapshot.hasData && snapshot.data!.size>0?
                                           Container(
                                             child: DataTable(
                                                 border: TableBorder.all(),
                                                 columns: [
                                                   DataColumn(label: Text('Range')),
                                                   DataColumn(label: Text('Grade')),
                                                 ],
                                                 rows: snapshot.data!.docs.map<DataRow>((e) =>
                                                     DataRow(
                                                         cells: [
                                                           DataCell(
                                                               Text('${e.get('from')} - ${e.get('to')}')
                                                           ),
                                                           DataCell(
                                                               Text('${e.get('grade')}')
                                                           ),
                                                         ]
                                                     )
                                                 ).toList()
                                             ),
                                           )
                                               :Container();
                                         },
                                       )
                                   ),
                                 )
                               ],
                             )
                         ),
                       ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

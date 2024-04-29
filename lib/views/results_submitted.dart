import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stdominicsadmin/controllers/selectedCourseController.dart';
import 'package:get/get.dart';
import 'package:stdominicsadmin/controllers/students_controller.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import 'package:timeago/timeago.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../helpers/date_formater.dart';
import '../models/student_model.dart';
import 'assessment_reader.dart';

class AssessmentSubmitted extends StatelessWidget {
  DocumentSnapshot assessment;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> submissions;
  AssessmentSubmitted({required this.submissions, required this.assessment});

  StudentsController _studentsController = Get.find();
  SelectedCourseController _selectedCourseController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Kara.primary
              ),
              child: Row(
                children: [
                  MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: ()=>Get.back(),
                          child: Icon(Icons.arrow_back, color: Colors.white,)
                      )
                  ),
                  SizedBox(width: 10,),
                  Text('Submissions', style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 400,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                        '${_selectedCourseController.selectedCourse.value} - ${assessment.get('reason')}'.toUpperCase(), style: GoogleFonts.abel(fontSize: 20),),),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 2)
                                ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Assessment Details', style: GoogleFonts.abel(fontSize: 18),),
                                  SizedBox(height: 20),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 120,
                                                child: Text('Question:', style: TextStyle(fontWeight: FontWeight.bold),)
                                            ),
                                            Expanded(child: Text(assessment.get('question')))
                                          ]
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 120,
                                                child: Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold),)
                                            ),
                                            Expanded(child: Text(assessment.get('instructions')))
                                          ]
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 120,
                                                child: Text('Date:', style: TextStyle(fontWeight: FontWeight.bold),)
                                            ),
                                            Text('${formatDate(assessment.get('datetime'))}')
                                          ]
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 120,
                                                child: Text('Due Date:', style: TextStyle(fontWeight: FontWeight.bold),)
                                            ),
                                            Text('${formatDate(assessment.get('duedate'))}')
                                          ]
                                        ),
                                        SizedBox(height: 10,),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 2)
                                    ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 2)
                                    ]
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Submissions (${submissions.length})', style: GoogleFonts.abel(fontSize: 18),),
                                    SizedBox(height: 20),
                                    Expanded(
                                      child: Container(
                                        child: submissions.length>0?
                                        ListView.builder(
                                            itemCount: submissions.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context,index){
                                              StudentModel student = _studentsController.students.where((p0) =>
                                              p0.email==submissions[index].get('student')
                                              ).first;
                                              return Container(
                                                margin: EdgeInsets.only(bottom: 10),
                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.05),
                                                    border: Border.all(color: Colors.grey.withOpacity(0.3),),
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: CachedNetworkImage(
                                                            width: 30,
                                                            height: 30,
                                                            imageUrl: student.photo
                                                        )
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('${student.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                                                        Row(
                                                          children: [
                                                            Text('Submitted on: '),
                                                            Text('${formatDate(submissions[index].get('datetime'))}'),
                                                          ],
                                                        ),
                                                        Text('Files:'),
                                                        Row(
                                                          children: submissions[index].get('file').map<Widget>((e)=> Container(
                                                            padding: EdgeInsets.all(10),
                                                            child: MouseRegion(
                                                              cursor: SystemMouseCursors.click,
                                                              child: TouchRippleEffect(
                                                                  rippleColor: Colors.grey.withOpacity(0.4),
                                                                  onTap: ()=>Get.to(()=>AssessmentReader(
                                                                      {
                                                                        'submission':submissions[index],
                                                                        'assessment': assessment
                                                                      })),
                                                                  child: Icon(Icons.picture_as_pdf, color: Colors.green)
                                                              ),
                                                            ),
                                                          )).toList(),
                                                        )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      padding: EdgeInsets.all(20),
                                                      child: StreamBuilder(
                                                          stream: FirebaseFirestore.
                                                          instance.collection('results').
                                                          where('submissionID', isEqualTo: submissions[index].id).snapshots(),
                                                          builder: (context, snapshot) {
                                                            return snapshot.hasData && snapshot.data!.size>0 ?
                                                            Column(
                                                              children: [
                                                                Text('Marks', style: TextStyle(color: Kara.primary),),
                                                                Text(snapshot.data!.docs.first.get('marks'), style: GoogleFonts.abel(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),),
                                                              ],
                                                            ):Container();
                                                          }
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                        ):Container(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      )
    );
  }
}

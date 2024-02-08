import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:stdominicsadmin/controllers/students_controller.dart';
import 'package:stdominicsadmin/controllers/tutorController.dart';
import 'package:stdominicsadmin/helpers/date_formater.dart';
import 'package:stdominicsadmin/models/student_model.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import "package:webview_universal/webview_universal.dart";
import '../helpers/methods.dart';
import '../models/book_model.dart';
import '../styles/colors.dart' as kara;
import 'package:get/get.dart';

class AssessmentReader extends StatefulWidget {
  Map<String, DocumentSnapshot> assessment;
  AssessmentReader(this.assessment);

  @override
  State<AssessmentReader> createState() => _AssessmentReaderState();
}

class _AssessmentReaderState extends State<AssessmentReader> {
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    task();
  }

  Future<void> task() async {
    await webViewController.init(
      context: context,
      uri: Uri.parse("${widget.assessment['submission']!.get('file').first}"),
      setState: (void Function() fn) {
        print(widget.assessment['submission']!.get('file').first);
      },
    );
  }
  TutorController _tutorController = Get.find();
  TextEditingController _marksController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  StudentsController students = Get.find();

  Methods methods = Methods();
  @override
  Widget build(BuildContext context) {

    StudentModel student = students.students.value.where((element) => element.email == widget.assessment['submission']!.get('student')).first;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kara.Colors.primary)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    Text('${widget.assessment['submission']!.get('course')} - ${widget.assessment['assessment']!.get('reason')}'.toUpperCase(), style: TextStyle(color: Colors.white),)
                  ],
                ),
                decoration: BoxDecoration(
                    color: kara.Colors.primary,

                ),
              ),
              Expanded(
                child: Container(
                  child: ResizableContainer(
                      direction: Axis.horizontal,
                      children: [
                        ResizableChildData(
                            child: Container(
                              width: 400,
                              height: double.infinity,
                              child:ClipRRect(
                                child: WebView(
                                  controller: webViewController,
                                ),
                              ), // Simple Pdf view with one render of page (loose quality on zoom)

                            ),
                            startingRatio: 0.75
                        ),
                        ResizableChildData(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: kara.Colors.background,
                                      boxShadow: [
                                        BoxShadow(color: Colors.grey,blurRadius: 2)
                                      ]
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Student'),
                                        SizedBox(height: 10),
                                        MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: Container(
                                              child: StreamBuilder(
                                                  stream: FirebaseFirestore.instance.collection('students').where('email', isEqualTo: widget.assessment['submission']!.get('student')).snapshots(),
                                                  builder: (context,snapshot){
                                                   return  snapshot.hasData&&snapshot.data!.size>0?
                                                   TouchRippleEffect(
                                                     rippleColor: Colors.grey.withOpacity(0.3),
                                                     onTap: (){
                                                       methods.previewStudent(snapshot.data!.docs.first);
                                                     },
                                                     child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              CachedNetworkImage(
                                                                height: 40, width: 40,
                                                                  imageUrl: '${snapshot.data!.docs.first.get('photo')}',
                                                                  errorWidget: (c,i,e)=>Icon(Icons.person),
                                                              ),
                                                              SizedBox(width: 10),
                                                              Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(snapshot.data!.docs.first.get('displayName'), style: TextStyle(fontWeight: FontWeight.bold)),
                                                                      Text(snapshot.data!.docs.first.get('email'), style: TextStyle(fontSize: 12),),
                                                                    ],
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                        ):Container();
                                                  }
                                              )
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: SingleChildScrollView(
                                        child: Container(
                                            width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: StreamBuilder(
                                                    stream: FirebaseFirestore.instance.collection('assessments')
                                                        .doc(widget.assessment['submission']!.get('assessmentID')).snapshots(),
                                                    builder: (context,snapshot){
                                                      return snapshot.hasData&&snapshot.data!.exists
                                                          ? Container(
                                                            width: double.infinity,
                                                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('Question', style: TextStyle(color: Colors.grey),),
                                                                Text('${snapshot.data!.get('question')}'),
                                                                SizedBox(height: 20),
                                                                Text('Instructions', style: TextStyle(color: Colors.grey),),
                                                                Text('${snapshot.data!.get('instructions')}'),
                                                                SizedBox(height: 20),
                                                                Text('Due Date', style: TextStyle(color: Colors.grey),),
                                                                Container(
                                                                  child: Text(formatDate(snapshot.data!.get('duedate')))
                                                                ),
                                                                SizedBox(height: 20),
                                                                Text('Date Submitted', style: TextStyle(color: Colors.grey),),
                                                                Container(
                                                                  child: Text(formatDate(widget.assessment['submission']!.get('datetime')))
                                                                )
                                                              ],
                                                            )
                                                          )
                                                          : Container();
                                                    }
                                                )
                                              )
                                            ],
                                          )
                                        ),
                                      )
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('results')
                                        .where('submissionID', isEqualTo:widget.assessment['submission']!.id)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return snapshot.hasData && snapshot.data!.size>0
                                          ? Container(
                                              padding: EdgeInsets.symmetric(vertical: 20),
                                              child: Column(
                                                children: [
                                                  Text('Marked', style: TextStyle(color: Colors.red)),
                                                  Text('${snapshot.data!.docs.first.get('marks')} Marks', style: TextStyle(fontSize: 30, color: kara.Colors.green)),
                                                  Text('${formatDate(snapshot.data!.docs.first.get('datetime'))}', style: TextStyle(color: Colors.grey)),
                                                ]
                                              ),
                                            )
                                          : Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                        child: Column(
                                            children: [
                                              Container(
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 2
                                                        )
                                                      ]
                                                  ),
                                                  child: TextField(
                                                      textAlign: TextAlign.center,
                                                      controller: _marksController,
                                                      decoration: InputDecoration(
                                                          hintText: 'Marks',
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 20)
                                                      )
                                                  )
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 2
                                                        )
                                                      ]
                                                  ),
                                                  child: TextField(
                                                      controller: _remarksController,
                                                      decoration: InputDecoration(
                                                          hintText: 'Remarks...',
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 20)
                                                      )
                                                  )
                                              ),
                                              SizedBox(height: 20),
                                              MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: TouchRippleEffect(
                                                    onTap: (){
                                                      _marksController.text.isNotEmpty ? FirebaseFirestore.instance.collection('results')
                                                          .add({
                                                        'submissionID': widget.assessment['submission']!.id,
                                                        'course': widget.assessment['submission']!.get('course'),
                                                        'datetime': '${DateTime.now()}',
                                                        'marks': _marksController.text,
                                                        'remarks': _remarksController.text,
                                                        'reason': "${widget.assessment['assessment']!.get('reason')}",
                                                        'student': widget.assessment['submission']!.get('student'),
                                                        'student_id':student.id,
                                                        'academic_year':student.academic_year

                                                      }).then((e){
                                                        _marksController.text = "";
                                                        _remarksController.text = "";
                                                      }) : null;
                                                    },
                                                    rippleColor: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: kara.Colors.green,
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        width: double.infinity,
                                                        height: 40,
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text('Done', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                              Icon(Icons.check, color: Colors.white)
                                                            ],
                                                          ),
                                                        )
                                                    )
                                                ),
                                              )
                                            ]
                                        ),
                                      );
                                    }
                                  )
                                ]
                              )
                            ),
                            startingRatio: 0.25
                        ),

                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'dart:html' as html;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timetable/flutter_timetable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stdominicsadmin/controllers/teachers_controller.dart';
import 'package:stdominicsadmin/helpers/load_data.dart';
import 'package:stdominicsadmin/models/timetable_item_data.dart';
import 'package:stdominicsadmin/views/home.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;
import '../controllers/announcements_controller.dart';
import '../controllers/guardians_controller.dart';
import '../controllers/my_classes_controller.dart';
import '../controllers/reasons_controller.dart';
import '../controllers/results_controller.dart';
import '../controllers/selectedCourseController.dart';
import '../controllers/selected_guardian_controller.dart';
import '../controllers/students_controller.dart';
import '../controllers/teacher_controller.dart';
import '../controllers/timetable_controller.dart';
import '../controllers/tutorController.dart';
import '../controllers/institution_controller.dart';
import '../models/teacher_model.dart';
import '../models/timetable_model.dart';
import '../styles/colors.dart';
import 'date_formater.dart';

class Methods {

  FirebaseFirestore fs = FirebaseFirestore.instance;

  InstitutionController _institutionController = Get.find();
  TeacherController _tutorController = Get.find();
  TeachersController _teachersController = Get.find();
  SelectedCourseController _selectedCourseController = Get.find();
  TeacherController teacherController = Get.find();
  InstitutionController institutionController = Get.find();
  MyClassesController myClassesController = Get.find();
  StudentsController _studentsController = Get.find();
  ResultsController _resultsController = Get.find();
  ReasonsController _reasonsController = Get.find();
  GuardiansController _guardiansController = Get.find();

  AnnouncementsController _announcementsController = Get.find();
  TimetableDataController _timetableController = Get.find();

  LoadData loadData = LoadData();

  var selectedProfile = ''.obs;
  var uploadprogress = 0.0.obs;
  html.FileUploadInputElement? selectedAssessment;


  Future<void> _uploadToFirebaseStorage(html.FileUploadInputElement input) async {
    try {
      // Access the selected file
      final html.File file = input.files!.first;

      // Get a reference to the Firebase Storage instance
      final firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref('images/${file.name}');

      // Upload the file to Firebase Storage
      final firebase_storage.UploadTask uploadTask = storageRef.putBlob(file);

      // Monitor the upload progress
      uploadTask.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        uploadprogress.value = progress;
      });

      // Wait for the upload to complete
      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded file
        final String downloadUrl = await storageRef.getDownloadURL();
        FirebaseFirestore.instance.collection('tutor').doc(_tutorController.teacher.value.uid).update(
            {
              'photo':downloadUrl
            }
        );
        print('Download URL: $downloadUrl');
      });
    } catch (error) {
      print('Error uploading to Firebase Storage: $error');
      // Handle the error as needed
    }
  }

    pickProfile(BuildContext context) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Specify that only image files are allowed
    input.click();

    // Wait for the user to select a file
    await input.onChange.first;

    // Now you can upload the file to Firebase Storage
    selectedProfile.value = input.files!.first.name;
    //selectedProfile.value = input!;
    _uploadToFirebaseStorage(input);
  }


    Future<void> _uploadLogoToFirebaseStorage(html.FileUploadInputElement input) async {
    try {
      // Access the selected file
      final html.File file = input.files!.first;

      // Get a reference to the Firebase Storage instance
      final firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref('images/${DateTime.now()}${file.name}');

      // Upload the file to Firebase Storage
      final firebase_storage.UploadTask uploadTask = storageRef.putBlob(file);

      // Monitor the upload progress
      uploadTask.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        uploadprogress.value = progress;
      });

      // Wait for the upload to complete
      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded file
        final String downloadUrl = await storageRef.getDownloadURL();
        FirebaseFirestore.instance.collection('institutions').doc(_tutorController.teacher.value.institutionID).update(
            {
              'logo':downloadUrl
            }
        );
        print('Download URL: $downloadUrl');
      });
    } catch (error) {
      print('Error uploading to Firebase Storage: $error');
      // Handle the error as needed
    }
  }
    pickLogo(BuildContext context) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Specify that only image files are allowed
    input.click();

    // Wait for the user to select a file
    await input.onChange.first;

    // Now you can upload the file to Firebase Storage
    selectedProfile.value = input.files!.first.name;
    //selectedProfile.value = input!;
    _uploadLogoToFirebaseStorage(input);
  }

    TextEditingController messageController = TextEditingController();
    showChat(DocumentSnapshot document){
    Get.bottomSheet(
      Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                )
              ]
          ),
          child: Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    color: Color(0xe58cc9de),
                                    child: CachedNetworkImage(
                                      width: 30,
                                      height: 30,
                                      imageUrl: '${document.get("photo")}',
                                      errorWidget: (c,s,i)=>Center(child: Text(document.get('displayName')[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),

                                    ),
                                  )
                              ),
                              SizedBox(width: 15),
                              Text(document.get('displayName'), style: TextStyle(fontWeight: FontWeight.bold))
                            ]
                        ),
                        TouchRippleEffect(
                            rippleColor: Colors.grey.withOpacity(0.3),
                            onTap: (){
                              Get.back();
                            },
                            child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Icon(Icons.close)
                            )
                        )
                      ],
                    )
                ),
                Container(height: 0.4, color: Colors.grey.withOpacity(0.4)),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('messages').orderBy('counter').snapshots(),
                        builder: (context, documentSnapshots) {
                          if(documentSnapshots.hasData && documentSnapshots.data!.size>0){

                            List<DocumentSnapshot> snapshot = documentSnapshots.data!.docs.where((element) =>
                            (element.get('sender')==document.get('email') && element.get('receiver')==_tutorController.teacher.value.email) ||
                                (element.get('sender')==_tutorController.teacher.value.email &&
                                    element.get('receiver')==document.get('email'))
                            ).toList();

                            return ListView.builder(
                              itemCount: snapshot.length,
                              itemBuilder: (context,index){
                                return InkWell(
                                  onLongPress: (){

                                  },
                                  onTap: (){

                                  },
                                  child: BubbleSpecialThree(
                                    isSender: snapshot[index].get('sender') ==_tutorController.teacher
                                        .value.email?true:false,
                                    text: '${snapshot[index].get('message')}',
                                    color: snapshot[index].get('sender') ==_tutorController.teacher
                                        .value.email?Color(0xFF1B97F3):Color(
                                        0xFFBCD1DC),
                                    tail: true,
                                    textStyle: TextStyle(
                                        color: snapshot[index].get('sender') ==_tutorController.teacher
                                            .value.email?Colors.white:Colors.black,
                                        fontSize: 16
                                    ),
                                  ),
                                );
                              },
                            );
                          }else{
                            return Container();
                          }
                        }
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                      children: [
                        Expanded(
                          child: Container(
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
                                  controller: messageController,
                                  decoration: InputDecoration(
                                      hintText: 'Message',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20)
                                  )
                              )
                          ),
                        ),
                        SizedBox(width: 10),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TouchRippleEffect(
                              onTap: (){
                                if(messageController.text.isNotEmpty){

                                  int counter = 1;
                                  if(messageController.text.isNotEmpty){
                                    FirebaseFirestore.instance.collection('messages').orderBy('counter').get().then((value){

                                      if(value.docs.isNotEmpty){
                                        counter = value.docs.last.get('counter') + 1;
                                        Map<String,dynamic> data = {
                                          'counter': counter,
                                          'sender': _tutorController.teacher.value.email,
                                          'message': messageController.text,
                                          'receiver':document.get('email'),
                                          'datetime':'${DateTime.now()}',
                                          'seen': false,
                                          'sent': true,
                                          'delivered':false
                                        };

                                        FirebaseFirestore.instance.collection('messages').add(data).then((value){
                                            messageController.text = "";
                                        });
                                      }

                                    });

                                  }
                                }
                              },
                              rippleColor: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              child: Icon(Icons.send, color: Colors.green)
                          ),
                        )
                      ]
                  ),
                )
              ]
          )
      ),
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.2),
    );
  }
    void previewStudent(DocumentSnapshot document){
    /*  FirebaseFirestore.instance.collection('students').get().then((value){
        for(DocumentSnapshot document in value.docs){
          FirebaseFirestore.instance.collection('students').doc(document.id).update({'datetime': '${DateTime.now()}'});
        }
      });*/
      Get.defaultDialog(
        title: '',
        content:  Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
              width: 400,
              height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 6
                                  ),
                                    borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 4
                                    )
                                  ]
                                ),
                                child: CachedNetworkImage(
                                     width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    imageUrl: document.get('photo')??'',
                                    errorWidget: (e,i,c)=>Center(
                                      child: Text(document.get('displayName')[0], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                                    ),
                      
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TouchRippleEffect(
                                rippleColor: Colors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: 150,
                                  height: 25,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.red
                                  ),
                                  child: Center(child: Text('Freeze Student', style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TouchRippleEffect(
                                onTap: (){
                                  showChat(document);
                                },
                                rippleColor: Colors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: 150,
                                  height: 25,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Kara.primary
                                  ),
                                  child: Center(child: Text('Message', style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                            ),
                          ]
                        )
                      )
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.get('displayName'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.email),
                          SizedBox(width: 20),
                          Text(document.get('email'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_outlined),
                          SizedBox(width: 20),
                          Text(formatDate(document.get('datetime')), style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Engagements', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('book_views').where('user',isEqualTo: document.get('email')).snapshots(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    if(snapshot.data!.docs.isNotEmpty){
                                      return Row(
                                        children: [
                                          Text('Books:'),
                                          SizedBox(width: 10),
                                          Text('${snapshot.data!.docs.length}'),
                                        ],
                                      );
                                    }else{
                                      return Row(
                                        children: [
                                          Text('Books:'),
                                          SizedBox(width: 10),
                                          Text('${snapshot.data!.docs.length}'),
                                        ],
                                      );
                                    }
                                  }else{
                                    return Shimmer.fromColors(
                                        child: Row(
                                          children: [
                                            Expanded(child: Container(height: 10,color: Colors.grey,)),
                                            SizedBox(width: 20,),
                                            Expanded(child: Container(height: 10,color: Colors.grey,)),
                                          ],
                                        ), baseColor: Colors.grey.withOpacity(0.3), highlightColor: Colors.white.withOpacity(0.6)
                                    );
                                  }
                                }
                            ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(child: Container(
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('submissions').where('student',isEqualTo: document.get('email')).snapshots(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    if(snapshot.data!.docs.isNotEmpty){
                                      return Row(
                                        children: [
                                          Text('Assessments:'),
                                          SizedBox(width: 10),
                                          Text('${snapshot.data!.docs.length}'),
                                        ],
                                      );
                                    }else{
                                      return Row(
                                        children: [
                                          Text('Assessments:'),
                                          SizedBox(width: 10),
                                          Text('${snapshot.data!.docs.length}'),
                                        ],
                                      );
                                    }
                                  }else{
                                    return Shimmer.fromColors(
                                        child: Row(
                                          children: [
                                            Container(height: 10,color: Colors.grey,),
                                            SizedBox(width: 40,),
                                            Expanded(child: Container(height: 10,color: Colors.grey,)),
                                          ],
                                        ), baseColor: Colors.grey.withOpacity(0.3), highlightColor: Colors.white.withOpacity(0.6)
                                    );
                                  }
                                }
                            ),
                          ),),
                        ],
                      ),
                    ],
                  )
                ),
                Expanded(
                  child: Container(),
                )
              ],
            )
        ),
        backgroundColor: Colors.white
      );
    }

    showGradesBottomSheetAdder(){
      TextEditingController fromController = TextEditingController();
      TextEditingController toController = TextEditingController();
      TextEditingController gradeController = TextEditingController();
      Get.bottomSheet(
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text('Grading System', style: GoogleFonts.abel(fontSize: 20)),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Range (eg. 0 to 49)'),
                                SizedBox(height: 10),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: TextField(
                                          controller: fromController,
                                          style: TextStyle(fontSize: 20),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 20)
                                          ),
                                        )
                                      ),
                                      Text('   to   '),
                                      Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: TextField(
                                          controller: toController,
                                          style: TextStyle(fontSize: 20),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 20)
                                          ),
                                        )
                                      ),
                                    ]
                                  )
                                ),
                                SizedBox(height: 15),
                                Text('Grade (eg. A, A+, C, D)'),
                                SizedBox(height: 10),
                                Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: TextField(
                                      controller: gradeController,
                                      style: TextStyle(fontSize: 20),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 20)
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('grading_system').where('institutionID', isEqualTo: _institutionController.institution.value.uid)
                                    .snapshots(),
                                builder: (BuildContext context, snapshot) {
                                  return snapshot.hasData && snapshot.data!.size>0?
                                      Container(
                                        width: 250,
                                        child: Table(
                                          border: TableBorder.all(),
                                            children: snapshot.data!.docs.map<TableRow>((e) =>
                                                TableRow(
                                                    children: [
                                                        Container(
                                                           padding: EdgeInsets.symmetric(vertical: 5),
                                                            child: Center(child: Text('${e.get('from')} - ${e.get('to')}'))
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets.symmetric(vertical: 5),
                                                            child: Center(child: Text('${e.get('grade')}')),),
                                                        Container(
                                                          child: Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                                  onPressed: (){
                                                                    FirebaseFirestore.instance
                                                                        .collection('grading_system').doc(e.id).delete();
                                                                    shownackbar('Deleted!', context);
                                                                  },
                                                                ),
                                                              ]
                                                          )
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
                    ]
                  )
                )
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: TouchRippleEffect(
                      onTap: (){
                        FirebaseFirestore.instance.collection('grading_system')
                            .add({
                              'institutionID': _institutionController.institution.value.uid,
                              'from':fromController.text,
                              'to':toController.text,
                              'grade': gradeController.text,
                              'dateModified':'${DateTime.now()}'
                        }).then((value)=>null);
                      },
                      rippleColor: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Kara.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(blurRadius: 2)
                              ]
                          ),
                          child: Center(child: Text('ADD', style: TextStyle(color: Colors.white),))
                      ),
                    )
                )
              )
            ],
          )
        ),
        backgroundColor: Colors.white
      );
    }

  TextEditingController courseController = TextEditingController();
  TextEditingController editController = TextEditingController();

    void courses(){
      Get.defaultDialog(
          title: '${_institutionController.institution.value.type=='primary'?'SUBJECTS':'COURSES'}',
          titlePadding: EdgeInsets.symmetric(vertical: 20),
          titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
          content: Container(
            height: 400,
            width: 600,
            child: Column(
                children: [
                  Container(
                      color: Kara.grey.withOpacity(0.3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('courses').
                              where('institutionID', isEqualTo: _institutionController.institution.value.uid).
                              snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData&&snapshot.data!.size>0) {
                                  return Text('${snapshot.data!.size} ${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'} available');
                                } else {
                                  return Container();
                                }
                              }
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 10),
                  Container(
                      child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: TextField(
                                    controller: courseController,
                                    decoration: InputDecoration(
                                        hintText: '${_institutionController.institution.value.type=='primary'?'Subject':'Course'} Name',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(width: 20),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TouchRippleEffect(
                                rippleColor: Colors.grey.withOpacity(0.3),
                                onTap: (){
                                  FirebaseFirestore.instance.collection('courses').add({
                                    'course':courseController.text.toLowerCase(),
                                    'description':'Course',
                                    'institutionID':_institutionController.institution.value.uid
                                  }).then((value){
                                    courseController.text = '';
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Kara.green,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  height: 35,
                                  width: 60,
                                  child: Center(child: Text('Add', style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                            )
                          ]
                      )
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: Container(
                          color: Colors.white,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('courses').where('institutionID', isEqualTo: _institutionController.institution.value.uid).snapshots(),
                              builder: (content,snapshot){
                                if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index){

                                        return Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 15,
                                            ),
                                            decoration: BoxDecoration(
                                                border: BorderDirectional(
                                                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                )
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                        child: Text('${snapshot.data!.docs[index].get('course').toString().capitalizeFirst}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                                                    )
                                                ),
                                                Row(
                                                  children: [
                                                    MouseRegion(
                                                        cursor: SystemMouseCursors.click,
                                                        child: TouchRippleEffect(
                                                            onTap: (){
                                                              editController.text = snapshot.data!.docs[index].get('course');
                                                              Get.defaultDialog(
                                                                  title: 'EDIT',
                                                                  titleStyle: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 16
                                                                  ),
                                                                  titlePadding: EdgeInsets.symmetric(vertical: 10),
                                                                  content: Container(
                                                                      child: Column(
                                                                          children: [
                                                                            Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.grey.withOpacity(0.3),
                                                                                    border: Border.all(color: Colors.grey),
                                                                                    borderRadius: BorderRadius.circular(10)
                                                                                ),
                                                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                child: TextField(
                                                                                    controller: editController,
                                                                                    decoration: InputDecoration(
                                                                                        hintText: '',
                                                                                        contentPadding: EdgeInsets.zero,
                                                                                        border: InputBorder.none
                                                                                    )
                                                                                )
                                                                            ),
                                                                            SizedBox(height: 17),
                                                                            MouseRegion(
                                                                              cursor: SystemMouseCursors.click,
                                                                              child: TouchRippleEffect(
                                                                                onTap: (){
                                                                                  FirebaseFirestore.instance.collection('courses').doc(snapshot.data!.docs[index].id).update({'course':editController.text});
                                                                                  Get.back();
                                                                                },
                                                                                rippleColor: Colors.green,
                                                                                child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        color: Kara.green,
                                                                                        borderRadius: BorderRadius.circular(20)
                                                                                    ),
                                                                                    width: double.infinity,
                                                                                    height: 35,
                                                                                    child: Center(
                                                                                        child: Text('OK', style: TextStyle(color: Colors.white),)
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ]
                                                                      )
                                                                  )
                                                              );
                                                            },
                                                            rippleColor: Colors.grey.withOpacity(0.3),
                                                            child: Icon(Icons.edit, color: Colors.blue)
                                                        )
                                                    ),
                                                    SizedBox(width: 20),
                                                    MouseRegion(
                                                        cursor: SystemMouseCursors.click,
                                                        child: TouchRippleEffect(
                                                            onTap: (){
                                                              String course = snapshot.data!.docs[index].get('course');
                                                              Get.defaultDialog(
                                                                  title: 'Are you sure you want to delete',
                                                                  titleStyle: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 14
                                                                  ),
                                                                  titlePadding: EdgeInsets.symmetric(vertical: 10),
                                                                  content: Container(
                                                                      child: Column(
                                                                          children: [
                                                                            Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                child: Text('Delete "$course"')
                                                                            ),
                                                                            SizedBox(height: 17),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                    child: MouseRegion(
                                                                                      cursor: SystemMouseCursors.click,
                                                                                      child: TouchRippleEffect(
                                                                                        onTap: (){
                                                                                          FirebaseFirestore.instance.collection('courses').doc(snapshot.data!.docs[index].id).delete();
                                                                                          Get.back();
                                                                                        },
                                                                                        rippleColor: Colors.green,
                                                                                        child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Kara.green,
                                                                                                borderRadius: BorderRadius.circular(20)
                                                                                            ),
                                                                                            width: double.infinity,
                                                                                            height: 35,
                                                                                            child: Center(
                                                                                                child: Text('Confirm', style: TextStyle(color: Colors.white),)
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                                SizedBox(width: 20),
                                                                                Expanded(
                                                                                    child: MouseRegion(
                                                                                      cursor: SystemMouseCursors.click,
                                                                                      child: TouchRippleEffect(
                                                                                        onTap: (){
                                                                                          Get.back();
                                                                                        },
                                                                                        rippleColor: Colors.green,
                                                                                        child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Kara.green,
                                                                                                borderRadius: BorderRadius.circular(20)
                                                                                            ),
                                                                                            width: double.infinity,
                                                                                            height: 35,
                                                                                            child: Center(
                                                                                                child: Text('Cancel', style: TextStyle(color: Colors.white),)
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ]
                                                                      )
                                                                  )
                                                              );
                                                            },
                                                            rippleColor: Colors.grey.withOpacity(0.3),
                                                            child: Icon(Icons.delete, color: Colors.red,)
                                                        )
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                        );
                                      }
                                  );
                                }else{
                                  return Container();
                                }
                              }
                          )
                      )
                  )
                ]
            ),
          )
      );
    }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController programmeController = TextEditingController();
  List<String> _addedCourses = [];

    void lecturers(){
      Get.defaultDialog(
          title: '${_institutionController.institution.value.type=='primary'?'TEACHERS':'LECTURERS'}',
          titlePadding: EdgeInsets.symmetric(vertical: 20),
          titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
          content: Container(
            height: 400,
            width: 600,
            child: Column(
                children: [
                  Container(
                      color: Kara.grey.withOpacity(0.3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('tutor').
                              where('institutionID', isEqualTo: _institutionController.institution.value.uid).
                              snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.hasData&&snapshot.data!.size>0?Text('${snapshot.data!.size} ${_institutionController.institution.value.type=='primary'?'Teachers':'Lecturers'} available'):Container();
                              }
                          ),
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TouchRippleEffect(
                                onTap: (){
                                  Get.defaultDialog(
                                      title: 'Add ${_institutionController.institution.value.type=='primary'?'Teacher':'Lecturer'}',
                                      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      titlePadding: EdgeInsets.symmetric(vertical: 10),
                                      content: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          width: 550,
                                          height: 400,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Name:'),
                                                    SizedBox(height: 5),
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: Colors.grey)
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                        child: TextField(
                                                          controller: nameController,
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              contentPadding: EdgeInsets.zero
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Email:'),
                                                    SizedBox(height: 5),
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: Colors.grey)
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                        child: TextField(
                                                          controller: emailController,
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              contentPadding: EdgeInsets.zero
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Text('${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'}', style: TextStyle(fontWeight: FontWeight.bold)),
                                                SizedBox(height: 10),
                                                Expanded(
                                                  child: StreamBuilder(
                                                      stream: FirebaseFirestore.instance.collection('courses').
                                                          where('institutionID', isEqualTo: _institutionController.institution.value.uid).snapshots(),
                                                      builder: (context,snapshot){
                                                        return snapshot.hasData && snapshot.data!.size>0?ListView.builder(
                                                          itemBuilder: (context,index){

                                                            return Row(
                                                              children: [
                                                                RoundCheckBox(
                                                                  size: 16,
                                                                  checkedWidget: Icon(Icons.check_circle, size: 10),
                                                                  onTap: (value){
                                                                    if(value! && _addedCourses.contains(snapshot.data!.docs[index].get('course')) == false) {
                                                                      _addedCourses.add(snapshot.data!.docs[index].get('course'));
                                                                    }else{
                                                                      _addedCourses.remove(snapshot.data!.docs[index].get('course'));
                                                                    }
                                                                  },
                                                                ),
                                                                SizedBox(width: 10),
                                                                Text(snapshot.data!.docs[index].get('course').toString().capitalizeFirst??'', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                                                              ],
                                                            );
                                                          },
                                                          itemCount: snapshot.data!.size,
                                                          shrinkWrap: true,
                                                        ):Container(
                                                            child: Text('Fetching ${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'} ...')
                                                        );
                                                      }
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: TouchRippleEffect(
                                                    onTap: (){
                                                      if(_addedCourses.isNotEmpty||nameController.text.isNotEmpty||emailController.text.isNotEmpty){
                                                        FirebaseFirestore.instance.collection('tutor').add(
                                                            {
                                                              'name':nameController.text,
                                                              'email': emailController.text,
                                                              'password':'123456',
                                                              'courses':_addedCourses,
                                                              'institutionID':_institutionController.institution.value.uid,
                                                              'photo': '' 
                                                            }
                                                        ).then((value)=>Get.back());
                                                      }
                                                    },
                                                    rippleColor: Colors.green,
                                                    child: Container(
                                                        width:  double.infinity,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color: Kara.green,
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                        child: Center(
                                                            child: Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                                        )
                                                    ),
                                                  ),
                                                )
                                              ]
                                          )
                                      )
                                  );
                                },
                                rippleColor: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Kara.grey, width: 0.5)
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Add ${_institutionController.institution.value.type=='primary'?'Teacher':'Lecturer'}', style: TextStyle(color: Kara.primary)),
                                      SizedBox(width: 10),
                                      Icon(Icons.add, color: Kara.primary)
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      child: Container(
                          color: Colors.white,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('tutor')
                                  .where('institutionID', isEqualTo: _tutorController.teacher.value.institutionID)
                                  .snapshots(),
                              builder: (content,snapshot){
                                if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index){
                                        return Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 15,
                                            ),
                                            decoration: BoxDecoration(
                                                border: BorderDirectional(
                                                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                )
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                        child: Text('${snapshot.data!.docs[index].get('name').toString().capitalizeFirst}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                                                    )
                                                ),
                                                Row(
                                                  children: [
                                                    MouseRegion(
                                                        cursor: SystemMouseCursors.click,
                                                        child: TouchRippleEffect(
                                                            onTap: (){
                                                              String lecturer = snapshot.data!.docs[index].get('name');
                                                              Get.defaultDialog(
                                                                  title: 'Are you sure you want to delete',
                                                                  titleStyle: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 14
                                                                  ),
                                                                  titlePadding: EdgeInsets.symmetric(vertical: 10),
                                                                  content: Container(
                                                                      child: Column(
                                                                          children: [
                                                                            Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                child: Text('Delete "$lecturer"')
                                                                            ),
                                                                            SizedBox(height: 17),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                    child: MouseRegion(
                                                                                      cursor: SystemMouseCursors.click,
                                                                                      child: TouchRippleEffect(
                                                                                        onTap: (){
                                                                                          FirebaseFirestore.instance.collection('tutor').doc(snapshot.data!.docs[index].id).delete();
                                                                                          Get.back();
                                                                                        },
                                                                                        rippleColor: Colors.green,
                                                                                        child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Kara.green,
                                                                                                borderRadius: BorderRadius.circular(20)
                                                                                            ),
                                                                                            width: double.infinity,
                                                                                            height: 35,
                                                                                            child: Center(
                                                                                                child: Text('Confirm', style: TextStyle(color: Colors.white),)
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                                SizedBox(width: 20),
                                                                                Expanded(
                                                                                    child: MouseRegion(
                                                                                      cursor: SystemMouseCursors.click,
                                                                                      child: TouchRippleEffect(
                                                                                        onTap: (){
                                                                                          Get.back();
                                                                                        },
                                                                                        rippleColor: Colors.green,
                                                                                        child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Kara.green,
                                                                                                borderRadius: BorderRadius.circular(20)
                                                                                            ),
                                                                                            width: double.infinity,
                                                                                            height: 35,
                                                                                            child: Center(
                                                                                                child: Text('Cancel', style: TextStyle(color: Colors.white),)
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ]
                                                                      )
                                                                  )
                                                              );
                                                            },
                                                            rippleColor: Colors.grey.withOpacity(0.3),
                                                            child: Icon(Icons.delete, color: Colors.red,)
                                                        )
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                        );
                                      }
                                  );
                                }else{
                                  return Container();
                                }
                              }
                          )
                      )
                  )
                ]
            ),
          )
      );
    }

    String guardianphone = '';
    String guardianemail = '';

    SelectedGuardianController _selectedGuardianController = Get.find();

    String guardians(){
      Get.defaultDialog(
          title: 'SELECT GUARDIAN',
          titlePadding: EdgeInsets.symmetric(vertical: 20),
          titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
          content: Container(
            height: 400,
            width: 600,
            child: Column(
                children: [
                  Container(
                      color: Kara.grey.withOpacity(0.3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TouchRippleEffect(
                                onTap: (){
                                  TextEditingController guardian_name_controller = TextEditingController();
                                  TextEditingController guardian_email_controller = TextEditingController();
                                  TextEditingController guardian_phone_controller = TextEditingController();

                                  Get.defaultDialog(
                                      title: 'Add Guardian',
                                      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      titlePadding: EdgeInsets.symmetric(vertical: 10),
                                      content: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          width: 550,
                                          height: 400,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Name:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                                                TextField(
                                                  controller: guardian_name_controller,
                                                  cursorHeight: 28,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text('Email (Optional):', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                                                TextField(
                                                  controller: guardian_email_controller,
                                                  cursorHeight: 28,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text('Phone Number (Optional):', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                                                TextField(
                                                  controller: guardian_phone_controller,
                                                  cursorHeight: 28,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: TouchRippleEffect(
                                                    onTap: (){
                                                      if(guardian_name_controller.text.isNotEmpty||guardian_phone_controller.text.isNotEmpty){
                                                        FirebaseFirestore.instance.collection('guardians').add(
                                                            {
                                                              'name':guardian_name_controller.text,
                                                              'email': guardian_email_controller.text,
                                                              'phone':guardian_phone_controller.text,
                                                            }
                                                        ).then((value)=>Get.back());
                                                      }
                                                    },
                                                    rippleColor: Colors.green,
                                                    child: Container(
                                                        width:  double.infinity,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color: Kara.green,
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                        child: Center(
                                                            child: Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                                        )
                                                    ),
                                                  ),
                                                )
                                              ]
                                          )
                                      )
                                  );
                                },
                                rippleColor: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Kara.grey, width: 0.5)
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Add New Guardian', style: TextStyle(color: Kara.primary)),
                                      SizedBox(width: 10),
                                      Icon(Icons.add, color: Kara.primary)
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      child: Container(
                          color: Colors.white,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('guardians').snapshots(),
                              builder: (content,snapshot){
                                if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index){
                                        return MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: TouchRippleEffect(
                                            onTap: (){
                                              guardianphone = snapshot.data!.docs[index].get('phone');
                                              guardianemail = snapshot.data!.docs[index].get('name');

                                              _selectedGuardianController.selected_guardian_controller.value
                                              = '$guardianemail>$guardianphone';

                                              Get.back();
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                    border: BorderDirectional(
                                                        bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                    )
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                            child: Text('${snapshot.data!.docs[index].get('name').toString().capitalizeFirst}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                                                        )
                                                    ),
                                                    Row(
                                                      children: [
                                                       /* MouseRegion(
                                                            cursor: SystemMouseCursors.click,
                                                            child: TouchRippleEffect(
                                                                onTap: (){
                                                                  String guardian = snapshot.data!.docs[index].get('name');
                                                                  Get.defaultDialog(
                                                                      title: 'Are you sure you want to delete',
                                                                      titleStyle: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 14
                                                                      ),
                                                                      titlePadding: EdgeInsets.symmetric(vertical: 10),
                                                                      content: Container(
                                                                          child: Column(
                                                                              children: [
                                                                                Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                    child: Text('Delete "$lecturer"')
                                                                                ),
                                                                                SizedBox(height: 17),
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                        child: MouseRegion(
                                                                                          cursor: SystemMouseCursors.click,
                                                                                          child: TouchRippleEffect(
                                                                                            onTap: (){
                                                                                              FirebaseFirestore.instance.collection('tutor').doc(snapshot.data!.docs[index].id).delete();
                                                                                              Get.back();
                                                                                            },
                                                                                            rippleColor: Colors.green,
                                                                                            child: Container(
                                                                                                decoration: BoxDecoration(
                                                                                                    color: kara.Colors.green,
                                                                                                    borderRadius: BorderRadius.circular(20)
                                                                                                ),
                                                                                                width: double.infinity,
                                                                                                height: 35,
                                                                                                child: Center(
                                                                                                    child: Text('Confirm', style: TextStyle(color: Colors.white),)
                                                                                                )
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                    ),
                                                                                    SizedBox(width: 20),
                                                                                    Expanded(
                                                                                        child: MouseRegion(
                                                                                          cursor: SystemMouseCursors.click,
                                                                                          child: TouchRippleEffect(
                                                                                            onTap: (){
                                                                                              Get.back();
                                                                                            },
                                                                                            rippleColor: Colors.green,
                                                                                            child: Container(
                                                                                                decoration: BoxDecoration(
                                                                                                    color: kara.Colors.green,
                                                                                                    borderRadius: BorderRadius.circular(20)
                                                                                                ),
                                                                                                width: double.infinity,
                                                                                                height: 35,
                                                                                                child: Center(
                                                                                                    child: Text('Cancel', style: TextStyle(color: Colors.white),)
                                                                                                )
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ]
                                                                          )
                                                                      )
                                                                  );
                                                                },
                                                                rippleColor: Colors.grey.withOpacity(0.3),
                                                                child: Icon(Icons.delete, color: Colors.red,)
                                                            )
                                                        ),*/
                                                      ],
                                                    )
                                                  ],
                                                )
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                }else{
                                  return Container();
                                }
                              }
                          )
                      )
                  )
                ]
            ),
          )
      );

      return '$guardianphone>$guardianphone';
    }
    void programmes(){
      Get.defaultDialog(
          title: '${_institutionController.institution.value.type=='primary'?'CLASSES':'PROGRAMMES'}',
          titlePadding: EdgeInsets.symmetric(vertical: 20),
          titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
          content: Container(
            height: 400,
            width: 600,
            child: Column(
                children: [
                  Container(
                      color: Kara.grey.withOpacity(0.3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('programmes').
                              where('institutionID', isEqualTo: _institutionController.institution.value.uid).
                              snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.hasData&&snapshot.data!.size>0?Text('${snapshot.data!.size} ${_institutionController.institution.value.type=='primary'?'Classes':'Programmes'} available'):Container();
                              }
                          ),
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TouchRippleEffect(
                                onTap: (){
                                  Get.defaultDialog(
                                      title: 'Add ${_institutionController.institution.value.type=='primary'?'Class':'Programme'}',
                                      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      titlePadding: EdgeInsets.symmetric(vertical: 10),
                                      content: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          width: 500,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Name:'),
                                                    SizedBox(height: 5),
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: Colors.grey)
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                        child: TextField(
                                                          controller: programmeController,
                                                          decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              contentPadding: EdgeInsets.zero
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: TouchRippleEffect(
                                                    onTap: (){
                                                      if(programmeController.text.isNotEmpty){
                                                        FirebaseFirestore.instance.collection('programmes').add(
                                                            {
                                                              'name':programmeController.text,
                                                              'institutionID':_institutionController.institution.value.uid
                                                            }
                                                        ).then((value)=>Get.back());
                                                      }
                                                    },
                                                    rippleColor: Colors.green,
                                                    child: Container(
                                                        width:  double.infinity,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color: Kara.green,
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                        child: Center(
                                                            child: Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                                        )
                                                    ),
                                                  ),
                                                )
                                              ]
                                          )
                                      )
                                  );
                                },
                                rippleColor: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Kara.grey, width: 0.5)
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Add ${_institutionController.institution.value.type=='primary'?'Class':'Programme'}', style: TextStyle(color: Kara.primary)),
                                      SizedBox(width: 10),
                                      Icon(Icons.add, color: Kara.primary)
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      child: Container(
                          color: Colors.white,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('programmes')
                                  .where('institutionID', isEqualTo: _tutorController.teacher.value.institutionID)
                                  .snapshots(),
                              builder: (content,snapshot){
                                if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index){
                                        return Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 15,
                                            ),
                                            decoration: BoxDecoration(
                                                border: BorderDirectional(
                                                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                )
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                        child: Text('${snapshot.data!.docs[index].get('name').toString().capitalizeFirst}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                                                    )
                                                ),
                                                Row(
                                                  children: [
                                                    MouseRegion(
                                                        cursor: SystemMouseCursors.click,
                                                        child: TouchRippleEffect(
                                                            onTap: (){
                                                              String lecturer = snapshot.data!.docs[index].get('name');
                                                              Get.defaultDialog(
                                                                  title: 'Are you sure you want to delete',
                                                                  titleStyle: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 14
                                                                  ),
                                                                  titlePadding: EdgeInsets.symmetric(vertical: 10),
                                                                  content: Container(
                                                                      child: Column(
                                                                          children: [
                                                                            Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                child: Text('Delete "$lecturer"')
                                                                            ),
                                                                            SizedBox(height: 17),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                    child: MouseRegion(
                                                                                      cursor: SystemMouseCursors.click,
                                                                                      child: TouchRippleEffect(
                                                                                        onTap: (){
                                                                                          FirebaseFirestore.instance.collection('programmes').doc(snapshot.data!.docs[index].id).delete();
                                                                                          Get.back();
                                                                                        },
                                                                                        rippleColor: Colors.green,
                                                                                        child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Kara.green,
                                                                                                borderRadius: BorderRadius.circular(20)
                                                                                            ),
                                                                                            width: double.infinity,
                                                                                            height: 35,
                                                                                            child: Center(
                                                                                                child: Text('Confirm', style: TextStyle(color: Colors.white),)
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                                SizedBox(width: 20),
                                                                                Expanded(
                                                                                    child: MouseRegion(
                                                                                      cursor: SystemMouseCursors.click,
                                                                                      child: TouchRippleEffect(
                                                                                        onTap: (){
                                                                                          Get.back();
                                                                                        },
                                                                                        rippleColor: Colors.green,
                                                                                        child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Kara.green,
                                                                                                borderRadius: BorderRadius.circular(20)
                                                                                            ),
                                                                                            width: double.infinity,
                                                                                            height: 35,
                                                                                            child: Center(
                                                                                                child: Text('Cancel', style: TextStyle(color: Colors.white),)
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ]
                                                                      )
                                                                  )
                                                              );
                                                            },
                                                            rippleColor: Colors.grey.withOpacity(0.3),
                                                            child: Icon(Icons.delete, color: Colors.red,)
                                                        )
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                        );
                                      }
                                  );
                                }else{
                                  return Container();
                                }
                              }
                          )
                      )
                  )
                ]
            ),
          )
      );
    }

    TextEditingController institutionNameController = TextEditingController();
    TextEditingController mottoController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
    void editInstitutionName(){
      institutionNameController.text = _institutionController.institution.value.name;
      Get.defaultDialog(
          title: 'Edit',
          titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          titlePadding: EdgeInsets.symmetric(vertical: 10),
          content: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: 500,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name:'),
                        SizedBox(height: 5),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: institutionNameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero
                              ),
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TouchRippleEffect(
                        onTap: (){
                          if(institutionNameController.text.isNotEmpty){
                            FirebaseFirestore.instance.collection('institutions').doc(_institutionController.institution.value.uid).update(
                                {
                                  'name':institutionNameController.text,
                                }
                            ).then((value)=>Get.back());
                          }
                        },
                        rippleColor: Colors.green,
                        child: Container(
                            width:  double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Kara.green,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                                child: Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                            )
                        ),
                      ),
                    )
                  ]
              )
          )
      );
    }
    void editInstitutionMotto(){
      mottoController.text = _institutionController.institution.value.motto;
      Get.defaultDialog(
          title: 'Edit',
          titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          titlePadding: EdgeInsets.symmetric(vertical: 10),
          content: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: 500,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Motto:'),
                        SizedBox(height: 5),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: mottoController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero
                              ),
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TouchRippleEffect(
                        onTap: (){
                          if(mottoController.text.isNotEmpty){
                            FirebaseFirestore.instance.collection('institutions').doc(_institutionController.institution.value.uid).update(
                                {
                                  'motto':mottoController.text,
                                }
                            ).then((value)=>Get.back());
                          }
                        },
                        rippleColor: Colors.green,
                        child: Container(
                            width:  double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Kara.green,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                                child: Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                            )
                        ),
                      ),
                    )
                  ]
              )
          )
      );
    }
    void editTutorName(){
      userNameController.text = _tutorController.teacher.value.fullname;
      Get.defaultDialog(
          title: 'Edit',
          titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          titlePadding: EdgeInsets.symmetric(vertical: 10),
          content: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: 500,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name:'),
                        SizedBox(height: 5),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: userNameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero
                              ),
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TouchRippleEffect(
                        onTap: (){
                          if(userNameController.text.isNotEmpty){
                            FirebaseFirestore.instance.collection('tutor').doc(_tutorController.teacher.value.uid).update(
                                {
                                  'name':userNameController.text,
                                }
                            ).then((value)=>Get.back());
                          }
                        },
                        rippleColor: Colors.green,
                        child: Container(
                            width:  double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Kara.green,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                                child: Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                            )
                        ),
                      ),
                    )
                  ]
              )
          )
      );
    }
    void changePassword(BuildContext context){
      _tutorController.teacher.value.fullname;
      TextEditingController newPasswordController = TextEditingController();
      TextEditingController oldPasswordController = TextEditingController();
      Get.defaultDialog(
          title: 'Set New Password',
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
          titlePadding: EdgeInsets.symmetric(vertical: 20),
          content: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text('Old Password:'),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: TextField(
                        controller: oldPasswordController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Old Password'
                        )

                    ),
                  ),
                  SizedBox(height: 15,),
                  Text('New Password:'),
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
                        if(oldPasswordController.text == _tutorController.teacher.value.password){
                          if(newPasswordController.text.isNotEmpty){
                            FirebaseFirestore.instance.collection('tutor').doc(_tutorController.teacher.value.uid)
                                .update({'password':newPasswordController.text})
                                .then((value){
                              _tutorController.teacher.value.password = newPasswordController.text;
                              shownackbar('Password Changed successfully!', context);
                              Get.back();
                            });

                          }
                        }else{
                          shownackbar('You Entered Wrong Old Password', context);
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
    }
    shownackbar(String message, BuildContext context){
        final snackBar = SnackBar(
          content: Center(child: Text('$message')),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.black87, 
        );

        // Find the Scaffold in the widget tree and use it to show a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }


    preselectCourse()async{
      await FirebaseFirestore.instance.collection('my_classes')
          .where('tutor', isEqualTo:_tutorController.teacher.value.uid)
          .get().then((value){
                _selectedCourseController.selectedCourse.value = value.docs.first.get('course') ;
            });
    }

  String formatDate1(String date){
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    return formattedDate;
  }

  signInSilently(teacherId)async{
    var teacherData = await fs.collection('tutor').doc(teacherId).get();

    // print(teacher);
    TeacherModel teacher = TeacherModel(
        uid: teacherData.id,
        fullname: teacherData.get('name'),
        email: teacherData.get('email'),
        institutionID: teacherData.get('institutionID'),
        photo: teacherData.get('photo'),
        password: teacherData.get('password')
    );

    //await loadData.addMissingFields(teacher.institutionID);

    teacherController.teacher.value = teacher;
    teacherController.update();
    _teachersController.teachers.value = await loadData.getAllTeachers(teacher.institutionID);
    _teachersController.update();
    institutionController.institution.value = await loadData.getInstitution(institutionId: teacher.institutionID);
    myClassesController.myClasses.value = await loadData.getMyClasses(teacher.uid);
    myClassesController.update();
    institutionController.update();
    _studentsController.students.value = await loadData.getAllStudents(teacher.institutionID);
    _studentsController.update();
    _resultsController.results.value = await loadData.getResults(teacher.uid);
    _resultsController.update();
    _reasonsController.reasons.value = await loadData.getReasons(teacher.institutionID);
    _guardiansController.guardians.value = await loadData.getGuardians();
    _guardiansController.update();
    _announcementsController.announcements.value = await loadData.getAnnouncements(teacher.institutionID);
    _announcementsController.update();
    _timetableController.timetables.value = await loadData.getSchoolTimetables(teacher.institutionID);
    _timetableController.update();

    Get.offAll(()=>Home(), transition: Transition.rightToLeft);

  }


  Map<String,int> dayInWeek = {
      "Monday":1,
      "Tuesday": 2,
      "Wednesday": 3,
      "Thursday": 4,
      "Friday": 5,
      "Saturday": 6,
      "Sunday": 7
  };

  List<DateTime> getWeekdaysOfMonth(DateTime date, int weekday) {
    List<DateTime> weekdays = [];
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDate = DateTime(date.year, date.month, day);
      if (currentDate.weekday == weekday) {
        weekdays.add(currentDate);
      }
    }

    return weekdays;
  }

  List splitArray(String item,demarcator){
    return item.split(demarcator);
  }

  List<TimetableItem> getTimetableDataFromController(List days, TimetableItemData timetableItemData){
    List<TimetableItem> timetable = [];

    for(int i = 0; i < days.length; i++){

      for(int j = 0; j<getWeekdaysOfMonth(DateTime.now(), dayInWeek[days[i]]!).length; j++){

        TimetableItem item = TimetableItem(
            DateTime.parse('${splitArray(getWeekdaysOfMonth(DateTime.now(), dayInWeek[days[i]]!)[j].toString()," ").first} ${timetableItemData.start}'), //revisit
            DateTime.parse('${splitArray(getWeekdaysOfMonth(DateTime.now(), dayInWeek[days[i]]!)[j].toString()," ").first} ${timetableItemData.end}'),  //revisit
            data: timetableItemData
        );
        timetable.add(item);
      }
    }

    return timetable;
  }

}
  
  

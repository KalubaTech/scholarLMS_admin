import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:get/get.dart';
import '../controllers/selected_guardian_controller.dart';
import '../helpers/methods.dart';
import 'custom_button.dart';

class StudentRegistrationForm extends StatefulWidget {
  StudentRegistrationForm({Key? key}) : super(key: key);

  @override
  State<StudentRegistrationForm> createState() => _StudentRegistrationFormState();
}

class _StudentRegistrationFormState extends State<StudentRegistrationForm> {

  TextEditingController student_name_controller = TextEditingController();
  TextEditingController student_email_controller = TextEditingController();
  TextEditingController student_phone_controller = TextEditingController();

  String student_gender = '';
  String student_academic_year = '';
  String student_programme = '';
  String guardian_relationship = '';
  var guardian_email_phone = ''.obs;
  
  InstitutionController _institutionController = Get.find();

  SelectedGuardianController _selectedGuardianController = Get.find();

  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 20
              ),
              child: Text('NEW STUDENT', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text('Name:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                  TextField(
                    controller: student_name_controller,
                    cursorHeight: 28,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Gender:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                  DropdownSearch<String>(
                    items: ['Male', 'Female'],
                    popupProps: PopupPropsMultiSelection.menu(
                      fit: FlexFit.loose,
                      showSelectedItems: true,
                    ),
                    selectedItem: student_gender,
                    onChanged: (value){
                      setState(() {
                        student_gender = value!;

                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Email (Optional):', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                  TextField(
                    controller: student_email_controller,
                    cursorHeight: 28,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Phone Number (Optional):', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                  TextField(
                    controller: student_phone_controller,
                    cursorHeight: 28,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Academic Year:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 12)),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('institutions')
                                      .doc(_institutionController.institution.value.uid).snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData?DropdownSearch<String>(
                                      items: snapshot.data!.get('academic_years').map<String>((e) => e.toString()).toList(),
                                      popupProps: PopupPropsMultiSelection.menu(
                                        fit: FlexFit.loose,
                                        showSelectedItems: true,
                                      ),
                                      selectedItem: student_academic_year,
                                      onChanged: (value){
                                        setState(() {
                                          student_academic_year = value!;

                                        });
                                      },
                                    ):DropdownSearch<String>(
                                      items: [],
                                      popupProps: PopupPropsMultiSelection.menu(
                                        fit: FlexFit.loose,
                                        showSelectedItems: true,
                                      ),
                                      selectedItem: student_academic_year,
                                      onChanged: (value){
                                        setState(() {
                                          student_academic_year = value!;

                                        });
                                      },
                                    );
                                  }
                              ),
                            ],
                          )
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Programme:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('programmes')
                                    .where('institutionID',isEqualTo: _institutionController.institution.value.uid).snapshots(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData&&snapshot.data!.size>0?DropdownSearch<String>(
                                    items: snapshot.data!.docs.map<String>((e) => e.get('name').toString()).toList(),
                                    popupProps: PopupPropsMultiSelection.menu(
                                      fit: FlexFit.loose,
                                      showSelectedItems: true,
                                    ),
                                    selectedItem: student_programme,
                                    onChanged: (value){
                                      setState(() {
                                        student_programme = value!;
                                  
                                      });
                                    },
                                  ):DropdownSearch<String>(
                                    items: [],
                                    popupProps: PopupPropsMultiSelection.menu(
                                      fit: FlexFit.loose,
                                      showSelectedItems: true,
                                    ),
                                    selectedItem:student_programme,
                                    onChanged: (value){
                                      setState(() {
                                        student_programme = value!;

                                      });
                                    },
                                  );
                                }
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Guardian (Optional):', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TouchRippleEffect(
                                rippleColor: Colors.grey.withOpacity(0.3),
                                onTap: (){
                                  setState(() {
                                    _methods.guardians();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  width: double.infinity,
                                  height: 49,
                                  child: Obx(()=> Text('${_selectedGuardianController.selected_guardian_controller.value.isNotEmpty?_selectedGuardianController.selected_guardian_controller.value.split('>').first:''}'))
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Relationship:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                            DropdownSearch<String>(
                              items: ['Father', 'Mother','Uncle','Aunt','Sibling'],
                              popupProps: PopupPropsMultiSelection.menu(
                                fit: FlexFit.loose,
                                showSelectedItems: true,
                              ),
                              selectedItem: guardian_relationship,
                              onChanged: (value){
                                setState(() {
                                  guardian_relationship = value!;

                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    Text('SAVE', style: TextStyle(fontSize: 16, color: Colors.white),),
                    width: double.infinity,
                    onTap:(){
                      if(
                          student_name_controller.text.isNotEmpty &&
                          student_gender!=''&&
                          student_programme!=''&&
                          student_academic_year!='')
                          {
                            FirebaseFirestore.instance.collection('students')
                                .add({
                              'displayName':student_name_controller.text,
                              'email':student_email_controller.text,
                              'gender': student_gender,
                              'phone':student_phone_controller.text,
                              'programme': student_programme,
                              'academic_year': student_academic_year,
                              'guardian_phone':'${_selectedGuardianController.selected_guardian_controller.split('>').last}',
                              'guardian_relationship':'${guardian_relationship}',
                              'photo':'',
                              'intake': '${DateTime.now().year}',
                              'datetime':'${DateTime.now()}',
                              'isfreezed':false,
                              'password':'',
                              'statusChangedTime': '${DateTime.now()}',
                              'isOnline': false,
                              'institutionID':_institutionController.institution.value.uid
                            }).then((value){
                                student_name_controller.clear();
                                student_email_controller.clear();
                                student_phone_controller.clear();
                                setState(() {
                                  student_gender = '';
                                  student_programme = '';
                                  student_academic_year = '';
                                  guardian_relationship = '';

                                  _selectedGuardianController.selected_guardian_controller.value = '';
                                });

                               _methods.shownackbar('Saved Successfully', context);
                            });
                          }
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

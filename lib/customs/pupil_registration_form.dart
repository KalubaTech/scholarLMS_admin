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

class PupilRegistrationForm extends StatefulWidget {
  PupilRegistrationForm({Key? key}) : super(key: key);

  @override
  State<PupilRegistrationForm> createState() => _PupilRegistrationFormState();
}

class _PupilRegistrationFormState extends State<PupilRegistrationForm> {

  TextEditingController pupil_name_controller = TextEditingController();
  TextEditingController pupil_email_controller = TextEditingController();
  TextEditingController pupil_phone_controller = TextEditingController();

  String pupil_gender = '';
  String pupil_grade = '';
  String pupil_class = '';
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
              child: Text('NEW PUPIL', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text('Name:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                  TextField(
                    controller: pupil_name_controller,
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
                    selectedItem: pupil_gender,
                    onChanged: (value){
                      setState(() {
                        pupil_gender = value!;

                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Email (Optional):', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                  TextField(
                    controller: pupil_email_controller,
                    cursorHeight: 28,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Phone Number (Optional):', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                  TextField(
                    controller: pupil_phone_controller,
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
                              Text('Grade:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 12)),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('institutions')
                                      .doc(_institutionController.institution.value.id).snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData?DropdownSearch<String>(
                                      items: snapshot.data!.get('academic_years').map<String>((e) => e.toString()).toList(),
                                      popupProps: PopupPropsMultiSelection.menu(
                                        fit: FlexFit.loose,
                                        showSelectedItems: true,
                                      ),
                                      selectedItem: pupil_grade,
                                      onChanged: (value){
                                        setState(() {
                                          pupil_grade = value!;

                                        });
                                      },
                                    ):DropdownSearch<String>(
                                      items: [],
                                      popupProps: PopupPropsMultiSelection.menu(
                                        fit: FlexFit.loose,
                                        showSelectedItems: true,
                                      ),
                                      selectedItem: pupil_class,
                                      onChanged: (value){
                                        setState(() {
                                          pupil_class = value!;

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
                              Text('Class:', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 13)),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('programmes')
                                    .where('institutionID',isEqualTo: _institutionController.institution.value.id).snapshots(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData&&snapshot.data!.size>0?DropdownSearch<String>(
                                    items: snapshot.data!.docs.map<String>((e) => e.get('name').toString()).toList(),
                                    popupProps: PopupPropsMultiSelection.menu(
                                      fit: FlexFit.loose,
                                      showSelectedItems: true,
                                    ),
                                    selectedItem: pupil_class,
                                    onChanged: (value){
                                      setState(() {
                                        pupil_class = value!;
                                  
                                      });
                                    },
                                  ):DropdownSearch<String>(
                                    items: [],
                                    popupProps: PopupPropsMultiSelection.menu(
                                      fit: FlexFit.loose,
                                      showSelectedItems: true,
                                    ),
                                    selectedItem: pupil_class,
                                    onChanged: (value){
                                      setState(() {
                                        pupil_class = value!;

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
                          pupil_name_controller.text.isNotEmpty &&
                          pupil_gender!=''&&
                          pupil_class!=''&&
                          pupil_grade!='')
                          {
                            FirebaseFirestore.instance.collection('students')
                                .add({
                              'displayName':pupil_name_controller.text,
                              'email':pupil_email_controller.text,
                              'phone':pupil_phone_controller.text,
                              'gender': pupil_gender,
                              'programme': pupil_class,
                              'academic_year': pupil_grade,
                              'guardian_phone':'${_selectedGuardianController.selected_guardian_controller.split('>').last}',
                              'guardian_relationship':'${guardian_relationship}',
                              'photo':'',
                              'intake': '${DateTime.now().year}',
                              'datetime':'${DateTime.now()}',
                              'isfreezed':false,
                              'password':'',
                              'statusChangedTime': '${DateTime.now()}',
                              'isOnline': false,
                              'institutionID':_institutionController.institution.value.id
                            }).then((value){
                                pupil_name_controller.clear();
                                pupil_email_controller.clear();
                                setState(() {
                                  pupil_gender = '';
                                  pupil_class = '';
                                  pupil_grade = '';
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

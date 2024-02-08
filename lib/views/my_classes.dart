import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stdominicsadmin/customs/custom_button.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;

import 'package:grouped_list/grouped_list.dart';
import '../controllers/institution_controller.dart';
import '../controllers/tutorController.dart';
import '../helpers/methods.dart';

class MyClasses extends StatelessWidget {
  MyClasses({Key? key}) : super(key: key);
  
  
  TutorController _tutorController = Get.find();
  InstitutionController _institutionController = Get.find();


  String programme = '';
  String academic_year = '';
  String course = '';

  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         padding: EdgeInsets.all(0),
         width: double.infinity,
         height: double.infinity,
         child: Column(
           children: [
             Container(
               width: double.infinity,
               color: kara.Colors.primary,
               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
               child: Row(
                 children: [
                   IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.arrow_back, color: Colors.white))
                 ],
               ),
             ),
             Expanded(
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 20),
                   child: Row(
                     children: [
                       Container(
                       height: double.infinity,
                       width: 400,
                       child: Container(
                           padding: EdgeInsets.symmetric(horizontal: 20),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               SizedBox(height: 30),
                               Text('Add Your ${_institutionController.institution.value.type=='primary'?'Subject':'Course'}',
                                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                               Text('Add the ${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'} that you teach.'),
                               SizedBox(height: 40),
                               Row(
                                   children: [
                                     Expanded(
                                         child: Container(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text('${_institutionController.institution.value.type=='primary'?'Class':'Programme'}'),
                                               SizedBox(height: 5),
                                               StreamBuilder(
                                                   stream: FirebaseFirestore.instance.
                                                   collection('programmes')
                                                       .where('institutionID',
                                                       isEqualTo: _tutorController.tutor.value.institutionID)
                                                       .snapshots(),
                                                   builder: (context, snapshot) {
                                                     return snapshot.hasData ? DropdownSearch<String>(
                                                       items: [
                                                         ...
                                                         snapshot.data!.docs.map((e) => e.get('name')).toList()
                                                       ],
                                                       popupProps: PopupPropsMultiSelection.menu(
                                                         fit: FlexFit.loose,
                                                         showSelectedItems: true,
                                                       ),
                                                       selectedItem: '',
                                                       onChanged: (value){
                                                         programme = value!;
                                                       },
                                                     ):DropdownSearch<String>(
                                                       items: [
                                                         'All',

                                                       ],
                                                       popupProps: PopupPropsMultiSelection.menu(
                                                         fit: FlexFit.loose,
                                                         showSelectedItems: true,
                                                       ),
                                                       selectedItem: '',
                                                       onChanged: (value){

                                                       },
                                                     );
                                                   }
                                               )
                                             ],
                                           ),
                                         )
                                     ),
                                     SizedBox(width: 10),
                                     Expanded(
                                         child: Container(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text('${_institutionController.institution.value.type=='primary'?'Grade':'Academic Year'}'),
                                               SizedBox(height: 5),
                                               StreamBuilder(
                                                   stream: FirebaseFirestore.instance.
                                                   collection('institutions')
                                                       .doc(_tutorController.tutor.value.institutionID)
                                                       .snapshots(),
                                                   builder: (context, snapshot) {
                                                     return snapshot.hasData ? DropdownSearch<String>(
                                                       items: [
                                                         ...
                                                         snapshot.data!.get('academic_years').map((e) => e).toList()
                                                       ],
                                                       popupProps: PopupPropsMultiSelection.menu(
                                                         fit: FlexFit.loose,
                                                         showSelectedItems: true,
                                                       ),
                                                       selectedItem: '',
                                                       onChanged: (value){
                                                         academic_year = value!;
                                                       },
                                                     ):DropdownSearch<String>(
                                                       items: [
                                                         'All',

                                                       ],
                                                       popupProps: PopupPropsMultiSelection.menu(
                                                         fit: FlexFit.loose,
                                                         showSelectedItems: true,
                                                       ),
                                                       selectedItem: '',
                                                       onChanged: (value){

                                                       },
                                                     );
                                                   }
                                               )
                                             ],
                                           ),
                                         )
                                     ),
                                   ]
                               ),
                               SizedBox(height: 10),
                               Container(
                                 width: double.infinity,
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text('${_institutionController.institution.value.type=='primary'?'Subject':'Course'}'),
                                     SizedBox(height: 5),
                                     StreamBuilder(
                                         stream: FirebaseFirestore.instance.
                                         collection('courses')
                                             .where('institutionID',isEqualTo:_tutorController.tutor.value.institutionID)
                                             .snapshots(),
                                         builder: (context, snapshot) {
                                           return snapshot.hasData ? DropdownSearch<String>(
                                             items: [
                                               ...
                                               snapshot.data!.docs.map<String>((e) => e.get('course')).toList()
                                             ],
                                             popupProps: PopupPropsMultiSelection.menu(
                                               fit: FlexFit.loose,
                                               showSelectedItems: true,
                                             ),
                                             selectedItem: '',
                                             onChanged: (value){
                                               course = value!;
                                             },
                                           ):DropdownSearch<String>(
                                             items: [
                                               'All',

                                             ],
                                             popupProps: PopupPropsMultiSelection.menu(
                                               fit: FlexFit.loose,
                                               showSelectedItems: true,
                                             ),
                                             selectedItem: '',
                                             onChanged: (value){

                                             },
                                           );
                                         }
                                     )
                                   ],
                                 ),
                               ),
                               SizedBox(height:30),
                               CustomButton(
                                   Text('ADD' ,style: TextStyle(color: Colors.white),),
                                   width: double.infinity,
                                   height: 38,
                                   onTap: (){
                                     if(course.isNotEmpty&&programme.isNotEmpty&&academic_year.isNotEmpty){
                                       FirebaseFirestore.instance.collection('my_classes').
                                       add(
                                           {
                                             'course':course,
                                             'programme':programme,
                                             'academic_year':academic_year,
                                             'tutor':_tutorController.tutor.value.uid,
                                             'institutionID':_institutionController.institution.value.id
                                           }
                                       ).then((value){
                                         course = '';
                                         programme = '';
                                         academic_year = '';
                                         _methods.shownackbar('Added successfully!', context);
                                       });
                                     }
                                   }
                               )
                             ],
                           )
                       ),
                     ),
                       Expanded(
                         child: Container(
                           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                           height: double.infinity,
                           child: Column(
                             children: [
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                               ),
                               Expanded(
                                 child: StreamBuilder(
                                   stream: FirebaseFirestore.instance.collection('my_classes').where('tutor', isEqualTo: _tutorController.tutor.value.uid).snapshots(),
                                   builder: (context,snapshot){
                                     return snapshot.hasData?
                                     GroupedListView<dynamic, String>(
                                       elements: snapshot.data!.docs,
                                       groupBy: (element) => element['programme'],
                                       groupSeparatorBuilder: (String groupByValue) => Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           SizedBox(height: 15),
                                           Text(groupByValue, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                                         ],
                                       ),
                                       itemBuilder: (context, dynamic element) =>
                                           Container(
                                             color: Colors.grey.withOpacity(0.05),
                                             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                             child: Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Text(element['academic_year'], style: TextStyle(fontWeight: FontWeight.w500),),
                                                 Text(element['course']),
                                               ],
                                             ),
                                           ),
                                       itemComparator: (item1, item2) => item1['course'].compareTo(item2['course']), // optional
                                       useStickyGroupSeparators: false, // optional
                                       floatingHeader: true, // optional
                                       order: GroupedListOrder.ASC, // optional
                                     ):Container();
                                   }
                                 ),
                               ),
                             ],
                           )
                         )
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

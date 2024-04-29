import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:stdominicsadmin/customs/custom_button.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import '../../controllers/institution_controller.dart';
import '../../controllers/selectedCourseController.dart';
import '../../controllers/tutorController.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:html' as html;
import '../../helpers/creds.dart';
import '../../models/book_model.dart';
import '../reader.dart';
import 'package:smart_dropdown/smart_dropdown.dart';


class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {

  TutorController _tutorController = Get.find();
  InstitutionController _institutionController = Get.find();

  SelectedCourseController _selectedCourseController = Get.find();

  var selectedFile = ''.obs;
  var selectedImage = ''.obs;
  var uploadprogress = 0.0.obs;
  String programme = '';
  String academic_year = '';

  List<String> uploadedFiles = [];
  List<html.FileUploadInputElement> selectedFiles = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  TextEditingController editController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
        uploadedFiles.add(downloadUrl);

        // Use the download URL as needed (e.g., store it in your database)
        print('Download URL: $downloadUrl');
      });
    } catch (error) {
      print('Error uploading to Firebase Storage: $error');
      // Handle the error as needed
    }
  }

  addBook(selectedCourse)async{

    for(int i = 0; i<selectedFiles.length; i++){
      await _uploadToFirebaseStorage(selectedFiles[i]);
    }

    Map<String,dynamic> data = {
      'title': titleController.text,
      'description': descriptionController.text,
      'cover': '',
      'book': uploadedFiles.first,
      'pages': '',
      'tutor': '${_tutorController.tutor.value.email}',
      'course': '$selectedCourse',
      'datetime': '${DateTime.now()}',
      'programme': programme,
      'academic_year':academic_year,
      'institutionID':_tutorController.tutor.value.institutionID
    };

    FirebaseFirestore.instance.collection('books').add(data).then((value){

      selectedFiles.clear();
      uploadedFiles.clear();
      Get.back();
    });
  }
  Future<html.FileUploadInputElement> _pickImage(BuildContext context) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Specify that only image files are allowed
    input.click();

    // Wait for the user to select a file
    await input.onChange.first;

    // Now you can upload the file to Firebase Storage
    setState(() {
      selectedImage.value = input.files!.first.name;
    });

    selectedFiles.add(input);

    return input;
  }
  Future<html.FileUploadInputElement> _pickFile(BuildContext context) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = '.pdf'; // Specify that only image files are allowed
    input.click();

    // Wait for the user to select a file
    await input.onChange.first;

    // Now you can upload the file to Firebase Storage
    setState(() {
      selectedFile.value = input.files!.first.name;
      selectedFiles.add(input);
    });

    return input;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            StreamBuilder(
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TouchRippleEffect(
                        onTap: (){
                          Get.defaultDialog(
                              title: 'Add Book',
                              titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Kara.blue),
                              titlePadding: EdgeInsets.symmetric(vertical: 20),
                              content: StatefulBuilder(
                                  builder: (context, state) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      width: 300,
                                      height: 380,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: TouchRippleEffect(
                                              rippleColor: Colors.grey,
                                              borderRadius: BorderRadius.circular(20),
                                              onTap: ()async{
                                                _pickFile(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(color: Colors.grey)
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.folder_copy, color: Colors.green,),
                                                    SizedBox(width: 20),
                                                    Expanded(child: Obx(()=> Text('${selectedFile.value.isEmpty?"Pdf File":selectedFile.value}', maxLines: 1,overflow: TextOverflow.ellipsis,)))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Colors.grey)
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: TextField(
                                                      controller: titleController,
                                                      decoration: InputDecoration(
                                                          hintText: 'Title',
                                                          contentPadding: EdgeInsets.zero,
                                                          border: InputBorder.none
                                                      ),
                                                    )
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.grey),

                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: TextField(
                                                      controller: descriptionController,
                                                      decoration: InputDecoration(
                                                          hintText: 'Description',
                                                          contentPadding: EdgeInsets.zero,
                                                          border: InputBorder.none
                                                      ),
                                                    )
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
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
                                                                  'All',
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
                                                                  'All',
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
                                          Spacer(),
                                          TouchRippleEffect(
                                            onTap: () {
                                              Get.back();
                                              Get.defaultDialog(
                                                  title: 'Uploading...',
                                                  titleStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Kara.blue),
                                                  titlePadding: EdgeInsets.only(top: 20),
                                                  content: Container(
                                                      child: Obx(()=> LinearProgressIndicator(value: uploadprogress.value/100,minHeight: 10,))
                                                  )
                                              );
                                              addBook(_selectedCourseController.selectedCourse.value);
                                            },
                                            borderRadius: BorderRadius.circular(20),
                                            rippleColor: Colors.green,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Kara.green
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                              child: Center(
                                                child: Text('Upload', style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              )
                          );
                        },
                        rippleColor: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                              color: Kara.green
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.white,),
                              Text('Add Book  ', style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Kara.background,
                      borderRadius: BorderRadius.circular(2)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_institutionController.institution.value.type=='primary'?'Subject':'Course'}', style: TextStyle(color: Colors.grey, fontSize: 12),),
                            Obx(()=>Text(_selectedCourseController.selectedCourse.value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                          ],
                        )
                      ),
                      Expanded(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('books')
                                .where('tutor', isEqualTo: '${_tutorController.tutor.value.email}').snapshots(),
                            builder: (context,snapshot){
                              if (snapshot.hasData&&snapshot.data!.size>0) {
                                return GroupedListView<dynamic, String>(
                                  shrinkWrap: true,
                                  elements: snapshot.data!.docs.where((item)=>
                                    item.get('course')==_selectedCourseController.selectedCourse.value
                                  ).toList(),
                                  groupBy: (element) => element['programme'],
                                  groupSeparatorBuilder: (String groupByValue) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15),
                                      Text(groupByValue, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                                    ],
                                  ),
                                  itemBuilder: (context, dynamic element) {
                                    BookModel book = BookModel(id: element.id, title: element['title'], description: element['description'], book: element['book'], cover: element['cover'], pages: element['pages']);

                                    return ListTile(
                                      onTap: (){
                                        Get.to(()=>Reader(book));
                                      },
                                      leading:  Image.asset('assets/bookpdf.png'),
                                      title: Text('${book.title}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Kara.primary),maxLines: 2, overflow: TextOverflow.ellipsis),
                                      subtitle: Text('${element['academic_year']}'),
                                      trailing: PopupMenuButton(
                                        icon: Icon(Icons.more_horiz),
                                        itemBuilder: (BuildContext context) {
                                          return [
                                              PopupMenuItem(child: Text('Open'), onTap: () {
                                                      Get.to(() => Reader(book));
                                                    }
                                                  ),
                                              PopupMenuItem(child: Text('Delete'), onTap: (){
                                                FirebaseFirestore.instance.collection('books').doc(element.id).delete();},
                                              ),

                                          ];
                                        },),
                                    );
                                  },
                                  itemComparator: (item1, item2) => item1['title'].compareTo(item2['title']), // optional
                                  useStickyGroupSeparators: false, // optional
                                  floatingHeader: true, // optional
                                  order: GroupedListOrder.ASC, // optional
                                );

                              } else {
                                return Container();
                              }
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]
        )
    );
  }
}

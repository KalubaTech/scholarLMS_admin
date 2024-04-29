import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_timetable/flutter_timetable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:stdominicsadmin/controllers/my_classes_controller.dart';
import 'package:stdominicsadmin/controllers/selected_timetable.dart';
import 'package:stdominicsadmin/controllers/teacher_controller.dart';
import 'package:stdominicsadmin/controllers/teachers_controller.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:stdominicsadmin/customs/content_wrapper.dart';
import 'package:stdominicsadmin/customs/kalubtn.dart';
import 'package:stdominicsadmin/customs/kalutext.dart';
import 'package:stdominicsadmin/helpers/date_formater.dart';
import 'package:stdominicsadmin/helpers/methods.dart';
import 'package:stdominicsadmin/models/timetable_model.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import 'package:flutter_time_range/flutter_time_range.dart';
import 'package:stdominicsadmin/styles/font_sizes.dart';
import '../../controllers/timetable_controller.dart';
import '../../customs/clikable_menu_item.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../customs/timetable_list_item_container.dart';


class ManageTimetable extends StatefulWidget {
  const ManageTimetable({Key? key}) : super(key: key);

  @override
  State<ManageTimetable> createState() => _ManageTimetableState();
}
enum DayOfWeek {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}
class _ManageTimetableState extends State<ManageTimetable> {

  int selectedMode = 1;

  TeachersController _teachersController = Get.find();
  TeacherController _tutorController = Get.find();

  List audience = [];
  List days = [];

  @override
  void initState() {
    super.initState();
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _itemDescriptionController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();

  DocumentSnapshot? currentTimetable;

  MyClassesController myClassesController = Get.find();

  var showAddform = false.obs;
  var showAddDataForm = false.obs;
  var showTimetablesList = false.obs;
  var selectedAudience = <String>[].obs;

  var starttimetext = ''.obs;
  var endtimetext = ''.obs;

  var items = [

  ].obs;

  var teachersItem = [];

  TimetableDataController timetableDataController = Get.find();

  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    List<TimetableModel> timetables = timetableDataController.timetables;

    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
            children: [
              Expanded(
                  child: GetBuilder<SelectedTimetable>(
                    builder: (timetable) {
                      return ContentWrapper(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month, color: CupertinoColors.activeGreen, size: 18,),
                                    SizedBox(width: 10,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("TIMETABLE ${timetable.selectedTimetable.value.title.isEmpty?"":"- ${timetable.selectedTimetable.value.title}"} ", style: TextStyle(color: Kara.primary, fontWeight: FontWeight.bold),),
                                        Text("${timetable.selectedTimetable.value.description.isEmpty?"":" (${timetable.selectedTimetable.value.description})"} ", style: TextStyle(fontSize: FontSize.mediumheadertext, color: CupertinoColors.systemGrey),)
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      child: Row(
                                        children: [
                                          ClickableMenuItem(
                                            iconData: Icons.add,
                                            onclick: (){
                                              showAddform.value = !showAddform.value;
                                            },
                                          ),
                                          SizedBox(width: 10,),
                                          ClickableMenuItem(
                                            iconData: Icons.dashboard,
                                            onclick: ()=>showTimetablesList.value = !showTimetablesList.value,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Obx(
                                ()=> Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: timetable.selectedTimetable.value.title.isEmpty?
                                        Container():
                                        Timetable(
                                          nowIndicatorColor: Kara.red,
                                          cornerBuilder: (date)=>Container(
                                              decoration: BoxDecoration(
                                                color: Kara.primary,
                                              ),
                                              child: Center(child: Text('${date.year}', style: TextStyle(fontSize: FontSize.mediumheadertext,color: Kara.secondary, fontWeight: FontWeight.bold),))
                                          ),
                                          items: _methods.getTimetableDataFromController(timetable.selectedTimetable.value.days,timetable.selectedTimetable.value.data.first),
                                          itemBuilder: (data)=>
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Kara.secondary.withOpacity(0.6)
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('${format2Time(TimeOfDay(hour: data.start.hour, minute: data.start.minute))} to ${format2Time(TimeOfDay(hour: data.end.hour, minute: data.end.minute))}', style: TextStyle(fontSize: FontSize.mediumheadertext,color: CupertinoColors.destructiveRed, fontWeight: FontWeight.w600),),
                                                    Text('${data.data.description}', style: TextStyle(color: Kara.primary, fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.w500),),
                                                    SizedBox(height: 5,),
                                                    data.data.teacher.toString().isEmpty?
                                                    Container():
                                                    SuperTooltip(
                                                      content: Container(
                                                        height: 150,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("Teacher:", softWrap: true, style: TextStyle(fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.bold, color: Kara.primary),),
                                                                    Text('Name: ${_teachersController.teachers.value.where((element) => element.fullname==data.data.teacher).first.fullname}', style: TextStyle(fontSize: FontSize.primarytext, fontWeight: FontWeight.w500),),
                                                                  ],
                                                                ),
                                                              ),

                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(8),
                                                                child: CachedNetworkImage(
                                                                  fit: BoxFit.cover,
                                                                  width: 150,
                                                                  height: 100,
                                                                  imageUrl: '${_teachersController.teachers.value.where((element) => element.fullname==data.data.teacher).first.photo}',
                                                                  errorWidget: (c,i,e)=>CircleAvatar(
                                                                    child: Icon(Icons.person, size: 30,),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Kara.white.withOpacity(0.5),
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(color: Kara.grey.withOpacity(0.3),spreadRadius: 1, blurRadius: 0.5)
                                                          ]
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(30),
                                                              child: CachedNetworkImage(
                                                                  width: 20,
                                                                  height: 20,
                                                                  imageUrl: '${_teachersController.teachers.value.where((element) => element.fullname==data.data.teacher).first.photo}',
                                                                  errorWidget: (c,i,e)=>CircleAvatar(
                                                                    child: Icon(Icons.person, size: 10,),
                                                                  ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            Text('${data.data.teacher}', style: TextStyle(color: Kara.primary, fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.w500),),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          headerCellBuilder: (date)=>
                                              Container(
                                                color: Kara.background,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('${["Monday","Tuesday","Wednesday","Thursday","Friday", "Saturday","Sunday"][date.weekday-1]}', style: TextStyle(fontWeight: FontWeight.w500, color: Kara.primary),),
                                                    Text('${formatDateOnly(date.toString())}', style: TextStyle(fontSize: FontSize.primarytext, color: CupertinoColors.systemGrey),)
                                                  ],
                                                ),
                                              ),
                                        ),
                                      ),
                                      Visibility(
                                          visible: showAddform.value,
                                          child: BounceInLeft(
                                            duration: Duration(seconds: 1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Kara.background,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Kara.grey,
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1)
                                                  )
                                                ]
                                              ),
                                              width: 300,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                    decoration: BoxDecoration(
                                                      border: BorderDirectional(bottom: BorderSide(width: 1, color: Kara.primary))
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text('CREATE TIMETABLE', style: TextStyle(color: Kara.primary, fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.w500),),
                                                        Spacer(),
                                                        ClickableMenuItem(
                                                            onclick: ()=>showAddform.value=false,
                                                            iconData: Icons.close,
                                                            color: Colors.red,
                                                            backgroundColor: Colors.red.withOpacity(0.2),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          child: Kalutext(
                                                              controller: _titleController,
                                                              backgroundColor: Colors.transparent,
                                                              border: Border.all(
                                                                  color: Colors.black38,
                                                                  width: 0.5
                                                              ),
                                                              borderRadius: BorderRadius.circular(5),
                                                              labelText: 'Title',
                                                              labelTextStyle: TextStyle(
                                                                fontSize: FontSize.primarytext,
                                                                color: Colors.green
                                                              ),
                                                              hintText: 'Enter Title',
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Kalutext(
                                                              controller: _descriptionController,
                                                              backgroundColor: Colors.transparent,
                                                              border: Border.all(
                                                                color: Colors.black54,
                                                                width: 0.5
                                                              ),
                                                              borderRadius: BorderRadius.circular(5),
                                                              labelText: 'Description',
                                                              labelTextStyle: TextStyle(
                                                                fontSize: FontSize.primarytext,
                                                                color: Colors.green
                                                              ),
                                                              hintText: 'Enter Description',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 20,),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Target Audience', style: TextStyle(fontSize: FontSize.primarytext, color: Colors.green),),
                                                        SizedBox(height: 10,),
                                                        DropdownSearch.multiSelection(
                                                          popupProps: PopupPropsMultiSelection.menu(
                                                              fit: FlexFit.loose,
                                                              showSearchBox: true,
                                                              searchDelay: Duration(milliseconds: 200),
                                                              searchFieldProps: TextFieldProps(
                                                                padding: EdgeInsets.symmetric(vertical: 0),
                                                              )
                                                          ),
                                                          onChanged: (value){
                                                            audience = value;
                                                          },
                                                          items: [
                                                            'You',
                                                            'All Teachers',
                                                            'All Classes',
                                                            ... myClassesController.myClasses.value.map((e) => '${e.academicYear} ${e.programme}').toList()
                                                          ],
                                                        ),
                                                        SizedBox(height: 20,),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Text('Items (${items.value.length} added)', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),),
                                                              SizedBox(width: 10,),
                                                              ClickableMenuItem(
                                                                backgroundColor: Colors.green.withOpacity(0.2),
                                                                onclick: () {
                                                                  Get.defaultDialog(
                                                                    title: 'Add Timetable Item',
                                                                    titleStyle: TextStyle(fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.bold, color: Kara.primary),
                                                                    content: Container(
                                                                      width: 300,
                                                                      child: ContentWrapper(
                                                                        height: 420,
                                                                        content: ListView(
                                                                          shrinkWrap: true,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Icon(Icons.calendar_today, size: 12, color: Colors.deepOrange,),
                                                                                SizedBox(width: 10,),
                                                                                Text('Days', style: TextStyle(fontSize: FontSize.mediumheadertext, color: Colors.green,fontWeight: FontWeight.w500),),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 10,),
                                                                            DropdownSearch.multiSelection(
                                                                              dropdownButtonProps: DropdownButtonProps(
                                                                                iconSize: 20
                                                                              ),
                                                                              popupProps: PopupPropsMultiSelection.menu(
                                                                                  fit: FlexFit.loose
                                                                              ),
                                                                              onChanged: (value){
                                                                                days = value;
                                                                              },
                                                                              items: [
                                                                                'Sunday',
                                                                                'Monday',
                                                                                'Tuesday',
                                                                                'Wednesday',
                                                                                'Thursday',
                                                                                'Friday',
                                                                                'Saturday'
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 15,),
                                                                            Row(
                                                                              children: [
                                                                                Icon(Icons.timelapse, size: 12, color: Colors.deepOrange,),
                                                                                SizedBox(width: 10,),
                                                                                Text('Period', style: TextStyle(fontSize: FontSize.mediumheadertext, color: Colors.green,fontWeight: FontWeight.w500),),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 10,),
                                                                            Container(
                                                                              height: 35,
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Obx(()=> Text('Start Time: ${starttimetext.value}', style: TextStyle(fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.w500, color: Kara.primary),)),
                                                                                        SizedBox(width: 10,),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Obx(()=> Text('End Time: ${endtimetext.value}', style: TextStyle(fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.w500, color: Kara.primary),)),
                                                                                      SizedBox(width: 10,),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Visibility(
                                                                              visible: true,
                                                                              child:  TimePicker(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(120),
                                                                                    image: DecorationImage(
                                                                                        image: AssetImage('assets/clock2.webp')
                                                                                    )
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Obx(() => Text('${starttimetext.value}'))
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                width: 120,
                                                                                height: 120,
                                                                                decoration: TimePickerDecoration(
                                                                                    baseColor: Colors.transparent,
                                                                                    clockNumberDecoration: TimePickerClockNumberDecoration(

                                                                                    ),
                                                                                    initHandlerDecoration: TimePickerHandlerDecoration(
                                                                                      icon: Icon(Icons.timelapse_outlined, color: Kara.primary,)
                                                                                    ),
                                                                                    endHandlerDecoration: TimePickerHandlerDecoration(
                                                                                        color: Kara.red.withOpacity(0.2),
                                                                                        icon: Icon(Icons.timelapse_outlined, color: Kara.red,)
                                                                                    ),
                                                                                    sweepDecoration: TimePickerSweepDecoration(pickerStrokeWidth: 2)
                                                                                ),
                                                                                initTime: PickedTime(h: 0, m: 0),
                                                                                endTime: PickedTime(h: 8, m: 0),
                                                                                onSelectionChange: (start, end, isDisableRange) {
                                                                                  starttimetext.value = '${start.h<10?'0${start.h}':start.h}:${start.m<10?'0${start.m}':start.m}';
                                                                                  endtimetext.value = '${end.h<10?'0${end.h}':end.h}:${end.m<10?'0${end.m}':end.m}';

                                                                                },
                                                                                onSelectionEnd: (start, end, isDisableRange) {

                                                                                },
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            Kalutext(
                                                                                controller: _itemDescriptionController,
                                                                                hintText: 'Describe Item (e.g. English period...)',
                                                                            ),
                                                                            SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                Icon(Icons.group, size: 12, color: Colors.deepOrange,),
                                                                                SizedBox(width: 10,),
                                                                                Text('Select Teacher:', style: TextStyle(fontSize: FontSize.mediumheadertext, color: Colors.green, fontWeight: FontWeight.w500),),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 10,),
                                                                            DropdownSearch.multiSelection(
                                                                              onChanged: (value){
                                                                                teachersItem = value;
                                                                              },
                                                                              popupProps: PopupPropsMultiSelection.menu(
                                                                                fit: FlexFit.loose,
                                                                                showSearchBox: true,
                                                                                searchDelay: Duration(milliseconds: 200),
                                                                                searchFieldProps: TextFieldProps(
                                                                                  padding: EdgeInsets.symmetric(vertical: 0),
                                                                                )
                                                                              ),
                                                                              items: [
                                                                                ... _teachersController.teachers.value.map((e) => '${e.fullname}').toList()
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 20,),
                                                                            Kalubtn(label: 'Save', onclick: (){
                                                                              Map<String,String> item = {
                                                                                "start": starttimetext.value,
                                                                                "end": endtimetext.value,
                                                                                "description": _itemDescriptionController.text,
                                                                                "teacher": teachersItem.first
                                                                              };

                                                                              items.value.add(item);
                                                                              Get.back();

                                                                            })
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  );
                                                                },
                                                                iconData: Icons.add,

                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                        Kalubtn(label: 'Finish',onclick: (){
                                                          Map<String,dynamic> data = {
                                                            "institutionID": _tutorController.teacher.value.institutionID,
                                                            "title":_titleController.text,
                                                            "description":_descriptionController.text,
                                                            "items": items,
                                                            "audience":audience,
                                                            "days": days,
                                                            "teacher": _tutorController.teacher.value,
                                                            "datetime":'${DateTime.now()}'
                                                          };

                                                          FirebaseFirestore.instance.collection('timetable').add(data);
                                                          showAddform.value = false;
                                                        },)
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                      Visibility(
                                          visible: showTimetablesList.value,
                                          child: BounceInLeft(
                                            duration: Duration(seconds: 1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Kara.background,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Kara.grey,
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1)
                                                  )
                                                ]
                                              ),
                                              width: 300,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                    decoration: BoxDecoration(
                                                      border: BorderDirectional(bottom: BorderSide(width: 1, color: Kara.primary))
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text('TIMETABLES', style: TextStyle(color: Kara.primary, fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.w500),),
                                                        Spacer(),
                                                        ClickableMenuItem(
                                                            onclick: ()=>showTimetablesList.value=false,
                                                            iconData: Icons.close,
                                                            color: Colors.red,
                                                            backgroundColor: Colors.red.withOpacity(0.2),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal:0,vertical: 20),
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      children: [
                                                       ... timetables.map((e) =>
                                                           TimetableListItemContainer(
                                                             timetableModel: e,
                                                           )
                                                       )

                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )

                      );
                    }
                  )
              )
            ]
        )
    );
  }}
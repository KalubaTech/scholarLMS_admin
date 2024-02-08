import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timetable/flutter_timetable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:stdominicsadmin/controllers/tutorController.dart';
import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:stdominicsadmin/helpers/date_formater.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;
import 'package:flutter_time_range/flutter_time_range.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:timetable_view/timetable_view.dart';
import '../../models/timetable_model.dart';

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

  TutorController _tutorController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  String _day = 'Day';
  String _course = 'Course';
  TimeOfDay _startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 0, minute: 0);

  List<TimetableEntry> tableEntries = [];

  // Function to check for a collision before adding a new entry
  bool hasCollision(TimetableEntry newEntry) {
    for (TimetableEntry existingEntry in tableEntries) {
      if (existingEntry.day == newEntry.day &&
          overlappingTime(
              existingEntry.startTime, existingEntry.endTime, newEntry.startTime, newEntry.endTime)) {
        return true; // Collision found
      }
    }
    return false; // No collision
  }

  // Function to check if two time ranges overlap
  bool overlappingTime(TimeOfDay start1, TimeOfDay end1, TimeOfDay start2, TimeOfDay end2) {
    final DateTime startDateTime1 = DateTime(1, 1, 1, start1.hour, start1.minute);
    final DateTime endDateTime1 = DateTime(1, 1, 1, end1.hour, end1.minute);
    final DateTime startDateTime2 = DateTime(1, 1, 1, start2.hour, start2.minute);
    final DateTime endDateTime2 = DateTime(1, 1, 1, end2.hour, end2.minute);

    return startDateTime1.isBefore(endDateTime2) && endDateTime1.isAfter(startDateTime2);
  }

  // Function to add a new entry only if there is no collision
  void addEntry(TimetableEntry newEntry) {
    if(tableEntries.isNotEmpty){
      if (!hasCollision(newEntry) && !overlappingTime(newEntry.startTime, newEntry.endTime, tableEntries.last.startTime, tableEntries.last.endTime)) {
        tableEntries.add(newEntry);
      } else {
        print('Collision detected. Entry not added.');
      }
    }else{
      if (!hasCollision(newEntry)) {
        tableEntries.add(newEntry);
      } else {
        print('Collision detected. Entry not added.');
      }
    }
  }

  // 24 Hour Format
  Future<void> showTimeRangePicker(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose period time"),
            content: Container(
              width: 300,
              child: TimeRangePicker(
                initialFromHour: DateTime.now().hour,
                initialFromMinutes: DateTime.now().minute,
                initialToHour: DateTime.now().hour,
                initialToMinutes: DateTime.now().minute,
                backText: "Back",
                nextText: "Next",
                cancelText: "Cancel",
                selectText: "Select",
                editable: true,
                is24Format: true,
                disableTabInteraction: true,
                iconCancel: Icon(Icons.cancel_presentation, size: 12),
                iconNext: Icon(Icons.arrow_forward, size: 12),
                iconBack: Icon(Icons.arrow_back, size: 12),
                iconSelect: Icon(Icons.check, size: 12),
                separatorStyle: TextStyle(color: Colors.grey[900], fontSize: 30),
                onSelect: (from, to) {
                  setState(() {
                    _startTime = from;
                    _endTime = to;
                  });
                  Navigator.pop(context);
                },
                onCancel: () => Navigator.pop(context),
              ),
            ),
          );
        });
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();

  DocumentSnapshot? currentTimetable;

  InstitutionController _institutionController = Get.find();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _sk,
        drawer: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 2, offset: Offset(1,2))
                ]
            ),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('school_timetable').where('institutionID', isEqualTo:_institutionController.institution.value.id).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data!.size>0){
                      return Container(
                          child: Column(
                            children: [
                              Container(
                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                    child: Text('Timetables', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                                  ),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.size,
                                    itemBuilder: (context,index){
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: TouchRippleEffect(
                                              rippleColor: Colors.grey.withOpacity(0.4),
                                              onTap: (){
                                                currentTimetable = snapshot.data!.docs[index];
                                                setState(() {
                                                  Get.back();
                                                });

                                              },
                                              child: MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: Container(
                                                    decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(color: Colors.grey.withOpacity(0.4)))),
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      (currentTimetable!=null?
                                                      currentTimetable!.id == snapshot.data!.docs[index].id:false)
                                                          ?Row(
                                                            children: [
                                                              Icon(Icons.check_circle, color: kara.Colors.green),
                                                              SizedBox(width: 10,),
                                                            ],
                                                          ):Container(),
                                                      Text('${snapshot.data!.docs[index].get('title')}'),
                                                    ],
                                                  )
                                              ),
                                            )),
                                          ),
                                          TouchRippleEffect(
                                              rippleColor: Colors.grey.withOpacity(0.4),
                                              onTap: (){
                                                FirebaseFirestore.instance.collection('school_timetable')
                                                    .doc(snapshot.data!.docs[index].id)
                                                    .delete();
                                              },
                                              child: Icon(Icons.delete, color: Colors.red)
                                          )
                                        ],
                                      );
                                    }
                                ),
                              ),
                            ],
                          )
                      );
                    }else{
                      return Container();
                    }
                  }else{
                    return Container();
                  }
                }
            )
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(0)
                ),
                child: Column(
                    children: [
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: kara.Colors.primary,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0))
                        ),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () async => Navigator.pop(context),
                              child: Row(
                                children: const [
                                  Icon(Icons.chevron_left_outlined, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text("TIMETABLE", style: TextStyle(color: Colors.white, fontSize: 16)),
                                ],
                              ),
                            ),
                            const Spacer(),

                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                            color: kara.Colors.background,
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey, blurRadius: 2)
                                            ]
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(icon: Icon(Icons.menu), onPressed: ()=>_sk.currentState!.openDrawer()),
                                            Text('${currentTimetable==null?'Select Timetable':currentTimetable!.get('title')}'),
                                            const Spacer(),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: currentTimetable!=null
                                            ?
                                        TimetableView(
                                          timetableStyle: TimetableStyle(
                                              laneWidth: 150,
                                              timeItemTextColor: kara.Colors.white,
                                              laneColor: Colors.grey.withOpacity(0.4),
                                              timelineBorderColor: Colors.cyan,
                                              timelineItemColor: Colors.blueGrey,
                                              mainBackgroundColor: Colors.grey.withOpacity(0.4),
                                          ),
                                          laneEventsList: [
                                            LaneEvents(
                                                lane: Lane(
                                                  name: 'Sunday', laneIndex: 0,
                                                ),
                                                events: currentTimetable!.get('timetable').where((element)=> element['day']=='sunday').toList().
                                                map<TableEvent>((e)=>
                                                    TableEvent(
                                                      location: '   |  ${e['startTime'].toString().capitalizeFirst} to ${e['endtTime'].toString().capitalizeFirst}',
                                                      title: '${e['course'].toString().capitalizeFirst}',
                                                      startTime: TableEventTime(hour: int.parse(e['startTime'].split(':').first), minute: int.parse(e['startTime'].split(':').last)),
                                                      endTime: TableEventTime(hour: int.parse(e['endtTime'].split(':').first), minute: int.parse(e['endtTime'].split(':').last)),
                                                      eventId: 1,
                                                      laneIndex: 0,
                                                    )
                                                ).toList()
                                            ),
                                            LaneEvents(
                                                lane: Lane(
                                                  name: 'Monday', laneIndex: 0,
                                                ),
                                                events: currentTimetable!.get('timetable').where((element)=> element['day']=='monday').toList().
                                                map<TableEvent>((e)=>
                                                    TableEvent(
                                                      location:'   |  ${e['startTime'].toString().capitalizeFirst} to ${e['endtTime'].toString().capitalizeFirst}',
                                                      title: '${e['course'].toString().capitalizeFirst}',
                                                      startTime: TableEventTime(hour: int.parse(e['startTime'].split(':').first), minute: int.parse(e['startTime'].split(':').last)),
                                                      endTime: TableEventTime(hour: int.parse(e['endtTime'].split(':').first), minute: int.parse(e['endtTime'].split(':').last)),
                                                      eventId: 1,
                                                      laneIndex: 1,
                                                    )
                                                ).toList()
                                            ),
                                            LaneEvents(
                                                lane: Lane(
                                                  name: 'Tuesday', laneIndex: 0,
                                                ),
                                                events: currentTimetable!.get('timetable').where((element)=> element['day']=='tuesday').toList().
                                                map<TableEvent>((e)=>
                                                    TableEvent(
                                                      location: '   |  ${e['startTime'].toString().capitalizeFirst} to ${e['endtTime'].toString().capitalizeFirst}',
                                                      title: '${e['course'].toString().capitalizeFirst}',
                                                      startTime: TableEventTime(hour: int.parse(e['startTime'].split(':').first), minute: int.parse(e['startTime'].split(':').last)),
                                                      endTime: TableEventTime(hour: int.parse(e['endtTime'].split(':').first), minute: int.parse(e['endtTime'].split(':').last)),
                                                      eventId: 1,
                                                      laneIndex: 2,
                                                    )
                                                ).toList()
                                            ),
                                            LaneEvents(
                                                lane: Lane(
                                                  name: 'Wednesday', laneIndex: 0,
                                                ),
                                                events: currentTimetable!.get('timetable').where((element)=> element['day']=='wednesday').toList().
                                                map<TableEvent>((e)=>
                                                    TableEvent(
                                                      location: '   |  ${e['startTime'].toString().capitalizeFirst} to ${e['endtTime'].toString().capitalizeFirst}',
                                                      title: '${e['course'].toString().capitalizeFirst}',
                                                      startTime: TableEventTime(hour: int.parse(e['startTime'].split(':').first), minute: int.parse(e['startTime'].split(':').last)),
                                                      endTime: TableEventTime(hour: int.parse(e['endtTime'].split(':').first), minute: int.parse(e['endtTime'].split(':').last)),
                                                      eventId: 1,
                                                      laneIndex: 3,
                                                    )
                                                ).toList()
                                            ),
                                            LaneEvents(
                                                lane: Lane(
                                                  name: 'Thursday', laneIndex: 0,
                                                ),
                                                events: currentTimetable!.get('timetable').where((element)=> element['day']=='thursday').toList().
                                                map<TableEvent>((e)=>
                                                    TableEvent(
                                                      location:'   |  ${e['startTime'].toString().capitalizeFirst} to ${e['endtTime'].toString().capitalizeFirst}',
                                                      title: '${e['course'].toString().capitalizeFirst}',
                                                      startTime: TableEventTime(hour: int.parse(e['startTime'].split(':').first), minute: int.parse(e['startTime'].split(':').last)),
                                                      endTime: TableEventTime(hour: int.parse(e['endtTime'].split(':').first), minute: int.parse(e['endtTime'].split(':').last)),
                                                      eventId: 1,
                                                      laneIndex: 4,
                                                    )
                                                ).toList()
                                            ),
                                            LaneEvents(
                                                lane: Lane(
                                                  name: 'Friday', laneIndex: 0,
                                                ),
                                                events: currentTimetable!.get('timetable').where((element)=> element['day']=='friday').toList().
                                                map<TableEvent>((e)=>
                                                    TableEvent(
                                                      location: '   |  ${e['startTime'].toString().capitalizeFirst} to ${e['endtTime'].toString().capitalizeFirst}',
                                                      title: '${e['course'].toString().capitalizeFirst}',
                                                      startTime: TableEventTime(hour: int.parse(e['startTime'].split(':').first), minute: int.parse(e['startTime'].split(':').last)),
                                                      endTime: TableEventTime(hour: int.parse(e['endtTime'].split(':').first), minute: int.parse(e['endtTime'].split(':').last)),
                                                      eventId: 1,
                                                      laneIndex: 5,
                                                    )
                                                ).toList()
                                            ),
                                            LaneEvents(
                                                lane: Lane(
                                                  name: 'Saturday', laneIndex: 0,
                                                ),
                                                events: currentTimetable!.get('timetable').where((element)=> element['day']=='saturday').toList().
                                                map<TableEvent>((e)=>
                                                    TableEvent(
                                                      location: '   |  ${e['startTime'].toString().capitalizeFirst} to ${e['endtTime'].toString().capitalizeFirst}',
                                                      title: '${e['course'].toString().capitalizeFirst}',
                                                      startTime: TableEventTime(hour: int.parse(e['startTime'].split(':').first), minute: int.parse(e['startTime'].split(':').last)),
                                                      endTime: TableEventTime(hour: int.parse(e['endtTime'].split(':').first), minute: int.parse(e['endtTime'].split(':').last)),
                                                      eventId: 1,
                                                      laneIndex: 6,
                                                    )
                                                ).toList()
                                            ),
                                          ],
                                          onEmptySlotTap: (int laneIndex, TableEventTime start, TableEventTime end) {

                                          },
                                          onEventTap: (TableEvent event) {

                                          },
                                        )
                                            :
                                        Expanded(
                                          child: Container(
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore.instance.collection('school_timetable').where('institutionID', isEqualTo: _institutionController.institution.value.id).snapshots(),
                                                builder: (context,snapshot){
                                                  if(snapshot.hasData){
                                                    if(snapshot.data!.size>0){
                                                      return Container(
                                                        width: 300,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SizedBox(height: 100),
                                                              Container(
                                                                child: Text('Choose calendar to view')
                                                              ),
                                                              Expanded(
                                                                child: ListView.builder(
                                                                    itemCount: snapshot.data!.size,
                                                                    itemBuilder: (context,index){
                                                                      return TextButton(
                                                                          onPressed: (){
                                                                            currentTimetable = snapshot.data!.docs[index];
                                                                            setState(() {});
                                                                          },
                                                                          child: Text('${snapshot.data!.docs[index].get('title')}')
                                                                      );
                                                                    }
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                      );
                                                    }else{
                                                      return Container();
                                                    }
                                                  }else{
                                                    return Container();
                                                  }
                                                }
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Container(
                                width: 400,
                                decoration: BoxDecoration(
                                  border: BorderDirectional(
                                      start: BorderSide(color: Colors.grey, width: 2)
                                  ),

                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: kara.Colors.background,
                                              boxShadow: [
                                                BoxShadow(color: Colors.grey, blurRadius: 2)
                                              ]
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          child: Center(child: Text('Create Timetable', style: TextStyle(fontSize: 20, fontWeight:  FontWeight.w500)))
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: MouseRegion(
                                                      cursor: SystemMouseCursors.click,
                                                      child: TouchRippleEffect(
                                                          rippleColor: Colors.grey.withOpacity(0.4),
                                                          onTap: ()async{
                                                            Get.defaultDialog(
                                                                title: 'Select Day',
                                                                titleStyle: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16
                                                                ),
                                                                titlePadding: EdgeInsets.symmetric(vertical: 20),
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                                content: Container(
                                                                    width: 180,
                                                                    height: 240,
                                                                    child: ListView(
                                                                        shrinkWrap: true,
                                                                        children: [
                                                                          ListTile(
                                                                              onTap: (){
                                                                                setState(() {
                                                                                  _day = 'monday';
                                                                                });
                                                                                Get.back();
                                                                              },
                                                                              title: Text('Monday', style: TextStyle(fontWeight: FontWeight.bold))
                                                                          ),
                                                                          ListTile(
                                                                              onTap: (){
                                                                                setState(() {
                                                                                  _day = 'tuesday';
                                                                                });
                                                                                Get.back();
                                                                              },
                                                                              title: Text('Tuesday', style: TextStyle(fontWeight: FontWeight.bold))
                                                                          ),
                                                                          ListTile(
                                                                              onTap: (){
                                                                                setState(() {
                                                                                  _day = 'wednesday';
                                                                                });
                                                                                Get.back();
                                                                              },
                                                                              title: Text('Wednesday', style: TextStyle(fontWeight: FontWeight.bold))
                                                                          ),
                                                                          ListTile(
                                                                              onTap: (){
                                                                                setState(() {
                                                                                  _day = 'thursday';
                                                                                });
                                                                                Get.back();
                                                                              },
                                                                              title: Text('Thursday', style: TextStyle(fontWeight: FontWeight.bold))
                                                                          ),
                                                                          ListTile(
                                                                              onTap: (){
                                                                                setState(() {
                                                                                  _day = 'friday';
                                                                                });
                                                                                Get.back();
                                                                              },
                                                                              title: Text('Friday', style: TextStyle(fontWeight: FontWeight.bold))
                                                                          ),
                                                                        ]
                                                                    )
                                                                )
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                color: kara.Colors.background,
                                                                boxShadow: [
                                                                  BoxShadow(color: Colors.black38, blurRadius: 2,offset: Offset(1, 1))
                                                                ]
                                                            ),
                                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.calendar_view_day_rounded),
                                                                SizedBox(width: 10),
                                                                Text('${_day.capitalizeFirst}'),
                                                              ],
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20,),
                                                Expanded(
                                                  child: Container(
                                                    child: MouseRegion(
                                                      cursor: SystemMouseCursors.click,
                                                      child: TouchRippleEffect(
                                                          rippleColor: Colors.grey.withOpacity(0.4),
                                                          onTap: ()async{
                                                            showTimeRangePicker(context);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                color: kara.Colors.background,
                                                                boxShadow: [
                                                                  BoxShadow(color: Colors.black38, blurRadius: 2,offset: Offset(1, 1))
                                                                ]
                                                            ),
                                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.timelapse),
                                                                SizedBox(width: 10),
                                                                Text('${(_startTime == TimeOfDay(hour: 0,minute: 0) && _endTime == TimeOfDay(hour: 0,minute: 0))?'Period':'${formatTime(_startTime)} to ${formatTime(_endTime)}'}'),
                                                              ],
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: TouchRippleEffect(
                                                    rippleColor: Colors.grey.withOpacity(0.4),
                                                    onTap: ()async{
                                                      Get.defaultDialog(
                                                          title: 'Select Course',
                                                          titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          content: MouseRegion(
                                                            cursor: SystemMouseCursors.click,
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: 10
                                                              ),
                                                              width: 350,
                                                              height: 400,
                                                              child: StreamBuilder(
                                                                  stream: FirebaseFirestore.instance.collection('courses')
                                                                      .where('institutionID', isEqualTo:_institutionController.institution.value.id)
                                                                      .snapshots(),
                                                                  builder: (context, snapshot) {
                                                                    return snapshot.hasData&&snapshot.data!.size>0?SearchableList(
                                                                        initialList: snapshot.data!.docs,
                                                                        builder: (users,i,course) {
                                                                          return MouseRegion(
                                                                            cursor: SystemMouseCursors.click,
                                                                            child: TouchRippleEffect(
                                                                              rippleColor: Colors.grey.withOpacity(0.4),
                                                                              onTap: (){
                                                                                Get.back();
                                                                                setState((){
                                                                                  _course = course.get('course');
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                      border: BorderDirectional(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))
                                                                                  ),
                                                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                                                  child: Text(course.get('course'))
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        filter: (value) => snapshot.data!.docs.where((element) => element.get('course').toLowerCase().contains(value),).toList(),
                                                                        emptyWidget:  Container(),
                                                                        inputDecoration: InputDecoration(
                                                                          labelText: "Search",
                                                                          fillColor: Colors.white,
                                                                          contentPadding: EdgeInsets.symmetric(horizontal:20),
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderSide: const BorderSide(
                                                                              color: Colors.blue,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                          ),
                                                                        )
                                                                    ):Container();
                                                                  }
                                                              ),
                                                            ),
                                                          )
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: kara.Colors.background,
                                                          boxShadow: [
                                                            BoxShadow(color: Colors.black38, blurRadius: 2,offset: Offset(1, 1))
                                                          ]
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.menu_open_sharp),
                                                          SizedBox(width: 10),
                                                          Expanded(child: Text('${_course.capitalizeFirst}', maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: TouchRippleEffect(
                                                      rippleColor: Colors.grey.withOpacity(0.4),
                                                      onTap: (){
                                                        TimetableEntry entry = TimetableEntry(day: _day, course: _course, startTime: _startTime, endTime: _endTime);
                                                        setState(() {
                                                          addEntry(entry);
                                                        });

                                                      },
                                                      child: Container(
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: kara.Colors.background,
                                                            boxShadow: [
                                                              BoxShadow(color: Colors.black38, blurRadius: 2,offset: Offset(1, 1))
                                                            ]
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.add),
                                                            SizedBox(width: 10),
                                                            Text('Add'),
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                ),
                                                tableEntries.length>0?MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: TouchRippleEffect(
                                                      rippleColor: Colors.grey.withOpacity(0.4),
                                                      onTap: ()async{
                                                        Get.defaultDialog(
                                                            title: '',
                                                            content: Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.grey.withOpacity(0.3),
                                                                          borderRadius: BorderRadius.circular(5)
                                                                      ),
                                                                      child: TextField(
                                                                        controller: _titleController,
                                                                        decoration: InputDecoration(
                                                                            hintText: 'Title',
                                                                            border: InputBorder.none
                                                                        ),
                                                                      )
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.grey.withOpacity(0.3),
                                                                        borderRadius: BorderRadius.circular(5)
                                                                    ),
                                                                    child: TextField(
                                                                      controller: _descriptionController,
                                                                      decoration: InputDecoration(
                                                                          hintText: 'Description',
                                                                          border: InputBorder.none
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                  TouchRippleEffect(
                                                                      onTap: ()async{
                                                                        List<Map<String,dynamic>> data = await tableEntries.map<Map<String,dynamic>>((entry){
                                                                          return {
                                                                            'startTime': formatTime(entry.startTime),
                                                                            'endtTime': formatTime(entry.endTime),
                                                                            'course': entry.course,
                                                                            'day':entry.day
                                                                          };
                                                                        }).toList();

                                                                        FirebaseFirestore.instance
                                                                            .collection('school_timetable')
                                                                            .add({
                                                                          'tutor': _tutorController.tutor.value.uid,
                                                                          'title': _titleController.text,
                                                                          'description': _descriptionController.text,
                                                                          'timetable':data,
                                                                          'datetime': '${DateTime.now()}',
                                                                          'institutionID':_institutionController.institution.value.id,
                                                                        }).then((value) => setState(()=>tableEntries.clear()));

                                                                        Get.back();
                                                                      },
                                                                      borderRadius: BorderRadius.circular(5),
                                                                      rippleColor: Colors.grey.withOpacity(0.4),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            color: kara.Colors.primary,
                                                                            borderRadius: BorderRadius.circular(5)
                                                                        ),
                                                                        height: 35,
                                                                        width: double.infinity,
                                                                        child: Center(child: Text('Finish', style: TextStyle(color: Colors.white),)),
                                                                      )
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: kara.Colors.primary,
                                                            boxShadow: [
                                                              BoxShadow(color: Colors.black38, blurRadius: 2,offset: Offset(1, 1))
                                                            ]
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                        child: Row(
                                                          children: [
                                                            Text('Done', style: TextStyle(color: Colors.white),),
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                ):Container(),
                                              ],
                                            ),
                                            Divider(),
                                            Container(
                                              child: Text('Entries', style: TextStyle(fontWeight: FontWeight.bold),),
                                            ),
                                            SizedBox(height: 10),
                                            GroupedListView<TimetableEntry, String>(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              elements: tableEntries,
                                              groupBy: (element) => element.day,
                                              groupSeparatorBuilder: (String groupByValue) => Text(groupByValue.capitalizeFirst!, style: TextStyle(fontWeight: FontWeight.bold),),
                                              itemBuilder: (context, element) => Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text('  ${formatTime(element.startTime)} - ${formatTime(element.endTime)}'),
                                                        SizedBox(width: 10),
                                                        Expanded(child: Text(element.course, overflow: TextOverflow.ellipsis,maxLines: 2,)),
                                                      ],
                                                    ),
                                                  ),
                                                  TouchRippleEffect(
                                                      onTap: (){
                                                        setState(() {
                                                          tableEntries.remove(element);
                                                        });
                                                      },
                                                      rippleColor: Colors.grey.withOpacity(0.4),
                                                      child: MouseRegion(
                                                          cursor: SystemMouseCursors.click,
                                                          child: Icon(Icons.delete, color: Colors.red,)
                                                      )
                                                  )
                                                ],
                                              ),
                                              itemComparator: (item1, item2) => item1.day.compareTo(item2.day), // optional
                                              useStickyGroupSeparators: true, // optional
                                              floatingHeader: false, // optional
                                              order: GroupedListOrder.ASC, // optional
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                )
                            )
                          ],
                        ),
                      )
                    ]
                )
            )
        ),
      );
  }
}

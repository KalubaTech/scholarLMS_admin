import 'package:stdominicsadmin/models/timetable_item_data.dart';

class TimetableModel {
  String id;
  String title;
  String description;
  String teacher;
  List days;
  List audience;
  String datetime;
  List<TimetableItemData> data;

  TimetableModel({
    required this.id,
    required this.title,
    required this.description,
    required this.audience,
    required this.days,
    required this.data,
    required this.teacher,
    required this.datetime
  });

}
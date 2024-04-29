class ResultModel {
  String id;
  String marks;
  String course;
  String studentId;
  String academicYear;
  String tutor;
  String reason;
  String datetime;

  ResultModel({
    required this.id,
    required this.marks,
    required this.course,
    required this.academicYear,
    required this.reason,
    required this.tutor,
    required this.studentId,
    required this.datetime
  });
}
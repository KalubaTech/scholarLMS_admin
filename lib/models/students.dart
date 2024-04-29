class StudentModel {
  String uid;
  String academicYear;//grade
  String name;
  String gender;
  String email;
  String intake;
  bool isfreezed;
  String photo;
  String programme;
  String guardianPhone;
  String guardianRelationship;

  StudentModel({
    required this.uid,
    required this.name,
    required this.academicYear,
    required this.programme,
    required this.photo,
    required this.email,
    required this.gender,
    required this.intake,
    required this.isfreezed,
    required this.guardianPhone,
    required this.guardianRelationship

   });
}
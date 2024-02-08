

class TutorModel {
  String uid;
  String name;
  String email;
  String password;
  String institutionID;
  List<dynamic> courses;

  TutorModel({required this.uid, required this.email, required this.password, required this.name, required this.courses, required this.institutionID});
}
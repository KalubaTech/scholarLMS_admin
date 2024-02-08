

class StudentModel {
  String id;
  String displayName;
  String email;
  String photo;
  String intake;
  String institutionID;
  String academic_year;
  bool isFreezed;
  String programme;
  String gender;

  StudentModel(
      {
        required this.id,
        required this.displayName,
        required this.email,
        required this.photo,
        required this.institutionID,
        required this.gender,
        required this.programme,
        required this.isFreezed,
        required this.academic_year,
        required this.intake
      });

}
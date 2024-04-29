class TutorModel {
  String uid;
  String email;
  String password;
  String name;
  List courses;
  String institutionID;
  String photo;


    TutorModel(
        {
          required this.uid,
          required this.name,
          required this.email,
          required this.password,
          required this.photo,
          required this.institutionID,
          required this.courses
        }
      );

  }


class InstitutionModel {
  String uid;
  String name;
  String motto;
  String admin;
  String logo;
  String type;
  String country;
  String district;
  String province;
  String status;
  String subscriptionType;

  InstitutionModel(
      {
        required this.uid,
        required this.name,
        required this.admin,
        required this.logo,
        required this.motto,
        required this.type,
        required this.status,
        required this.province,
        required this.district,
        required this.country,
        required this.subscriptionType

      }
      );
}
import 'package:get/get.dart';
import 'package:stdominicsadmin/models/institution_model.dart';

class InstitutionController extends GetxController{

  var institution = InstitutionModel(
      uid: '',
      name: '',
      admin: '',
      logo: '',
      motto: '',
      type: '',
      subscriptionType: '',
      province: '',
      district: '',
      country: '',
      status: ''
  ).obs;


  void updateInstitution(InstitutionModel institutionModel){
    institution.value = institutionModel;

    update();
  }


}
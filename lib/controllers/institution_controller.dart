import 'package:get/get.dart';
import 'package:stdominicsadmin/models/institution_model.dart';

class InstitutionController extends GetxController{

  var institution = InstitutionModel(
      id: '',
      name: '',
      admin: '',
      logo: '',
      motto: '',
      type: ''
  ).obs;


  void updateInstitution(InstitutionModel institutionModel){
    institution.value = institutionModel;

    update();
  }


}
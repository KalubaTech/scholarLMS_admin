import 'package:stdominicsadmin/controllers/institution_controller.dart';
import 'package:get/get.dart';

class Creds{

  InstitutionController _institutionController = Get.find();

   String coursesubect(){

    return '${_institutionController.institution.value.type=='primary'?'Subject':'Course'}';
  }

}


import 'package:get/get.dart';

class SelectedStudentsController extends GetxController{
  var selectedItems = <String>[].obs;

  void updateItem(String item){
    selectedItems.add(item);
    update();
  }
  void removeItem(String item){
    selectedItems.remove(item);
    update();
  }

  void selectAll(List<String> students){
    selectedItems.value = students;
    update();

  }

  void unSelectAll(){
    selectedItems.clear();
    update();

  }


}
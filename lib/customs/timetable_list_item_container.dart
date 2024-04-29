import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stdominicsadmin/controllers/selected_timetable.dart';
import 'package:stdominicsadmin/models/timetable_model.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import 'package:stdominicsadmin/styles/font_sizes.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class TimetableListItemContainer extends StatelessWidget {
  TimetableModel timetableModel;
  TimetableListItemContainer({required this.timetableModel});

  SelectedTimetable selectedTimetable = Get.find();

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    isSelected = timetableModel == selectedTimetable.selectedTimetable.value;
    return TouchRippleEffect(
      onTap: (){
        selectedTimetable.selectedTimetable.value = timetableModel;
        selectedTimetable.update();
      },
      rippleColor: Kara.background2.withOpacity(0.2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(vertical: BorderSide(color: Kara.background2.withOpacity(0.4), width: 0.5))
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isSelected?BounceInUp(child: Icon(Icons.arrow_right, color: Colors.green,size: 20,)):Container(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${timetableModel.title}', style: TextStyle(fontSize: FontSize.mediumheadertext, fontWeight: FontWeight.w600),),
                    Text('${timetableModel.description}', style: TextStyle(fontSize: FontSize.primarytext),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

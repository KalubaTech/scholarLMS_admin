import 'package:flutter/material.dart';
import 'package:stdominicsadmin/controllers/current_widget.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:get/get.dart';

import '../styles/colors.dart';
import '../styles/font_sizes.dart';

class SidebarListItem extends StatelessWidget {
  String title;
  Function() onclick;
  Icon? icon;
  Widget? suffix;
  SidebarListItem({required this.title, required this.onclick, this.icon, this.suffix});


  CurrentWidget currentWidget = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> Stack(
          children: [
            Container(
            decoration: BoxDecoration(
              color: currentWidget.currentWidget.value == title ? Color(
                  0xE2525459) : Colors.transparent,
              border: BorderDirectional(bottom: BorderSide(width: 0.5, color: Color(
                  0xFA575D69)))
            ),
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TouchRippleEffect(
                  onTap: onclick,
                  rippleColor: Colors.grey.withOpacity(0.3),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            icon??Container(),
                            SizedBox(width: 10),
                            Text('$title', style: TextStyle(color: Kara.white, fontSize: FontSize.mediumheadertext),),
                          ],
                        ),
                        Spacer(),
                        suffix??Container(),

                      ],
                    ),
                  ),
                )
            ),
                  ),
            currentWidget.currentWidget.value == title ? Positioned(
                right: -10,
                top: 8,
                child: Icon(Icons.arrow_left_outlined, color: Kara.background, size: 25,)
            ):Container(),
          ],
        ),
    );
  }
}

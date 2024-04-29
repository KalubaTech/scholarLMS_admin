import 'package:flutter/material.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;

import '../styles/colors.dart';


class CustomButton extends StatelessWidget {
  Text label;
  double? height;
  double? width;
  BorderRadius? borderRadius;
  BoxDecoration? decoration;
  void Function() onTap;


  CustomButton(this.label,{this.borderRadius,required this.onTap,this.decoration,this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TouchRippleEffect(
        borderRadius: BorderRadius.circular(10),
        rippleColor: Colors.grey,
        onTap: onTap,
        child: Container(
          height: height??30,
          width: width??100,
          decoration: decoration??BoxDecoration(
              color: Kara.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    blurRadius: 2,
                    offset: Offset(1, 2)
                )
              ]
          ),
          child: Center(
            child: label,
          ),
        ),
      ),
    );
  }
}

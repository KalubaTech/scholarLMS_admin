import 'package:flutter/material.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import '../styles/colors.dart';

class Kalubtn extends StatelessWidget {

  String label;
  double? borderRadius;
  Color? backgroundColor;
  EdgeInsetsGeometry? padding;
  Function() onclick;
  double? height;
  double? width;
  double? elevation;
  TextStyle? labelStyle;
  Icon? icon;
  Border?border;

  Kalubtn({
    required this.label,
    required this.onclick,
    this.icon,
    this.borderRadius,
    this.backgroundColor,
    this.width,
    this.height,
    this.elevation,
    this.padding,
    this.labelStyle,
    this.border
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: TouchRippleEffect(
        rippleColor: Colors.greenAccent,
        onTap: onclick,
        borderRadius: BorderRadius.circular(borderRadius??8),
        child: Container(
          width: width??double.infinity,
          height: height??35,
          padding: padding??EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor??Kara.primary,
            borderRadius: BorderRadius.circular(borderRadius??8),
            border: border??Border.all(width: 0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: elevation??0,
                blurRadius: elevation??0
              )
            ]
          ),
          child: icon!=null?Center(child: icon,):Center(child: Text('${label}', style: labelStyle??TextStyle(color: Colors.white),)),
        ),
      ),
    );
  }
}

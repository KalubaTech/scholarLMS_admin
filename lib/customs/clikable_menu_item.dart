import 'package:flutter/material.dart';
import 'package:stdominicsadmin/styles/colors.dart';

class ClickableMenuItem extends StatelessWidget {
  Function() onclick;
  IconData iconData;
  Color?color;
  Color?backgroundColor;
  ClickableMenuItem({required this.onclick, required this.iconData, this.color, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onclick,
        child: CircleAvatar(
          backgroundColor: backgroundColor??Kara.background,
          radius: 12,
          child: Icon(iconData, size: 15,color: color??Kara.primary,),
        ),
      ),
    );
  }
}

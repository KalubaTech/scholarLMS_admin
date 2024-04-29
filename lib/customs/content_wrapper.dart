import 'package:flutter/material.dart';


class ContentWrapper extends StatelessWidget {
  Widget? content;
  EdgeInsetsGeometry? padding;
  BoxDecoration? decoration;
  double? width;
  double? height;

  ContentWrapper({ this.content, this.padding, this.decoration, this.width, this.height });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??100,
      width: width??double.infinity,
      padding: padding??EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: decoration??BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey,blurRadius: 0.5, spreadRadius: 0.5, offset: Offset(0, 0.5))
        ]
      ),
      child: content??Container(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stdominicsadmin/styles/font_sizes.dart';
import '../styles/colors.dart';
import 'package:get/get.dart';

class Kalutext extends StatelessWidget {

  String? labelText;
  String? hintText;
  String? errorText;
  bool? isObscured;
  bool? isNumber;
  Color? backgroundColor;
  BorderRadius? borderRadius;
  Border? border;
  bool? showEye;
  TextEditingController controller;
  TextStyle? labelTextStyle;
  TextStyle? textStyle;
  TextAlign? align;

  Kalutext({
    this.labelText,
    this.hintText,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.errorText,
    this.isNumber,
    this.isObscured,
    this.showEye,
    this.labelTextStyle,
    this.textStyle,
    this.align,
    required this.controller,
  });

  var isVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText==null?Container():Text(' $labelText', style: labelTextStyle??TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey
        ),),
        labelText==null?Container():SizedBox(height: 6,),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: backgroundColor??Colors.grey.shade100,
                border: border??Border.all(
                    color: Colors.transparent,
                    width: 0
                ),
                borderRadius: borderRadius??BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    ()=>TextField(
                      controller: controller,
                      textAlign: align??TextAlign.start,
                      style: textStyle??TextStyle(fontSize: FontSize.mediumheadertext),
                      keyboardType: !(isNumber ?? false) ? TextInputType.text : TextInputType.number,
                      obscureText: isObscured!=null?!isVisible.value:isVisible.value,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          border: InputBorder.none,
                          hintText: '${hintText??""}',

                      ),
                    ),
                  ),
                ),
                !(showEye ?? false)?Container():IconButton(onPressed: (){isVisible.value=!isVisible.value;}, icon: Icon(Icons.visibility))
              ],
            )
        ),
        SizedBox(height: 6,),
        errorText==null?Container():Center(child: Text(' $errorText', style: TextStyle(color: Colors.red), textAlign: TextAlign.center,))
      ],
    );
  }
}



  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(String date){
    String formattedDate = DateFormat('EEE, dd MMM yyyy  HH:mm').format(DateTime.parse(date));
    return formattedDate;
  }

  String formatTime(TimeOfDay time){

    String hour = time.hour.toString();
    String minute = time.minute.toString();

    if(hour.length==1){
      hour = '0$hour';
    }

    if(minute.length==1){
      minute = '0$minute';
    }

    String formattedTime = '$hour:$minute';
    return formattedTime;
  }
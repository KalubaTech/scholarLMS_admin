import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' show AssetImage;

import 'package:get/get.dart';
import '../controllers/institution_controller.dart';
import '../controllers/teacher_controller.dart';
import '../models/institution_model.dart';
import '../models/student_marks_model.dart';
import '../models/students.dart';
import 'methods.dart';



class PdfGenerate{
  InstitutionController _institutionController = Get.find();

  classList(String className, List<StudentModel>students) async {

    InstitutionModel school = _institutionController.institution.value;

    final Document pdf = Document(deflate: zlib.encode);

    pdf.addPage(
      Page(
        pageFormat:
        PdfPageFormat.a6.copyWith(marginBottom: 0.5 * PdfPageFormat.cm),
        margin: EdgeInsets.all(10),
        orientation: PageOrientation.portrait,
        build: (Context context) {
          return ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 8),
                alignment: Alignment.center,
                child: Column(
                    children: [
                      Text(
                        "${school.name}",
                        style: TextStyle(
                          color: PdfColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Class: ${className}",
                        style: TextStyle(
                          color: PdfColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ]
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children:[
                          Text('Total:  ', style: TextStyle(fontSize: 8)),
                          Text('${students.length}', style: TextStyle(fontSize: 8))
                        ]
                    ),),
                    Expanded(
                      child: Row(
                        children:[
                          Text('Male:  ', style: TextStyle(fontSize: 8)),
                          Text('${students.where((element) => element.gender=="Male").length}', style: TextStyle(fontSize: 8))
                        ]
                    ),),
                    Expanded(child: Row(
                        children:[
                          Text('Female:  ', style: TextStyle(fontSize: 8)),
                          Text('${students.where((element) => element.gender=="Female").length}',  style: TextStyle(fontSize: 8))
                        ]
                    ))
                  ]
                )
              ),
              Container(
                height: 1.0,
                width: 300.0,
                color: PdfColors.teal,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Table(
                  border: TableBorder.all(),
                  tableWidth: TableWidth.max,
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      decoration: BoxDecoration(
                        color: PdfColors.grey
                      ),
                      children: <Widget>[
                        Container(
                            child: Text("SN", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                            padding:
                            EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 8, )),
                        Container(
                            child: Text("Name", style: TextStyle(fontSize: 8, height: 8, fontWeight: FontWeight.bold)),
                            padding:
                            EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 8)),
                        Container(
                            child: Text("Gender", style: TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                            padding:
                            EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 8)),
                      ],
                    ),
                    ...generateTableRows(students)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    final output = await getApplicationDocumentsDirectory();
    final Uint8List data = await pdf.save();

    // Print the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => data);
  }
  List<TableRow> generateTableRows(List<StudentModel>students) {
    List<TableRow> tableRows = [];

    int counter = 0;
    for (StudentModel student in students) {

      if (student != null) {

        // Create a TableRow
        TableRow tableRow = TableRow(
          children: <Widget>[
            Container(
                child: Text("${++counter}", style: TextStyle(fontSize: 8)),
                padding: EdgeInsetsDirectional.symmetric(vertical: 2,horizontal: 8)),
            Container(
                child: Text("${student.name.capitalize}", style: TextStyle(fontSize: 8)),
                padding: EdgeInsetsDirectional.symmetric(vertical: 2, horizontal: 8)),
            Container(
                child: Text("${student.gender}", style: TextStyle(fontSize: 8)),
                padding: EdgeInsetsDirectional.symmetric(vertical: 2, horizontal: 8)),
          ],
        );

        // Add the TableRow to the list
        tableRows.add(tableRow);
      }
    }

    return tableRows;
  }

///Mark Schedule Print
  markSchedule(String className, List<StudentMarksModel>students, String reason) async {

    InstitutionModel school = _institutionController.institution.value;
    TeacherController _teacher = Get.find();

    Methods _methods = Methods();

    final Document pdf = Document(deflate: zlib.encode);




    pdf.addPage(
      Page(
        pageFormat:
        PdfPageFormat.a6.copyWith(marginBottom: 0.5 * PdfPageFormat.cm),
        margin: EdgeInsets.all(10),
        orientation: PageOrientation.portrait,
        build: (Context context) {
          return ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 8),
                alignment: Alignment.center,
                child: Column(
                    children: [
                      Text(
                        "${school.name}",
                        style: TextStyle(
                          color: PdfColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${students.first.results.first.course.capitalize}",
                        style: TextStyle(
                          color: PdfColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${reason} Results".capitalize.toString(),
                        style: TextStyle(
                          color: PdfColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ]
                ),
              ),
              SizedBox(height: 8),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                              children:[
                                Text('Class:  ${students.first.student.academicYear}', style: TextStyle(fontSize: 8)),
                                Text('${className}', style: TextStyle(fontSize: 8))
                              ]
                          ),),
                        Expanded(child: Row(
                            children:[
                              Text('Date:  ', style: TextStyle(fontSize: 8)),
                              Text('${_methods.formatDate1(DateTime.now().toString())}',  style: TextStyle(fontSize: 8))
                            ]
                        ))
                      ]
                  )
              ),
              Container(
                height: 1.0,
                width: 300.0,
                color: PdfColors.teal,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Table(
                  border: TableBorder.all(),
                  tableWidth: TableWidth.max,
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      decoration: BoxDecoration(
                          color: PdfColors.grey
                      ),
                      children: <Widget>[
                        Container(
                            child: Text("SN", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                            padding:
                            EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 8, )),
                        Container(
                            child: Text("Name", style: TextStyle(fontSize: 8, height: 8, fontWeight: FontWeight.bold)),
                            padding:
                            EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 8)),
                        Container(
                            child: Text("Marks", style: TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                            padding:
                            EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 8)),
                      ],
                    ),
                    ...generateMarkScheduleTableRows(students)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    final output = await getApplicationDocumentsDirectory();
    final Uint8List data = await pdf.save();

    // Print the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => data);
  }
  List<TableRow> generateMarkScheduleTableRows(List<StudentMarksModel>students) {
    List<TableRow> tableRows = [];

    int counter = 0;
    for (StudentMarksModel student in students) {

      if (student != null) {

        // Create a TableRow
        TableRow tableRow = TableRow(
          children: <Widget>[
            Container(
                child: Text("${++counter}", style: TextStyle(fontSize: 8)),
                padding: EdgeInsetsDirectional.symmetric(vertical: 2,horizontal: 8)),
            Container(
                child: Text("${student.student.name.capitalize}", style: TextStyle(fontSize: 8)),
                padding: EdgeInsetsDirectional.symmetric(vertical: 2, horizontal: 8)),
            Container(
                child: Text("${student.results.isNotEmpty?student.results.first.marks:''}", style: TextStyle(fontSize: 8)),
                padding: EdgeInsetsDirectional.symmetric(vertical: 2, horizontal: 8)),
          ],
        );

        // Add the TableRow to the list
        tableRows.add(tableRow);
      }
    }

    return tableRows;
  }
}

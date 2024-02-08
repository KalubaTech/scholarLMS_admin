import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing/printing.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:get/get.dart';
import '../../controllers/institution_controller.dart';

class StatementGenerate extends StatelessWidget {
  String studentID;
  String studentName;
  String programme;
  String academic_year;
  String assignment;
  List<DocumentSnapshot> gradingSystem;
  QuerySnapshot<Map<String, dynamic>> data;
  StatementGenerate({
    required this.studentID,
    required this.studentName,
    required this.assignment,
    required this.academic_year,
    required this.programme,
    required this.gradingSystem,
    required this.data
  });

  InstitutionController _institutionController = Get.find();

  Future<pw.Document> generatePdf()async{
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/scholar.png');
    final imageBytes = img.buffer.asUint8List();

    pw.Image assetImage = pw.Image(pw.MemoryImage(imageBytes), width: 80);


   List<DocumentSnapshot> gradingSnapshot = await FirebaseFirestore.instance.collection('grading_system')
        .where('institutionID', isEqualTo: '${_institutionController.institution.value.id}')
        .get().then((value) => value.docs);

 
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            width: double.infinity,
            height: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Expanded(
                  child: pw.Container(
                      child: pw.Column(
                        children: [
                          pw.Center(
                            child: pw.Column(
                              children: [
                                assetImage,
                                pw.Text('${_institutionController.institution.value.name}', style: pw.TextStyle( fontSize: 14)),
                                pw.SizedBox(height: 10),
                                pw.Text(assignment.toUpperCase(), style: pw.TextStyle( fontSize: 13),),
                                pw.SizedBox(height: 10),
                                pw.Text('STATEMENT OF RESULTS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 30),
                          pw.Table(
                            columnWidths: {
                              1 : pw.FixedColumnWidth(450),
                            },
                            children: [
                              pw.TableRow(
                                  children: [
                                    pw.Text('${_institutionController.institution.value.type=='primary'?'Class':'Programme'}:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                                    pw.Text('${programme}'),
                                  ]
                              ),
                              pw.TableRow(
                                  children: [
                                    pw.Text('${_institutionController.institution.value.type=='primary'?'Pupil':'Student'}:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                                    pw.Text(studentName),
                                  ]
                              ),
                              pw.TableRow(
                                  children: [
                                    pw.Text('${_institutionController.institution.value.type=='primary'?'Grade':'Academic year'}:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                                    pw.Text(academic_year),
                                  ]
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 20,),
                          pw.Expanded(
                            child: pw.Column(
                              children: [
                                pw.Container(
                                  width: double.infinity,
                                  child: pw.Table(
                                    border: pw.TableBorder.all(),
                                    children: [
                                      pw.TableRow(
                                        children: [
                                          pw.Padding(
                                            padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            child: pw.Text('COURSE'),
                                          ),
                                          pw.Padding(
                                            padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            child: pw.Text('MARKS'),
                                          ),
                                          pw.Padding(
                                            padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            child: pw.Text('GRADE'),
                                          ),
                                        ],
                                      ),
                                      if (data.docs.isNotEmpty)
                                        ... data!.docs.where((element)=>
                                        element.get('reason')==assignment &&
                                            element.get('academic_year') == academic_year
                                        ).toList().map((e) {

                                          List<DocumentSnapshot> n = gradingSnapshot.where((grading) =>
                                          int.parse(e.get('marks'))>=int.parse(grading.get('from')) &&
                                              int.parse(e.get('marks'))<=int.parse(grading.get('to'))
                                          ).toList();
                                          return pw.TableRow(
                                          children: [
                                            pw.Padding(
                                              padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                              child: pw.Text(e.get('course').toString().toUpperCase()),
                                            ),
                                            pw.Padding(
                                              padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                              child: pw.Text(e.get('marks').toString()), // Make sure 'marks' is a String
                                            ),
                                            pw.Padding(
                                              padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                              child: pw.Text(n.isNotEmpty?n.first.get('grade'):''), // Make sure 'marks' is a String
                                            ),
                                          ],
                                        );
                                        }),
                                    ],
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Container(
                                  child: pw.Row(
                                      children: [
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text('.'*60),
                                            pw.SizedBox(height: 5),
                                            pw.Text('${_institutionController.institution.value.type=='primary'?'Head Teacher': 'Principal'}'),
                                          ],
                                        )
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),

                        ],
                      )
                  ),
                )
              ],
            ),
          ); // Center
        })
    );
    return pdf;

  }

  void download(pw.Document pdf)async{
    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);
    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute("download", "${studentName}_${assignment}_${academic_year}_${DateTime.now().millisecondsSinceEpoch}.pdf")
      ..click();
  }

  void share(pw.Document doc)async{
    await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');
  }

  void printer(pw.Document doc)async{
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              color: kara.Colors.primary,
              child: Row(
                children: [
                  IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.arrow_back, color: Colors.white,)),
                  Spacer(),
                  IconButton(onPressed: ()async=>printer(await generatePdf()), icon: Icon(Icons.print, color: Colors.white)),
                  IconButton(onPressed: ()async=>download(await generatePdf()), icon: Icon(Icons.download, color: Colors.white)),

                ]
              )
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 2,
                      offset: Offset(1, 2)
                    )
                  ]
                ),
                width: 700,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('results')
                      .where('student_id', isEqualTo: '$studentID')
                        .where('academic_year', isEqualTo: academic_year)
                      .snapshots(),
                  builder: (context, snapshot) {

                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                  width: 80,
                                  height: 80,
                                  imageUrl: '${_institutionController.institution.value.logo}',
                                  errorWidget: (c,e,i)=>Image.asset('assets/scholar.png', width: 80,),
                              ),
                              SizedBox(height: 10),
                              Text('${_institutionController.institution.value.name}'),
                              SizedBox(height: 10),
                              Text(assignment.toUpperCase()),
                              SizedBox(height: 10),
                              Text('STATEMENT OF RESULTS', style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 16),),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Table(
                          columnWidths: {
                            1 : FixedColumnWidth(500),
                          },
                          children: [
                            TableRow(
                              children: [
                                Text('${_institutionController.institution.value.type=='primary'?'Class':'Programme'}:', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('$programme'),
                              ]
                            ),
                            TableRow(
                              children: [
                                Text('${_institutionController.institution.value.type=='primary'?'Pupil':'Student'}:', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('${studentName}'),
                              ]
                            ),
                            TableRow(
                              children: [
                                Text('${_institutionController.institution.value.type=='primary'?'Grade':'Academic year'}:', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(academic_year),
                              ]
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: DataTable(
                                border: TableBorder.all(),
                                columns: [
                                  DataColumn(label: Text('COURSE')),
                                  DataColumn(label: Text('MARKS')),
                                  DataColumn(label: Text('GRADE')),
                                ],
                                rows: snapshot.data!.docs
                                    .where(
                                        (element) =>
                                    element.get('reason')==assignment &&
                                        element.get('academic_year') == academic_year
                                ).map<DataRow>((e)
                                => DataRow(cells: [
                                  DataCell(Text('${e.get('course')}'.toUpperCase())),
                                  DataCell(Text('${e.get('marks')}')),
                                  DataCell(
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance.collection('grading_system')
                                              .where('institutionID', isEqualTo: '${_institutionController.institution.value.id}')
                                              .snapshots(),
                                          builder: (context,snapshot){
                                            if (snapshot.hasData && snapshot.data!.docs.length>0) {

                                              List<DocumentSnapshot> n = snapshot.data!.docs.where((grading) =>
                                              int.parse(e.get('marks'))>=int.parse(grading.get('from')) &&
                                                  int.parse(e.get('marks'))<=int.parse(grading.get('to'))
                                              ).toList();

                                              return n.isNotEmpty?Text('${n.first.get('grade')}'):Text('not defined');
                                            } else {
                                              return Text('Not set');
                                            }
                                          }
                                      )),
                                ])
                                ).toList(),
                                horizontalMargin: 20,
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('.'*50),
                                      SizedBox(height: 5),
                                      Text('${_institutionController.institution.value.type=='primary'?'Head Teacher': 'Principal'}'),
                                    ],
                                  )
                                ]
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

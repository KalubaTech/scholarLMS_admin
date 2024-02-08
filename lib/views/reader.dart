import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:stdominicsadmin/controllers/tutorController.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import "package:webview_universal/webview_universal.dart";
import '../models/book_model.dart';
import '../styles/colors.dart' as kara;
import 'package:get/get.dart';

class Reader extends StatefulWidget {
  final BookModel book;
  Reader(this.book);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    task();
  }

  Future<void> task() async {
    await webViewController.init(
      context: context,
      uri: Uri.parse("${widget.book.book}"),
      setState: (void Function() fn) {  },
    );
  }
  TutorController _tutorController = Get.find();
  TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: kara.Colors.primary)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    MouseRegion(
                      child: GestureDetector(
                        onTap: ()=>Get.back(),
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      )
                    ),
                    SizedBox(width: 10),
                    Text(widget.book.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  ],
                ),
                decoration: BoxDecoration(
                    color: kara.Colors.primary,
                ),
              ),
              Expanded(
                child: Container(
                  child: ResizableContainer(
                      direction: Axis.horizontal,
                      children: [
                        ResizableChildData(
                            child: Container(
                              width: 400,
                              height: double.infinity,
                              child:ClipRRect(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                                child: WebView(
                                  controller: webViewController,
                                ),
                              ), // Simple Pdf view with one render of page (loose quality on zoom)

                            ),
                            startingRatio: 0.75
                        ),
                        ResizableChildData(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: kara.Colors.background,
                                      boxShadow: [
                                        BoxShadow(color: Colors.grey,blurRadius: 2)
                                      ]
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                    child: Row(
                                      children: [
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance.collection('book_views').where('book', isEqualTo: widget.book.id).snapshots(),
                                          builder: (context, snapshot) {
                                            return snapshot.hasData&&snapshot.data!.docs.length>0?Row(
                                              children: [
                                                Text('Views: '),
                                                Text('${snapshot.data!.docs.length}')
                                              ],
                                            ):Container();
                                          }
                                        ),
                                        SizedBox(width: 40,),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance.collection('book_comments').where('book', isEqualTo: widget.book.id).snapshots(),
                                          builder: (context, snapshot) {
                                            return snapshot.hasData&&snapshot.data!.docs.length>0?Row(
                                              children: [
                                                Text('Comments: '),
                                                Text('${snapshot.data!.docs.length}')
                                              ],
                                            ):Container();
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance.collection('book_comments').where('book', isEqualTo: widget.book.id).snapshots(),
                                          builder: (context, documentSnapshots) {

                                            if(documentSnapshots.hasData && documentSnapshots.data!.size>0){
                                              return ListView.builder(
                                                itemCount: documentSnapshots.data!.docs.length,
                                                itemBuilder: (context,index){
                                                  return InkWell(
                                                    child: BubbleSpecialThree(
                                                      isSender: documentSnapshots.data!.docs[index].get('commentator') ==_tutorController.tutor
                                                          .value.email?true:false,
                                                      text: '${documentSnapshots.data!.docs[index].get('comment')}',
                                                      color: documentSnapshots.data!.docs[index].get('commentator') ==_tutorController.tutor
                                                          .value.email?Color(0xFF1B97F3):Color(
                                                          0xFFBCD1DC),
                                                      tail: false,
                                                      textStyle: TextStyle(
                                                          color: documentSnapshots.data!.docs[index].get('commentator') ==_tutorController.tutor
                                                              .value.email?Colors.white:Colors.black,
                                                          fontSize: 16
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }else{
                                              return Container(
                                                child: Center(child: Text('No comments'))
                                              );
                                            }
                                          }
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          blurRadius: 2
                                                      )
                                                    ]
                                                ),
                                                child: TextField(
                                                    controller: _messageController,
                                                    decoration: InputDecoration(
                                                        hintText: 'Comment',
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 20)
                                                    )
                                                )
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: TouchRippleEffect(
                                                onTap: (){
                                                  if(_messageController.text.isNotEmpty){

                                                    int counter = 1;
                                                    if(_messageController.text.isNotEmpty){
                                                      FirebaseFirestore.instance.collection('book_comments').orderBy('AI').get().then((value){

                                                        if(value.docs.isNotEmpty){
                                                          counter = value.docs.last.get('AI') + 1;
                                                          Map<String,dynamic> data = {
                                                            'AI': counter,
                                                            'book': widget.book.id,
                                                            'commentator': _tutorController.tutor.value.email,
                                                            'comment': _messageController.text,
                                                            'datetime':'${DateTime.now()}',
                                                            'page': '1'
                                                          };

                                                          FirebaseFirestore.instance.collection('book_comments').add(data).then((value){
                                                            _messageController.text = "";
                                                          });
                                                        }

                                                      });

                                                    }
                                                  }
                                                },
                                                rippleColor: Colors.grey,
                                                borderRadius: BorderRadius.circular(10),
                                                child: Icon(Icons.send, color: Colors.green)
                                            ),
                                          )
                                        ]
                                    ),
                                  )
                                ]
                              )
                            ),
                            startingRatio: 0.25
                        ),

                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

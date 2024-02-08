import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stdominicsadmin/customs/custom_button.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:stdominicsadmin/styles/colors.dart' as kara;
import 'package:get/get.dart';

import '../../controllers/tutorController.dart';
import '../../helpers/methods.dart';


class NoticeBoard extends StatefulWidget {
  BuildContext ctx;
  NoticeBoard(this.ctx);

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {

  TutorController _tutorController = Get.find();
  TextEditingController _controller = TextEditingController();

  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
            children: [
              Container(
                height: 250,
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                          child: EmojiPicker(
                            onEmojiSelected: (Category? category, Emoji? emoji) {
                              // Do something when emoji is tapped (optional)
                            },
                            onBackspacePressed: () {
                              // Do something when the user taps the backspace button (optional)
                              // Set it to null to hide the Backspace-Button
                            },
                            textEditingController: _controller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                            config: Config(
                              columns: 8,
                              emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              gridPadding: EdgeInsets.zero,
                              initCategory: Category.RECENT,
                              bgColor: Color(0xFFF2F2F2),
                              indicatorColor: Colors.blue,
                              iconColor: Colors.grey,
                              iconColorSelected: Colors.blue,
                              backspaceColor: Colors.blue,
                              skinToneDialogBgColor: Colors.white,
                              skinToneIndicatorColor: Colors.grey,
                              enableSkinTones: true,
                              recentTabBehavior: RecentTabBehavior.RECENT,
                              recentsLimit: 28,
                              noRecents: const Text(
                                'No Recents',
                                style: TextStyle(fontSize: 20, color: Colors.black26),
                                textAlign: TextAlign.center,
                              ), // Needs to be const Widget
                              loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL,
                            ),
                          )
                        ),
                    ),
                    Container(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type text here...'
                        ),
                      )
                    ),
                    TouchRippleEffect(
                        onTap: (){
                          if (_controller.text != '') {
                            FirebaseFirestore.instance.collection('notice_board').add({
                              'notice': _controller.text,
                              'tutor': _tutorController.tutor.value.email,
                              'datetime': '${DateTime.now()}',
                              'institutionID':_tutorController.tutor.value.institutionID
                            }).then((e){
                              Fluttertoast.showToast(msg: 'Successful');
                              _controller.clear(); 
                            });
                          }
                        },
                        rippleColor: Colors.green,
                        backgroundColor: kara.Colors.green,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            width: 200,
                            height: 25,
                            child: Center(child: Text('POST', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                  child: Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('notice_board').where('institutionID', isEqualTo:_tutorController.tutor.value.institutionID).snapshots(),
                          builder: (context,snapshot){
                            if(snapshot.hasData && snapshot.data!.size>0){
                              return ListView.builder(
                                  itemCount: snapshot.data!.size,
                                  itemBuilder: (context,index){
                                    return Container(
                                        child: Column(
                                          children: [
                                            Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey.withOpacity(0.2),
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                        child: Text('${snapshot.data!.docs[index].get('notice')}')
                                                    ),
                                                  ),
                                                  IconButton(onPressed: (){
                                                    TextEditingController edit = TextEditingController();
                                                    Get.defaultDialog(
                                                      title: '',
                                                      content: Container(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            CustomButton(
                                                                Text('Edit', style: TextStyle(color: Colors.white, ),),
                                                                onTap: (){
                                                                  Get.back();
                                                                  edit.text =  snapshot.data!.docs[index].get('notice');
                                                                  Get.bottomSheet(
                                                                    Container(
                                                                      height: 210,
                                                                      padding: EdgeInsets.all(30),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text('Edit', style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold, color: kara.Colors.primary),),
                                                                          SizedBox(height: 20),
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.grey.withOpacity(0.2),
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: TextField(
                                                                              controller: edit,
                                                                              decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                                                                border: InputBorder.none,
                                                                                hintText: 'Notice'
                                                                              )
                                                                            )
                                                                          ),
                                                                          SizedBox(height: 20),
                                                                          Center(
                                                                            child: CustomButton(Text('OK', style: TextStyle(color: Colors.white),), onTap: (){
                                                                              FirebaseFirestore.instance.collection('notice_board')
                                                                                  .doc(snapshot.data!.docs[index].id)
                                                                                  .update(
                                                                                      {
                                                                                        'notice':edit.text
                                                                                      }
                                                                                    );
                                                                                _methods.shownackbar('Successful', widget.ctx);
                                                                              Get.back();
                                                                            }),
                                                                          ),
                                                                          Spacer()
                                                                        ]
                                                                      )
                                                                    ),
                                                                    backgroundColor: Colors.white
                                                                  );
                                                                },

                                                            ),
                                                            SizedBox(width: 20),
                                                            CustomButton(
                                                                Text('Delete', style: TextStyle(color: Colors.white),),
                                                                onTap: (){
                                                                  FirebaseFirestore.instance.collection('notice_board')
                                                                      .doc(snapshot.data!.docs[index].id).delete().then((value) =>
                                                                      _methods.shownackbar('Deleted successfully', widget.ctx)
                                                                  );
                                                                  Get.back();
                                                                }
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    );
                                                  }, icon: Icon(Icons.more_horiz))
                                                ]
                                            ),
                                            SizedBox(height: 10)
                                          ],
                                        )
                                    );
                                  }
                              );
                            }else{
                              return Container();
                            }
                          }
                      )
                  )
              )
            ]
        )
    );
  }
}

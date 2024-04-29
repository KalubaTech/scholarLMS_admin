import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/selectedItemsController.dart';
import '../models/student_model.dart';

class StudentCard extends StatefulWidget {
  final StudentModel student;
  final controller;
  final bool isSelected;

  StudentCard({required this.student, required this.isSelected, required this.controller});

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {

  SelectedStudentsController selectedItems = Get.find();

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 1
                  )
                ]
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: Colors.white,
                          width: 2
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2
                        )
                      ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      width: 45,
                      height: 45,
                      imageUrl: '${widget.student.photo}',
                      errorWidget: (c,i,e)=>Image.asset('assets/user-avater.png'),
                      fit: BoxFit.cover ,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.student.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              color: 1==0?Colors.grey:Colors.black
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.student.email,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                )
              ],
            )
        ),
        Positioned(
          top: 5,
          right: 8,
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.more_horiz, size: 15, color: Colors.grey,)
          )
        ),
        Positioned(
          bottom: 2,
          right: 4,
          child: Obx(
            ()=> Checkbox(value: widget.isSelected==true?true:widget.controller.selectedItems.value.contains(widget.student.uid), onChanged: (value){
              setState(() {
                if(widget.controller.selectedItems.value.contains(widget.student.uid)){
                  widget.controller.removeItem(widget.student.uid);
                }else{
                  widget.controller.updateItem(widget.student.uid);
                }
              });
            }),
          )
        ),
      ],
    );
  }
}

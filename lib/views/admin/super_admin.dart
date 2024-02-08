import 'package:flutter/material.dart';
import 'package:stdominicsadmin/styles/colors.dart' as karas;
import 'package:get/get.dart';
import '../../controllers/tutorController.dart';
import 'institutions.dart';

class SuperAdmin extends StatelessWidget {
  SuperAdmin({Key? key}) : super(key: key);

  TutorController _tutorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: Container(
        padding: EdgeInsets.all(100),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1,
                  offset: Offset(0,1)
                )
              ]
            ),
            width: 600,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Text('SUPER ADMIN DASHBOARD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('${_tutorController.tutor.value.name}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                    ],
                  )
                ),
                Divider(),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: (){
                              Get.to(()=>Institutions());
                            },
                            child: Container(
                              color: Colors.orange,
                              width: 180,
                              height: 110,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Icon(Icons.school_outlined, color: Colors.white, size: 60,),
                                  Spacer(),
                                  Text('INSTITUTIONS', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.blue,
                          width: 180,
                          height: 110,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.subscriptions, color: Colors.white, size: 60,),
                              Spacer(),
                              Text('SUBSCRIPTIONS', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.green,
                          width: 180,
                          height: 110,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.query_stats, color: Colors.white, size: 60,),
                              Spacer(),
                              Text('USAGE STATS', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
                Expanded(
                  child: Container(

                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                  ),
                )
              ]
            )
          )
        )
      ),
    );
  }
}

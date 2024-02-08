import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stdominicsadmin/models/institution_model.dart';
import 'package:stdominicsadmin/styles/colors.dart' as karas;
import 'package:get/get.dart';
import '../../controllers/tutorController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Institutions extends StatelessWidget {
  Institutions({Key? key}) : super(key: key);

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
                                Text('INSTITUTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                Text('${_tutorController.tutor.value.name} (Admin)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                              ],
                            )
                        ),
                        Divider(),
                        Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('institutions').snapshots(),
                            builder: (context, snapshot) {
                              return snapshot.hasData?
                              Container(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.size,
                                    itemBuilder: (context,index){
                                      InstitutionModel institution = InstitutionModel(id: snapshot.data!.docs[index].id, name: snapshot.data!.docs[index].get('name'), admin: snapshot.data!.docs[index].get('admin'), logo: snapshot.data!.docs[index].get('logo'), motto: snapshot.data!.docs[index].get('motto'), type: snapshot.data!.docs[index].get('type'));
                                      return ListTile(
                                        leading: CachedNetworkImage(
                                            imageUrl: '${institution.logo}',
                                            errorWidget: (e,c,i)=>CircleAvatar(
                                              child: Icon(Icons.school_outlined),
                                            ),
                                        ),
                                        title: Text('${institution.name}'),
                                      );
                                    }
                                ),
                              ):
                              Container();
                            }
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

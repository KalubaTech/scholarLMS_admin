import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stdominicsadmin/helpers/methods.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import '../../controllers/tutorController.dart';
import '../../customs/custom_button.dart';
import '../../styles/colors.dart' as kara;
import '../../controllers/institution_controller.dart';


class SettingsScreen extends StatefulWidget {

  List<String> a_years;

  SettingsScreen(this.a_years);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TutorController _tutorController = Get.find();

  InstitutionController  _institutionController = Get.find();

  Methods methods = Methods();

  List<String> academic_years = [
    ''
  ];

  List<TextEditingController> controllers = [

  ];

  int counter = 0;
  //TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    academic_years = widget.a_years;

    for(int i = 0; i < academic_years.length; i++){
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
      controller.text = academic_years[i];
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.grey)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: kara.Colors.primary
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TouchRippleEffect(
                  onTap: ()=>Get.back(),
                  rippleColor: Colors.grey.withOpacity(0.3),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Settings', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Profile Settings', style: GoogleFonts.abel(fontSize: 20, ),)
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: 350,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                      width: double.infinity,
                                                      height: 60,
                                                  ),
                                                  _tutorController.tutor.value.uid.isNotEmpty?StreamBuilder(
                                                      stream: FirebaseFirestore.instance.collection('tutor').doc(_tutorController.tutor.value.uid).snapshots(),
                                                      builder: (context, snapshot) {
                                                        snapshot.hasData&&snapshot.data!.exists?print(snapshot.data!.get('photo')):print('');
                                                        return snapshot.hasData&&snapshot.data!.exists?Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 30),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: CachedNetworkImage(
                                                              height: 60, 
                                                              width: 60,
                                                              imageUrl: snapshot.data!.get('photo'),
                                                              placeholder:(c,i)=> CircleAvatar(
                                                                radius: 50,
                                                                child: Center(child: CircularProgressIndicator()),
                                                              ),
                                                              errorWidget:(c,i,e)=> CircleAvatar(
                                                                radius: 50,
                                                                child: Icon(Icons.person, color: Colors.grey, size: 60,),
                                                              ),
                                                            ),
                                                          ),
                                                        ):
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                                                          child: CircleAvatar(
                                                            radius: 50,
                                                            child: Icon(Icons.person, color: Colors.grey, size: 60,),
                                                          ),
                                                        );
                                                      }
                                                  ):
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                                                    child: Shimmer.fromColors(
                                                        baseColor: Colors.grey.withOpacity(0.2),
                                                        highlightColor: Colors.grey.withOpacity(0.4),
                                                        child: CircleAvatar(
                                                            radius: 50
                                                        )
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 20,
                                                    left: 40,
                                                    child: MouseRegion(
                                                      cursor: SystemMouseCursors.click,
                                                      child: TouchRippleEffect(
                                                        onTap: (){
                                                          methods.pickProfile(context);
                                                        },
                                                        borderRadius: BorderRadius.circular(60),
                                                        rippleColor: Colors.grey.withOpacity(0.3),
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(60),
                                                                color: Colors.white
                                                            ),
                                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                            child: Icon(Icons.edit, color: kara.Colors.primary, )
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                    boxShadow: [
                                                      BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                    ]
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Name:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          StreamBuilder(
                                                              stream: FirebaseFirestore.instance.collection('tutor').
                                                             doc(_tutorController.tutor.value.uid)
                                                                  .snapshots(),
                                                              builder: (context, snapshot) {
                                                                return snapshot.hasData ? Text('${snapshot.data!.get('name')}'):Text('');
                                                              }
                                                          ),
                                                          Spacer(),
                                                          MouseRegion(
                                                            cursor: SystemMouseCursors.click,
                                                            child: TouchRippleEffect(
                                                              borderRadius: BorderRadius.circular(10),
                                                              rippleColor: Colors.grey.withOpacity(0.4),
                                                              onTap: ()=>methods.editInstitutionName(),
                                                              child: MouseRegion(
                                                                cursor: SystemMouseCursors.click,
                                                                child: TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  rippleColor: Colors.grey.withOpacity(0.4),
                                                                  onTap: ()=>methods.editTutorName(),
                                                                  child:Icon(Icons.edit, color: kara.Colors.primary, size: 18)
                                                                )
                                                              )
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ), 
                                              SizedBox(height:10),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                    boxShadow: [
                                                      BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                    ]
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Email:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Text('${_tutorController.tutor.value.email}'),
                                                          SizedBox(width: 30),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height:10),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                  boxShadow: [
                                                    BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                  ]
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Password:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: List.generate(5, (index) => Row(
                                                              children: [
                                                                CircleAvatar(radius: 5,backgroundColor: Colors.black,),
                                                                SizedBox(width: 10)
                                                              ],
                                                            )),
                                                          ),
                                                          Spacer(),
                                                          MouseRegion(
                                                              child: TouchRippleEffect(
                                                                 rippleColor: Colors.grey.withOpacity(0.3),
                                                                  onTap: ()=>methods.changePassword(context),
                                                                  child: Icon(Icons.edit, color: kara.Colors.primary, size: 18)
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height:10),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                  boxShadow: [
                                                    BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                  ]
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Assigned Classes:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5), 
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text('12 Classes')
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          MouseRegion(
                                                              child: TouchRippleEffect(
                                                                 rippleColor: Colors.grey.withOpacity(0.3),
                                                                  onTap: ()=>methods.changePassword(context),
                                                                  child: Icon(Icons.edit, color: kara.Colors.primary, size: 18)
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      SizedBox(width: 40),
                      Container(
                            height: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${_institutionController.institution.value.type=='primary'?'School':'Institution'} Settings', style: GoogleFonts.abel(fontSize: 20, ),),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container( 
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              CustomButton(Text('Upload Logo', style: TextStyle(color: Colors.white)),
                                                  onTap: ()async{
                                                    methods.pickLogo(context);
                                                  }),
                                              SizedBox(width: 40),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore.instance.collection('institutions')
                                                      .doc(_tutorController.tutor.value.institutionID).snapshots(),
                                                  builder:(context,snapshot){
                                                    if(snapshot.hasData){
                                                      if(snapshot.data!.get('logo')==''){
                                                        return Container();
                                                      }else{
                                                        return CachedNetworkImage(
                                                            width: 30,
                                                            height: 30,
                                                            imageUrl: '${snapshot.data!.get('logo')}'
                                                        );
                                                      }
                                                    }else{
                                                      return Container();
                                                    }
                                                  }
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: 350,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height:20),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                      boxShadow: [
                                                        BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                      ]
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${_institutionController.institution.value.type=='primary'?'School':'Institution'} Name:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          StreamBuilder(
                                                              stream: FirebaseFirestore.instance.collection('institutions')
                                                                  .doc(_institutionController.institution.value.id)
                                                                  .snapshots(),
                                                              builder: (context, snapshot) {
                                                                return snapshot.hasData?Text('${snapshot.data!.get('name')}'):Text('Not set');
                                                              }
                                                          ),
                                                          Spacer(),
                                                          MouseRegion(
                                                              cursor: SystemMouseCursors.click,
                                                              child: TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  rippleColor: Colors.grey.withOpacity(0.4),
                                                                  onTap: ()=>methods.editInstitutionName(),
                                                                  child:Icon(Icons.edit, color: kara.Colors.primary, size: 18)
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                      boxShadow: [
                                                        BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                      ]
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Motto:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          StreamBuilder(
                                                              stream: FirebaseFirestore.instance.collection('institutions')
                                                                  .doc(_institutionController.institution.value.id)
                                                                  .snapshots(),
                                                              builder: (context, snapshot) {
                                                                return snapshot.hasData?Text('${snapshot.data!.get('motto')}'):Text('Not set');
                                                              }
                                                          ),
                                                          Spacer(),
                                                          MouseRegion(
                                                              cursor: SystemMouseCursors.click,
                                                              child: TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  rippleColor: Colors.grey.withOpacity(0.4),
                                                                  onTap: ()=>methods.editInstitutionMotto(),
                                                                  child:Icon(Icons.edit, color: kara.Colors.primary, size: 18)))
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                      boxShadow: [
                                                        BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                      ]
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${_institutionController.institution.value.type=='primary'?'Teachers':'Lecturers'}:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          StreamBuilder(
                                                              stream: FirebaseFirestore.instance.collection('tutor').
                                                              where('institutionID', isEqualTo: _institutionController.institution.value.id)
                                                                  .snapshots(),
                                                              builder: (context, snapshot) {
                                                                return snapshot.hasData ? Text('${snapshot.data!.size} ${_institutionController.institution.value.type=='primary'?'Teachers':'Lecturers'}'):Text('');
                                                              }
                                                          ),
                                                          Spacer(),
                                                          MouseRegion(
                                                              cursor: SystemMouseCursors.click,
                                                              child: TouchRippleEffect(
                                                                  rippleColor: Colors.grey.withOpacity(0.4),
                                                                  onTap: ()=>methods.lecturers(),
                                                                  child:Icon(Icons.edit, color: kara.Colors.primary, size: 18)
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                      boxShadow: [
                                                        BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                      ]
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${_institutionController.institution.value.type=='primary'?'Classes':'Programmes'}:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          StreamBuilder(
                                                              stream: FirebaseFirestore.instance.collection('programmes')
                                                                  .where('institutionID', isEqualTo: _institutionController.institution.value.id).snapshots(),
                                                              builder: (context, snapshot) {
                                                                return snapshot.hasData?Text('${snapshot.data!.size} ${_institutionController.institution.value.type=='primary'?'Classes':'Programmes'}'):Text('Not set');
                                                              }
                                                          ),
                                                          Spacer(),
                                                          MouseRegion(
                                                              cursor: SystemMouseCursors.click,
                                                              child: TouchRippleEffect(
                                                                  rippleColor: Colors.grey.withOpacity(0.4),
                                                                  onTap: ()=>methods.programmes(),
                                                                  child:Icon(Icons.edit, color: kara.Colors.primary, size: 18)
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                      boxShadow: [
                                                        BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                      ]
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'}:', style: TextStyle(color: Colors.grey)),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          StreamBuilder(
                                                              stream: FirebaseFirestore.instance.collection('courses').
                                                              where('institutionID', isEqualTo: _institutionController.institution.value.id).
                                                              snapshots(),
                                                              builder: (context, snapshot) {
                                                                return snapshot.hasData?Text('${snapshot.data!.size} ${_institutionController.institution.value.type=='primary'?'Subjects':'Courses'}'):Text('Not set');
                                                              }
                                                          ),
                                                          Spacer(),
                                                          MouseRegion(
                                                            cursor: SystemMouseCursors.click,
                                                            child: TouchRippleEffect(
                                                                onTap: ()=>methods.courses(),
                                                                child: Icon(Icons.edit, color: kara.Colors.primary, size: 18)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ),
                          ),
                      SizedBox(width: 40),
                      Container(
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Results Report Settings', style: GoogleFonts.abel(fontSize: 20, ),)
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: 350,
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                              SizedBox(height:20),
                                              MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: TouchRippleEffect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  rippleColor: Colors.grey.withOpacity(0.4),
                                                  onTap: ()=>methods.showGradesBottomSheetAdder(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                      boxShadow: [
                                                        BoxShadow(color: Colors.black38, offset: Offset(1, 1))
                                                      ]
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Grading System', style: TextStyle(color: kara.Colors.primary)),
                                                          SizedBox(height: 5),

                                                        ],
                                                      )
                                                  ),
                                                ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('${_institutionController.institution.value.type=='primary'?'Grades':'Academic Years'}', style: GoogleFonts.abel(fontSize: 20, ),)
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: Container(
                                            width: 350,
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child:
                                                  ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    ...List.generate(academic_years.length, (index) {
                                                      return Row(
                                                        children: [
                                                          Text('${index + 1}', style: TextStyle(fontSize: 20),),
                                                          SizedBox(width: 10,),
                                                          Expanded(
                                                            child: TextField(
                                                              controller: controllers[index],
                                                              cursorHeight: 28,
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () => setState(() {
                                                              academic_years.removeAt(index);
                                                              controllers.removeAt(index);
                                                            }),
                                                            icon: Icon(Icons.delete, color: Colors.red),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                    Row(
                                                      children:[
                                                        IconButton(
                                                          onPressed: () => setState(() {
                                                            TextEditingController controller = TextEditingController();
                                                            academic_years.add('');
                                                            controllers.add(controller);
                                                          }),
                                                          icon: Icon(Icons.add),
                                                        ),
                                                        Expanded(child: Container()),
                                                      ],
                                                    )
                                                  ],
                                                )

                                          ),
                                        ),
                                        Container(
                                          
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: Row(
                                            children: [
                                              academic_years.isNotEmpty?CustomButton(
                                                Text('Save', style: TextStyle(color: Colors.white)),
                                                onTap: () {
                                                  if(academic_years.isNotEmpty){
                                                    FirebaseFirestore.instance.collection('institutions')
                                                        .doc(_tutorController.tutor.value.institutionID).
                                                        update({
                                                          'academic_years': controllers.map<String>((e) => e.text).toList()
                                                        }).then((value){
                                                          methods.shownackbar('Saved!', context);
                                                    });
                                                  }
                                                },
                                              ):Container(),
                                            ],
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}

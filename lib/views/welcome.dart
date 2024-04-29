import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stdominicsadmin/views/sign_in.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import '../helpers/methods.dart';
import '../styles/colors.dart';


class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _SignState();
}

class _SignState extends State<Welcome> {

  Methods _methods = Methods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Kara.background,
        body: Container(
            decoration: BoxDecoration(
                color: Colors.white70
            ),
            child: Center(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                  ),
                  width: 400,
                  height: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/scholar.png', width: 90),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          color: Colors.grey.withOpacity(0.1),
                          child: Center(child: Text('WELCOME BACK', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Kara.green),))
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 40,
                        child: TouchRippleEffect(
                          onTap: ()async{
                            Get.to(()=>Sign(), transition: Transition.rightToLeft);
                          },
                          borderRadius: BorderRadius.circular(10),
                          rippleColor: Colors.greenAccent,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Kara.primary,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                child: Text('Log In Now', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
              ),
            )
        )
    );
  }
}

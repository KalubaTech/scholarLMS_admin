import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stdominicsadmin/customs/content_wrapper.dart';
import 'package:stdominicsadmin/styles/colors.dart';
import 'package:stdominicsadmin/styles/font_sizes.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                    child: ContentWrapper(
                      content: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(child: Image.asset('assets/class.png', width: 50,)),
                                SizedBox(width: 20,),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('2', style: TextStyle(fontSize: FontSize.highheadertext, color: Kara.primary, fontWeight: FontWeight.bold),),
                                        SizedBox(height: 2,),
                                        Container(child: Text('MY CLASSES', style: TextStyle(fontSize: FontSize.mediumheadertext),)),
                                      ],
                                    )
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    )
                ),
                SizedBox(width: 20,),
                Expanded(
                    child: ContentWrapper(
                        content: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(child: Image.asset('assets/results.png', width: 50,)),
                                  SizedBox(width: 20,),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('15', style: TextStyle(fontSize: FontSize.highheadertext, color: Kara.primary, fontWeight: FontWeight.bold),),
                                          SizedBox(height: 2,),
                                          Container(child: Text('RESULTS ENTRY', style: TextStyle(fontSize: FontSize.mediumheadertext),)),
                                        ],
                                      )
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                    )
                ),
                SizedBox(width: 20,),
                Expanded(
                    child: ContentWrapper(
                        content: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(child: Image.asset('assets/report.png', width: 50,)),
                                  SizedBox(width: 20,),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('3', style: TextStyle(fontSize: FontSize.highheadertext, color: Kara.primary, fontWeight: FontWeight.bold),),
                                          SizedBox(height: 2,),
                                          Container(child: Text('REPORT DOCUMENTS', style: TextStyle(fontSize: FontSize.mediumheadertext),)),
                                        ],
                                      )
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                    )
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ContentWrapper(
              content: Container(
                child: // Example 5
                ContainedTabBarView(
                  tabs: [
                    Container(
                      width: 100,
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.inventory_rounded, size: 11, color: Colors.blue,),
                          SizedBox(width: 10,),
                          Text('Results', style: TextStyle(fontSize: FontSize.primarytext),),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.pie_chart, size: 11, color: Colors.orangeAccent,),
                          SizedBox(width: 10,),
                          Text('Reports', style: TextStyle(fontSize: FontSize.primarytext),),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.balance, size: 10, color: Colors.teal,),
                          SizedBox(width: 11,),
                          Text('Pupil Stats', style: TextStyle(fontSize: FontSize.primarytext),),
                        ],
                      ),
                    ),
                  ],
                  tabBarProperties: TabBarProperties(
                    margin: EdgeInsets.only(bottom: 4),
                    width: 270,
                    height: 32,
                    background: Container(
                      decoration: BoxDecoration(
                        color: Kara.background,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                    position: TabBarPosition.top,
                    alignment: TabBarAlignment.start,
                    indicatorColor: Kara.primary,
                    labelColor: Kara.primary,
                    unselectedLabelColor: Kara.primary2,
                  ),
                  views: [
                    Container(color: Kara.background,),
                    Container(color: Kara.background,),
                    Container(color: Kara.background),
                  ],

                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

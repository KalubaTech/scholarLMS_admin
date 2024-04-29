import 'package:flutter/material.dart';

import '../views/tab_pages/assessments_page.dart';
import '../views/tab_pages/books_page.dart';
import '../views/tab_pages/notice_board.dart';
import '../views/tab_pages/results_page.dart';

class TabViewMenu extends StatelessWidget {
  TabViewMenu({required this.tabController, required this.scaffoldState});
  TabController? tabController;
  var scaffoldState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: tabController,
            tabs: [

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.book, size: 16,),
                    SizedBox(width: 20,),
                    Text('Library', style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.edit_note_sharp, size: 20,),
                    SizedBox(width: 15,),
                    Expanded(child: Text('Assignments', style: TextStyle(fontSize: 14),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.feed, size: 20,),
                    SizedBox(width: 15,),
                    Expanded(child: Text('Results', style: TextStyle(fontSize: 14),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.newspaper, size: 20,),
                    SizedBox(width: 15,),
                    Expanded(child: Text('Notice Board', style: TextStyle(fontSize: 14),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ],
                ),
              ),
            ]
        ),
        Expanded(
            child: Container(
              child: TabBarView(
                  controller: tabController,
                  children: [
                    BooksPage(),
                    AssessmentsPage(scaffoldState, context),
                    ResultsPage(),
                    NoticeBoard(context)
                  ]
              ),
            )
        )
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/font_sizes.dart';

class AudienceRoundedItem extends StatelessWidget {
  List<String> selectedList;
  String?image;
  String name;
  AudienceRoundedItem({required this.selectedList, required this.name, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: selectedList.contains(name)?BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            
          )
        ]
      ):BoxDecoration(),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
                width: 20,
                height: 20,
                fit: BoxFit.cover,
                imageUrl: '${image??''}',
                errorWidget: (c,i,s)=>Container(child: Icon(Icons.person),),
            ),
          ),
          Text('${name}', style: TextStyle(fontSize: FontSize.primarytext, color: Kara.primary2),)
        ],
      ),
    );
  }
}

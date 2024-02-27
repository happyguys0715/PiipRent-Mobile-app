import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

class ScoreBadge extends StatelessWidget {
  final dynamic score;

  ScoreBadge({this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier*0.97
        //horizontal: 4.0,
      ),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier*0.29,
        horizontal: SizeConfig.widthMultiplier*1.94
        // vertical: 2.0,
        // horizontal: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.all(
         // Radius.circular(12.0),
          Radius.circular(SizeConfig.heightMultiplier*1.76),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            //size: 14.0,
            size: SizeConfig.heightMultiplier*2.05,
          ),
          SizedBox(
            //width: 4.0,
            width: SizeConfig.widthMultiplier*0.97,
          ),
          Text(
            '$score',
              style: TextStyle(fontSize: SizeConfig.heightMultiplier*2.14,color: Colors.white),
          )
        ],
      ),
    );
  }
}

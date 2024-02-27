import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

class GroupTitle extends StatelessWidget {
  final String? title;

  GroupTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.symmetric(
          //vertical: 15.0,
          vertical:SizeConfig.heightMultiplier*2.34,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Divider(
              color: Colors.blueAccent,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                //horizontal: 10.0
                horizontal:SizeConfig.widthMultiplier*2.43
            ),
            child: Text(
              title!,
              style: TextStyle(
                color: Colors.grey[700],
                //fontSize: 18.0,
                fontSize:SizeConfig.heightMultiplier*2.64,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Divider(
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}

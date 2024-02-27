import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

class ListCard extends StatelessWidget {
  final Widget header;
  final Widget body;

  final Radius cardRadius = Radius.circular(10.0);

  ListCard({required this.header, required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                //Radius.circular(10.0),
                Radius.circular(SizeConfig.heightMultiplier * 1.46),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  //spreadRadius: 3,
                  spreadRadius: SizeConfig.heightMultiplier * 0.43,
                  //blurRadius: 5,
                  blurRadius: SizeConfig.heightMultiplier * 0.73,
                  offset: Offset(
                    0,
                    //2,
                    SizeConfig.heightMultiplier*0.29
                  ),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.heightMultiplier * 1.46),
                      topRight: Radius.circular(SizeConfig.heightMultiplier * 1.46),
                    ),
                  ),
                  child: Padding(
                    //padding: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.46),
                    child: header,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      // bottomLeft: Radius.circular(10.0),
                      // bottomRight: Radius.circular(10.0),
                      bottomLeft:
                          Radius.circular(SizeConfig.heightMultiplier * 1.46),
                      bottomRight:
                          Radius.circular(SizeConfig.heightMultiplier * 1.46),
                    ),
                  ),
                  child: Padding(
                    //padding: EdgeInsets.all(10.0),
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.heightMultiplier * 1.7, vertical: SizeConfig.heightMultiplier * 1),
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

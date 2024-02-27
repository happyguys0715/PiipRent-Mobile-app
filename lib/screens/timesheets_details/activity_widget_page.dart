import 'package:flutter/material.dart';

import '../../widgets/size_config.dart';
import 'package:get/get.dart';

class ActivityWidgetPage extends StatelessWidget {
  const ActivityWidgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color:Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: SizeConfig.heightMultiplier * 5.27,
              ),
              onPressed: () {
                Get.back();
              },
            );
          },
        ),
        title: Text(
          'Activity',
          style: TextStyle(
            fontSize: SizeConfig.heightMultiplier * 2.34,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(
              //8.0,
              SizeConfig.heightMultiplier * 1.17,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: SizeConfig.heightMultiplier * 3.66,
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 2.34,
                horizontal: SizeConfig.widthMultiplier * 3.89,
                // vertical: 16,
                // horizontal: 16,
              ),
              //height: 60,
              height: SizeConfig.heightMultiplier * 8.78,
              decoration: BoxDecoration(
                color: Color(0xffEEF6FF),
                border: Border.all(
                  width: 1,
                  color: Color(0xffD3DEEA),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    //5.0,
                    SizeConfig.heightMultiplier * 0.73,
                  ), //         <--- border radius here
                ),
              ),
              padding: EdgeInsets.all(
                //20,
                SizeConfig.heightMultiplier * 2.93,
              ),
              child: Container(
                width: double.infinity,
                child: DropdownButton(
                  underline: SizedBox(),
                  hint: Text(
                    'Activity',
                    style: TextStyle(
                      color: Colors.black,
                      //fontSize: 16,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  value: "Activity1",
                  items: [
                    DropdownMenuItem(
                      child: Text('Activity1', style: TextStyle(
                        color: Colors.black,
                        //fontSize: 16,
                        fontSize: SizeConfig.heightMultiplier * 2.34,
                      ),),
                      value: "Activity1",
                    ),
                    DropdownMenuItem(
                      child: Text('Activity2', style: TextStyle(
                        color: Colors.black,
                        //fontSize: 16,
                        fontSize: SizeConfig.heightMultiplier * 2.34,
                      ),),
                      value: "Activity2",
                    ),
                    DropdownMenuItem(
                      child: Text('Activity3', style: TextStyle(
                        color: Colors.black,
                        //fontSize: 16,
                        fontSize: SizeConfig.heightMultiplier * 2.34,
                      ),),
                      value: "Activity3",
                    )
                  ],
                  onChanged: (value) {
                    print("changed value");
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 2.34,
                horizontal: SizeConfig.widthMultiplier * 3.89,
                // vertical: 16,
                // horizontal: 16,
              ),
              //height: 60,
              height: SizeConfig.heightMultiplier * 8.78,
              padding: EdgeInsets.all(
                //10,
                SizeConfig.heightMultiplier * 1.46,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffEEF6FF),
                border: Border.all(
                  width: 1,
                  color: Color(0xffD3DEEA),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    //5.0,
                    SizeConfig.heightMultiplier * 0.73,
                  ), //         <--- border radius here
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(
                  //10,
                  SizeConfig.heightMultiplier * 1.46,
                ),
                child: Text(
                  'Amount',
                  style: TextStyle(
                    //fontSize: 16,
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(
              //height: 15,
              height: SizeConfig.heightMultiplier * 1.46,
            ),
            Container(
              padding: EdgeInsets.all(
                //10,
                SizeConfig.heightMultiplier * 1.46,
              ),
              width: double.infinity,
              //height: 56,
              height: SizeConfig.heightMultiplier * 8.20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(
                    //fontSize: 14,
                    fontSize: SizeConfig.heightMultiplier * 2.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Text(
                  'SUBMIT',
                  style: TextStyle(
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

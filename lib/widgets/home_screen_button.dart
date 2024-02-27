import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

class HomeScreenButton extends StatefulWidget {
  final Icon? icon;
  final String? text;
  final Color? color;
  final String? path;
  final Stream? stream;
  final Function? update;

  HomeScreenButton({
    this.icon,
    this.text,
    this.color,
    this.path,
    this.stream,
    this.update,
  });

  @override
  _HomeScreenButtonState createState() => _HomeScreenButtonState();
}

class _HomeScreenButtonState extends State<HomeScreenButton> {
  @override
  void initState() {
    super.initState();
    if (widget.update != null) {
      widget.update!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            //margin: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(SizeConfig.heightMultiplier * 1.17),
            //padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.heightMultiplier * 2.05,
              horizontal: SizeConfig.widthMultiplier * 2.43,
            ),
            child: Row(
              children: [
                widget.icon != null
                    ? Container(
                        //margin: const EdgeInsets.only(right: 10.0),
                        margin: EdgeInsets.only(
                          right: SizeConfig.widthMultiplier * 2.43,
                        ),
                        padding: EdgeInsets.all(
                          SizeConfig.heightMultiplier * 0.73,
                        ),
                        //padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          //borderRadius: BorderRadius.circular(25.0),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.heightMultiplier * 3.66,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: widget.icon,
                      )
                    : SizedBox(
                        //height: 35.0,
                        height: SizeConfig.heightMultiplier * 5.12,
                      ),
                Text(
                  widget.text!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: widget.color,
              //borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  SizeConfig.heightMultiplier * 1.46,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: SizeConfig.heightMultiplier * 0.44,
                  blurRadius: SizeConfig.heightMultiplier * 0.73,
                  // spreadRadius: 3,
                  // blurRadius: 5,
                  offset: Offset(
                    0,
                    //2,
                    SizeConfig.heightMultiplier * 0.29,
                  ),
                ),
              ],
            ),
          ),
          widget.stream != null
              ? StreamBuilder(
                  stream: widget.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data) {
                      return Positioned(
                        top: SizeConfig.heightMultiplier * 0.44,
                        right: SizeConfig.widthMultiplier * 0.73,
                        // top: 3.0,
                        // right: 3.0,
                        child: Container(
                          alignment: Alignment.topRight,
                          // height: 16.0,
                          // width: 16.0,
                          height: SizeConfig.heightMultiplier * 2.34,
                          width: SizeConfig.widthMultiplier * 3.89,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red[300],
                            border: Border.all(
                              color: Colors.white,
                              //width: 3.0,
                              width: SizeConfig.widthMultiplier * 0.73,
                            ),
                          ),
                        ),
                      );
                    }

                    return Container(
                      width: 0.0,
                      height: 0.0,
                    );
                  },
                )
              : Container(
                  width: 0.0,
                  height: 0.0,
                ),
        ],
      ),
      onTap: () {
        if (widget.path != null && widget.path!.isNotEmpty) {
          Navigator.pushNamed(context, widget.path!);
        } else {
          // Handle the case where the path is null or empty
        }
      },
    );
  }
}

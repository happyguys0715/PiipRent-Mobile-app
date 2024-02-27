import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

class ListCardRecord extends StatelessWidget {
  final Widget? content;
  final bool? last;
  final EdgeInsetsGeometry? padding;
  final Color separatorColor;

  ListCardRecord({this.content, this.last = false, this.padding, this.separatorColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxHeight: size.height, maxWidth: size.width);
    SizeConfig().init(constraints, orientation);
    return Container(
      //padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      padding: padding ?? EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.46,
          bottom: SizeConfig.heightMultiplier * 1.46),
      decoration: last!
          ? BoxDecoration()
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: separatorColor,
                  style: BorderStyle.solid
                ),
              ),
            ),
      child: content,
    );
  }
}

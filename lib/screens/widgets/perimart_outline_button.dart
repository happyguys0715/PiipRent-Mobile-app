import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';

import '../../widgets/size_config.dart';

class PrimaryOutlineButton extends StatelessWidget {
  final bool? loading;
  final String? btnText;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  const PrimaryOutlineButton({
    Key? key,
    this.btnText,
    this.onPressed,
    this.loading,
    this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxHeight: size.height, maxWidth: size.width);

    SizeConfig().init(constraints, orientation);

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 40,
      //height: 43,
      height: SizeConfig.heightMultiplier * 6.29,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            //30,
            SizeConfig.heightMultiplier * 4.39,
          ),
          border: Border.all(
            color: buttonColor ?? primaryColor,
            width: 2,
          ),
        ),
        child: MaterialButton(
          elevation: 0.0,
          focusElevation: 0.0,
          disabledElevation: 0.0,
          splashColor: buttonColor ?? primaryColor,
          //height: 43,
          height: SizeConfig.heightMultiplier * 6.29,
          minWidth: 164,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              //30,
              SizeConfig.heightMultiplier * 4.39,
            ),
          ),
          color: whiteColor,
          onPressed: onPressed,
          child: loading ?? false
              ? CircularProgressIndicator(
                  color: primaryColor,
                )
              : Center(
                  child: Text(
                    btnText!,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      //fontSize: 16,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

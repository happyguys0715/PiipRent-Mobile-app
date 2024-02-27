import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/widgets/size_config.dart';

class PrimaryButton extends StatelessWidget {
  final bool? loading;
  final String? btnText;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final double? height;
  const PrimaryButton(
      {Key? key, this.btnText, this.onPressed, this.loading, this.buttonColor, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? SizeConfig.heightMultiplier * 6.29,
      width: SizeConfig.widthMultiplier * 39.90,
      // height: 43,
      // width: 164,
      child: MaterialButton(
        splashColor: whiteColor,
        height: SizeConfig.heightMultiplier * 6.29,
        // height: 43,
        minWidth: 164,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
           // 30,
            SizeConfig.heightMultiplier*4.87,
          ),
        ),
        color: buttonColor ?? primaryColor,
        disabledColor: buttonColor != null
            ? buttonColor!.withOpacity(.5)
            : primaryColor.withOpacity(.5),
        onPressed: onPressed,
        child: loading ?? false
            ? Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  color: whiteColor,
                ),
              )
            : Center(
                child: Text(
                  btnText!,
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                    //fontSize: 16,
                  ),
                ),
              ),
      ),
    );
  }
}

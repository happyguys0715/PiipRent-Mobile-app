import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

class FormSubmitButton extends StatelessWidget {
  final bool disabled;
  final void Function()? onPressed;
  final String label;
  final Color color;
  final double horizontalPadding;

  FormSubmitButton({
    required this.disabled,
    required this.onPressed,
    required this.label,
    this.color = Colors.blueAccent,
    this.horizontalPadding = 60,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: color,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * (horizontalPadding / 4.11),
          vertical: SizeConfig.heightMultiplier * 1.46
          //vertical: 10,
          ),
      color: color,
      textColor: Colors.white,
      // disabledColor: Colors.blue[200],
      disabledTextColor: Colors.white,
      shape: RoundedRectangleBorder(
       // borderRadius: BorderRadius.circular(20),
        borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier*2.92),
      ),
      onPressed: disabled ? null : onPressed,
      child: disabled ?? false
          ? SizedBox(
              height: SizeConfig.heightMultiplier * 2.93,
              width: SizeConfig.widthMultiplier * 4.87,
              // height: 20,
              // width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2.34
                  //fontSize: 16,
                  ),
            ),
    );
  }
}

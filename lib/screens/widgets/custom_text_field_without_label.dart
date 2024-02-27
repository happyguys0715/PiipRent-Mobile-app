import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/widgets/size_config.dart';

class CustomTextFieldWIthoutLabel extends StatelessWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final TextEditingController? controller;
  final Function? validator;
  final bool? passowrd;
  final TextInputType? type;
  
  const CustomTextFieldWIthoutLabel({
    Key? key,
    this.hint,
    this.onChanged,
    this.onSubmit,
    this.controller,
    this.validator,
    this.passowrd,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      obscureText: passowrd ?? false,
      validator: validator as String? Function(String?)?,
      onChanged: onChanged,
      controller: controller,
      onFieldSubmitted: onSubmit == null ? null : (String? value) {
        onSubmit!(value!);
      },
      style: TextStyle(
        color: activeTextColor,
        //fontSize: 16,
        fontSize: SizeConfig.heightMultiplier * 2.34,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: hintColor, width: 1.0),
          //borderRadius: BorderRadius.circular(8),
          borderRadius: BorderRadius.circular(
            SizeConfig.heightMultiplier * 1.17,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusColor: primaryColor,
        fillColor: whiteColor,
        filled: true,
        isDense: true,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(
          // horizontal: 20,
          // vertical: 16,
          horizontal:SizeConfig.widthMultiplier*4.86,
          vertical: SizeConfig.heightMultiplier*2.34,
        ),
        hintStyle: TextStyle(
          color: hintColor,
          //fontSize: 16,
          fontSize: SizeConfig.heightMultiplier*2.34,
        ),
        border: OutlineInputBorder(
          //borderRadius: BorderRadius.circular(8),
          borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier*1.17),
        ),
      ),
    );
  }
}

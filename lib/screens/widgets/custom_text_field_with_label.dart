import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/validator.dart';

import '../../widgets/size_config.dart';

class CustomTextFieldWIthLabel extends StatefulWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Function? validator;
  final VoidCallback? onTap;
  final bool required;
  final bool? capital;
  final TextInputType? type;

  const CustomTextFieldWIthLabel({
    Key? key,
    this.type,
    this.hint,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.required = true,
    this.capital,
  }) : super(key: key);

  @override
  _CustomTextFieldWithLabelState createState() =>
      _CustomTextFieldWithLabelState();
}

class _CustomTextFieldWithLabelState extends State<CustomTextFieldWIthLabel> {
  bool hasText = false;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    hasText = widget.controller!.text.isNotEmpty;
    widget.controller!.addListener(updateHasText);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    widget.controller!.removeListener(updateHasText);
    super.dispose();
  }

  void updateHasText() {
    if (mounted) {
      setState(() {
        hasText = widget.controller!.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);

    return Padding(
      padding: EdgeInsets.symmetric(
        //vertical: 10,
        vertical: SizeConfig.heightMultiplier * 1.46,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // CircleAvatar(
              //   backgroundColor: primaryColor,
              //   radius: 2.5,
              // ),
              // SizedBox(
              //   //width: 5,
              //   width: SizeConfig.widthMultiplier * 1.22,
              // ),
              Text(
                widget.hint!,
                style: TextStyle(
                  //fontSize: 12,
                  fontSize: SizeConfig.heightMultiplier * 1.76,
                  fontWeight: FontWeight.w400,
                  color: greyColor,
                ),
              ),
              SizedBox(
                //width: 5,
                width: SizeConfig.widthMultiplier * 1.22,
              ),
              if (widget.required)
                Text(
                  '✱',
                  style: TextStyle(
                    //fontSize: 10,
                    fontSize: SizeConfig.heightMultiplier * 1.46,
                    fontWeight: FontWeight.w400,
                    color: warningColor,
                  ),
                ),
            ],
          ),
          SizedBox(
            //height: 10,
            height: SizeConfig.heightMultiplier * 1.46,
          ),
          // TextFormField(
          //   textCapitalization: widget.capital != null
          //       ? TextCapitalization.characters
          //       : TextCapitalization.none,
          //   keyboardType: widget.type ?? TextInputType.text,
          //   onTap: widget.onTap,
          //   readOnly: widget.onTap != null,
          //   validator: widget.required ? requiredValidator : null,
          //   controller: widget.controller,
          //   onChanged: widget.onChanged,
          //   style: TextStyle(
          //     color: activeTextColor,
          //     //fontSize: 16,
          //     fontSize: SizeConfig.heightMultiplier * 2.34,
          //   ),
          //   decoration: InputDecoration(
          //     errorStyle: TextStyle(
          //       color: Colors.red,
          //       //fontSize: 16,
          //       fontSize: SizeConfig.heightMultiplier * 2.34,
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(color: hintColor, width: 1.0),
          //       borderRadius: BorderRadius.circular(
          //         //8,
          //         SizeConfig.heightMultiplier * 1.17,
          //       ),
          //     ),
          //     focusColor: primaryColor,
          //     suffixIcon: widget.type == TextInputType.text ||
          //             widget.type == TextInputType.number ||
          //             widget.type == TextInputType.datetime ||
          //             widget.type == TextInputType.emailAddress
          //         ? null
          //         : Icon(
          //             Icons.arrow_drop_down,
          //             color: Colors.blue,
          //           ),
          //     fillColor: hasText &&
          //             (widget.type != TextInputType.text &&
          //               widget.type != TextInputType.number &&
          //               widget.type != TextInputType.datetime &&
          //               widget.type != TextInputType.emailAddress)
          //         ? Colors.blue[50]
          //         : whiteColor,
          //     filled: true,
          //     isDense: true,
          //     hintText: widget.hint,
          //     contentPadding: EdgeInsets.symmetric(
          //       horizontal: SizeConfig.widthMultiplier * 4.86,
          //       vertical: SizeConfig.heightMultiplier * 2.34,
          //       // horizontal: 20,
          //       // vertical: 16,
          //     ),
          //     hintStyle: TextStyle(
          //       color: hintColor,
          //       //fontSize: 16,
          //       fontSize: SizeConfig.heightMultiplier * 2.34,
          //     ),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(
          //         //8,
          //         SizeConfig.heightMultiplier * 1.17,
          //       ),
          //     ),
          //   ),
          // ),
          MouseRegion(
            onEnter: (_) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                isHovered = false;
              });
            },
            child: InkWell(
              onTap: widget.onTap,
              child: TextFormField(
                textCapitalization: widget.capital != null
                    ? TextCapitalization.characters
                    : TextCapitalization.none,
                keyboardType: widget.type ?? TextInputType.text,
                onTap: widget.onTap,
                readOnly: widget.onTap != null,
                validator: widget.required ? requiredValidator : null,
                controller: widget.controller,
                onChanged: widget.onChanged,
                style: TextStyle(
                  color: activeTextColor,
                  //fontSize: 16,
                  fontSize: SizeConfig.heightMultiplier * 2.34,
                ),
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                    color: Colors.red,
                    //fontSize: 16,
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isHovered ? Colors.white : hintColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(
                      SizeConfig.heightMultiplier * 1.17,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor, // Change to your desired focus color
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(
                      SizeConfig.heightMultiplier * 1.17,
                    ),
                  ),
                  suffixIcon: widget.type == TextInputType.text ||
                          widget.type == TextInputType.number ||
                          widget.type == TextInputType.datetime ||
                          widget.type == TextInputType.emailAddress
                      ? null
                      : Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue,
                        ),
                  // fillColor: hasText &&
                  //         (widget.type != TextInputType.text &&
                  //             widget.type != TextInputType.number &&
                  //             widget.type != TextInputType.datetime &&
                  //             widget.type != TextInputType.emailAddress)
                  fillColor: hasText
                      ? Colors.blue[50]
                      : whiteColor,
                  filled: true,
                  isDense: true,
                  // hintText: widget.hint,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 4.86,
                    vertical: SizeConfig.heightMultiplier * 2.34,
                    // horizontal: 20,
                    // vertical: 16,
                  ),
                  hintStyle: TextStyle(
                    color: hintColor,
                    //fontSize: 16,
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      //8,
                      SizeConfig.heightMultiplier * 1.17,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

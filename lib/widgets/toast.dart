import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:piiprent/helpers/colors.dart';

Future<bool?> toast(msg)=>Fluttertoast.showToast(
    msg: msg,
   textColor: AppColors.lightBlack,
   backgroundColor: Colors.grey.withOpacity(0.5),
);


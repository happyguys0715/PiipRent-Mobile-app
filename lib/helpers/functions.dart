import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/widgets/size_config.dart';

Map<String, String> generateTranslations(
  List<dynamic> translations,
  String name,
) {
  Map<String, String> result = Map();

  if (result[languageMap['EN'] ?? 'default'] == null) {
    result.addAll({languageMap['EN'] ?? 'default': name});
  } else {
    translations.forEach((element) {
      result.addAll({element['language']['id']: element['value']});
    });

    if (result[languageMap['EN'] ?? 'default'] == null) {
      result.addAll({languageMap['EN'] ?? 'default': name});
    }

  }

  return result;
}

String parseAddress(Map<String, dynamic> address) {
  if (address != null) {
    return (address['__str__'] as String).replaceAll('\n', ' ');
  }

  return '';
}

double doubleParse(dynamic target, [defaultValue = 0.00]) {
  if (target.runtimeType == String) {
    return double.parse(target);
  }

  return defaultValue;
}

void showProminentDisclosureDialog(
    BuildContext context, Function action) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isPermissionAllowed') == true) {
    var status = await Permission.location.status;
    if (status.isGranted) {
      action(true);
      return;
    } else {
      prefs.setBool('isPermissionAllowed', false);
    }
  }
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: Text(
              'Prominent disclosure',
              style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
            content: Text(
              'If you have started a job from the App then Piiprent collects your location data to track your job progress even if the app is working in background.\nThe app is not functional without location permission.',
              style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  action(false);
                },
                child: Text('Deny',style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 2.34,
                ),),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  requestPermission(context, action);
                },
                child: Text('Agree',style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 2.34,
                ),),
              ),
            ],
          ));
    },
  );
}

void requestPermission(BuildContext context, Function action) async {
  if (await Permission.location.request().isGranted) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPermissionAllowed', true);
    action(true);
  } else {
    var status = await Permission.location.status;
    if (status.isPermanentlyDenied) {
      showErrorDialog(context, 'Permission is required',
          'Location Permission is required in order to access this feature. Please go to App settings from the System settings in order to allow location permission.',
          action: action);
    }
  }
}

void showDenyAlertDialog(BuildContext context, Function action) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              "We track your work location if you are going to work and have an active shift. You are not eligible for this work without confirmation of this permission.",
              style: TextStyle(
            fontSize: SizeConfig.heightMultiplier*2.34,
            ),
              textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  action(false);
                },
                child: Text('Close',style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier*2.34,
                ),),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  action(true);
                },
                child: Text('Allow',style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier*2.34,
                ),),
              ),
            ],
          ));
    },
  );
}

void showErrorDialog(BuildContext context, String title, String message,
    {required Function action}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          title: Text(title ?? 'Error occurred',style: TextStyle(
            fontSize: SizeConfig.heightMultiplier * 2.34,
          ),),
          content: Text(
            message ?? 'Unexpected error occurred.',
            style: TextStyle(
              fontSize: SizeConfig.heightMultiplier * 2.34,
            ),
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                action(null);
              },
              child: Text('Close',style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),),
            ),
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
                if (await Permission.location.status.isGranted) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('isPermissionAllowed', true);
                  action(true);
                } else {
                  action(null);
                }
              },
              child: Text('Open App settings',style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),),
            ),
          ],
        ),
      );
    },
  );
}

DateTime? stringDateToDateTime(String date) {
  try {
    return DateFormat("MMM dd, yyyy").parse(date);
  } catch (e) {
    return null;
  }
}

TimeOfDay? stringTimeToTimeOfDay(String time) {
  try {
    return TimeOfDay.fromDateTime(DateFormat.jm().parse(time));
  } catch (e) {
    return null;
  }
}

TimeOfDay? stringBreakTimeToTimeOfDay(String breakTime) {
  try {
    return TimeOfDay.fromDateTime(DateFormat.Hm()
        .parse(breakTime.replaceAll('h ', ':').replaceAll('m', '')));
  } catch (e) {
    return null;
  }
}

String formatDateTime(DateTime _dateTime) {
  try {
    return DateFormat("dd/MM/yyyy h:mm a").format(_dateTime);
  } catch (e) {
    return _dateTime.toString();
  }
}

String getRolePosition(Role role) {
  if (role.name == "candidate") {
    return 'Candidate, ' + role.company!;
  }
  
  return role.jobTitle! + ', ' + role.company!;
}

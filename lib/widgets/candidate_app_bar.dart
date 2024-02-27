import 'package:flutter/material.dart';
import 'package:piiprent/screens/candidate_notification_screen.dart';
import 'package:piiprent/screens/widgets/menu.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/language-select.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

PreferredSizeWidget getCandidateAppBar(String title, BuildContext context,
    {bool showNotification = true,
    required List<Tab> tabs,
    required Widget? leading,
    IconThemeData? iconTheme,
    bool isPadding = false}) {
  return AppBar(
    backgroundColor: Colors.blue[500],
    centerTitle: true,
    actions: [
      Consumer<LoginService>(
        builder: (_, loginService, __) {
          return Visibility(
            visible: loginService.user != null
                ? loginService.user?.roles != null
                : false,
            child: SwitchAccount(),
          );
        },
      ),
      Padding(
        padding: isPadding 
            ? EdgeInsets.only(right: 10, top: 2.5)
            : EdgeInsets.only(top: 2.5),
        child: LanguageSelect(),
      ),
      showNotification
          ? Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  color:Colors.white,
                  iconSize: 26,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CandidateNotificationScreen())),
                  icon: Icon(Icons.announcement),
                ),
              ],
            )
          : SizedBox(),
    ],
    title: Padding(
      padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 17.5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: SizeConfig.heightMultiplier * 2.93,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    leading: leading != null ? leading : null,
    iconTheme: iconTheme
  );
}

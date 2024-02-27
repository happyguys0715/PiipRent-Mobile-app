
import 'package:flutter/material.dart';
import 'package:piiprent/screens/widgets/menu.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/language-select.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

PreferredSizeWidget? getClientAppBar(
  String title,
  BuildContext context, {
  required List<Tab> tabs,
  Widget? leading,
  IconThemeData? iconTheme,
}) {
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
            child: SwitchAccount(key: null,),
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.only(right: 12.0, left: 4.0, top: 2.5),
        child: LanguageSelect(),
      ),
    ],
    title: Padding(
      padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: SizeConfig.heightMultiplier * 2.93,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    bottom: tabs.isNotEmpty
        ? TabBar(
            tabs: tabs,
            indicator: BoxDecoration(), // Custom indicator with no decoration
          )
        : null,
    leading: leading,
    iconTheme: iconTheme ?? IconThemeData(color: Colors.white),
  );
}
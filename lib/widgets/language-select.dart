import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/mixins/change_language.dart';
import 'package:piiprent/widgets/size_config.dart';

class LanguageSelect extends StatefulWidget with ChangeLanguage {
  Color? _color;
  LanguageSelect({
    color = Colors.white,
  }) {
    _color = color;
  }

  @override
  State<LanguageSelect> createState() => _LanguageSelectState();
}

class _LanguageSelectState extends State<LanguageSelect> {
  CustomPopupMenuController _controller = CustomPopupMenuController();
  List<String> lans = [
    translate('language.name.en'),
    translate('language.name.et'),
    translate('language.name.fi'),
    translate('language.name.ru'),
  ];

  List<String> codes = [
    'en',
    'et',
    'fi',
    'ru',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      showArrow: false,
      barrierColor: Colors.black38,
      position: PreferredPosition.bottom,
      child: Container(
        
        child: Icon(
          Icons.language,
          color: widget._color,
          size: 30
        ),
        // margin: EdgeInsets.only(
        //    // bottom: SizeConfig.heightMultiplier * 2.93,
        //     right: SizeConfig.heightMultiplier * 2.93),
        // padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2.93),
      ),
      menuBuilder: () => StatefulBuilder(builder: (context, setState) {
        return Padding(padding: EdgeInsets.only(top: 10),
        child: Container(
          width: SizeConfig.widthMultiplier * 40.63,
          height: SizeConfig.heightMultiplier * 29.1,
          // width: 167,
          // height: 198,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0XFFD3DEEA),
              width: 1,
            ),
            color: whiteColor,
            // borderRadius: BorderRadius.circular(
            //   //12,
            //   SizeConfig.heightMultiplier * 1.76,
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(4, (index) => index)
                .map(
                  (index) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _controller.hideMenu();
                      if (Localizations.localeOf(context).languageCode !=
                          codes[index]) {
                        changeLocale(
                          context,
                          codes[index],
                        );
                        var locale = Locale(codes[index], '');

                        Get.updateLocale(locale);
                      }

                      // setState(() {});
                    },
                    child: Container(
                      color: Localizations.localeOf(context).languageCode ==
                              codes[index]
                          ? primaryColor.withOpacity(.1)
                          : whiteColor,
                      //height: 49,
                      height: SizeConfig.heightMultiplier * 7.17,
                      padding: EdgeInsets.symmetric(
                        //horizontal: 20,
                        horizontal: SizeConfig.widthMultiplier * 4.87,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Localizations.localeOf(context).languageCode ==
                                        codes[index]
                                    ? Icons.radio_button_on
                                    : Icons.radio_button_off,
                            //size: 15,
                            size: SizeConfig.heightMultiplier * 2.19,
                            color:
                                Localizations.localeOf(context).languageCode ==
                                        codes[index]
                                    ? primaryColor
                                    : hintColor,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                //left: 10,
                                left: SizeConfig.widthMultiplier * 2.43,
                              ),
                              padding: EdgeInsets.symmetric(
                                //vertical: 10,
                                vertical: SizeConfig.heightMultiplier * 1.46,
                              ),
                              child: Text(
                                lans[index],
                                style: TextStyle(
                                  color: Localizations.localeOf(context)
                                              .languageCode ==
                                          codes[index]
                                      ? primaryColor
                                      : primaryColor.withOpacity(.3),
                                  //fontSize: 16,
                                  fontSize: SizeConfig.heightMultiplier * 2.34,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),)
        ;
      }),
      pressType: PressType.singleClick,
      //verticalMargin: -10,
      verticalMargin: -(SizeConfig.heightMultiplier * 1.46),
      controller: _controller,
    );

    // return IconButton(
    //   color: _color,
    //   iconSize: 24,
    //   onPressed: () => onActionSheetPress(context),
    //   icon: Icon(Icons.language),
    // );
  }
}



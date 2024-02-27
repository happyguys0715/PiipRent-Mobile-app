import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:piiprent/screens/candidate/candidate_acceptance_form.dart';
import 'package:piiprent/screens/widgets/perimart_outline_button.dart';
import 'package:piiprent/screens/widgets/primary_button.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:get/get.dart';

class ToolsStepScreen extends StatefulWidget {
  const ToolsStepScreen({Key? key}) : super(key: key);

  @override
  State<ToolsStepScreen> createState() => _ToolsStepScreenState();
}

class _ToolsStepScreenState extends State<ToolsStepScreen> {
  int currentStep = 1;
  int pageIndex = 1;

  int _usePowerTools = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0,
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color:Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: SizeConfig.heightMultiplier * 5.27,
              ),
              onPressed: () {
                Get.back();
              },
            );
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(
            //left: 8.0,
            left: SizeConfig.widthMultiplier * 1.95,
          ),
          child: Text(
            'Tools',
            style: TextStyle(
                //fontSize: 20,
                fontSize: SizeConfig.heightMultiplier * 2.93,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                right: SizeConfig.widthMultiplier * 1.95,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                //size: 24,
                size: SizeConfig.heightMultiplier * 3.51,
              ),
            ),
          ),
        ],
      ),
      bottomSheet: !(MediaQuery.of(context).viewInsets.bottom > 70)
          ? Container(
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryOutlineButton(
                      btnText: translate('button.back'),
                      onPressed: () {
                        if (pageIndex > 1) {
                          setState(() {
                            pageIndex--;
                            currentStep--;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    //width: 15,
                    width: SizeConfig.widthMultiplier * 2.20,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      buttonColor: pageIndex == 5 ? Color(0xff66BA6C) : null,
                      btnText: pageIndex == 5
                          ? translate('button.submit')
                          : translate('button.next'),
                      onPressed: () {
                        if (pageIndex < 5) {
                          setState(() {
                            pageIndex++;
                            currentStep++;
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
              //height: 78 + MediaQuery.of(context).padding.bottom,
              height: (SizeConfig.heightMultiplier * 11.42) +
                  MediaQuery.of(context).padding.bottom,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    offset: Offset(0, -2),
                    //blurRadius: 12,
                    blurRadius: SizeConfig.heightMultiplier * 1.76,
                  ),
                ],
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                // right: 16,
                // left: 16,
                right: SizeConfig.widthMultiplier * 3.89,
                left: SizeConfig.widthMultiplier * 3.89,
              ),
            )
          : null,
      body: Column(
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  // top: 29,
                  // right: 40,
                  // left: 40,
                  top: SizeConfig.heightMultiplier * 2.25,
                  right: SizeConfig.widthMultiplier * 9.32,
                  left: SizeConfig.widthMultiplier * 9.32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: '0$currentStep ',
                            style: GoogleFonts.roboto(
                              //fontSize: 36,
                              fontSize: SizeConfig.heightMultiplier * 5.27,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2196F3),
                            ),
                            children: [
                              TextSpan(
                                text: 'of 05',
                                style: GoogleFonts.roboto(
                                  //fontSize: 18,
                                  fontSize: SizeConfig.heightMultiplier * 2.64,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBCC8D6),
                                ),
                              )
                            ]),
                      ),
                      SizedBox(
                        //height: 6,
                        height: SizeConfig.heightMultiplier * 0.87,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressBar(
                          maxSteps: 5,
                          minHeight: 10,
                          progressType: LinearProgressBar.progressTypeLinear,
                          // Use Linear progress
                          currentStep: currentStep,
                          progressColor: Color(0xff2196F3),
                          backgroundColor: Color(0xffEEF6FF),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            //height: 102,
            height: SizeConfig.heightMultiplier * 14.93,
            color: Color(0xffFBFBFD),
          ),
          if (pageIndex == 1) buildUsePowerTools(),
          if (pageIndex == 3) buildInterestedWork(),
        ],
      ),
    );
  }

  buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 3.89,
        vertical: SizeConfig.heightMultiplier * 3.66,
        // horizontal: 16.0,
        // vertical: 25,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          //fontSize: 24,
          fontSize: SizeConfig.heightMultiplier * 3.51,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  buildUsePowerTools() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('Can you use power tools?'),
        SizedBox(
          //height: 6,
          height: SizeConfig.heightMultiplier * 0.88,
        ),
        WhiteShadowContainer(
          title: 'All power tools',
          value: 0,
          selectedOptions: _usePowerTools,
          onChanged: (val) {
            setState(() {
              _usePowerTools = val;
            });
          },
        ),
        SizedBox(
          //height: 5,
          height: SizeConfig.heightMultiplier * 0.73,
        ),
        WhiteShadowContainer(
          title: 'Most power tools',
          value: 1,
          selectedOptions: _usePowerTools,
          onChanged: (val) {
            setState(() {
              _usePowerTools = val;
            });
          },
        ),
        SizedBox(
          //height: 5,
          height: SizeConfig.heightMultiplier * 0.73,
        ),
        WhiteShadowContainer(
          title: 'Some power tools',
          value: 2,
          selectedOptions: _usePowerTools,
          onChanged: (val) {
            setState(() {
              _usePowerTools = val;
            });
          },
        ),
        SizedBox(
          //height: 5,
          height: SizeConfig.heightMultiplier * 0.73,
        ),
        WhiteShadowContainer(
          title: 'Can`t use power tools',
          value: 3,
          selectedOptions: _usePowerTools,
          onChanged: (val) {
            setState(() {
              _usePowerTools = val;
            });
          },
        ),
      ],
    );
  }

  buildInterestedWork() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('What type of work are you particularly interested in?'),
        SizedBox(
          //height: 6,
          height: SizeConfig.heightMultiplier * 0.87,
        ),
      ],
    );
  }

}

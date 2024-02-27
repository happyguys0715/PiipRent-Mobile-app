import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';

import '../../widgets/candidate_drawer.dart';
import '../../widgets/size_config.dart';

class ImageLoadingContainer extends StatelessWidget {
  const ImageLoadingContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      // // height: SizeConfig.heightMultiplier * 18.04,
      // // width: SizeConfig.widthMultiplier * 27.03,
      // height: size.width > 950 && size.height > 450 ? 300 : 150,
      // width: size.width > 950 && size.height > 450 ? 300 : 150,
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 300,
        minWidth: 120,
        minHeight: 120,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(.1),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      // // height: SizeConfig.heightMultiplier * 18.04,
      // // width: SizeConfig.widthMultiplier * 27.03,
      // height: size.width > 950 && size.height > 450 ? 300 : 150,
      // width: size.width > 950 && size.height > 450 ? 300 : 150,
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 300,
        minWidth: 120,
        minHeight: 120,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(.1),
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.person_fill,
          size: 90,
          //size: SizeConfig.heightMultiplier * 13.17,
          color: primaryColor,
        ),
      ),
    );
  }
}

class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ImageContainer(
      content: Center(
        child: Icon(
          Icons.error,
          color: Colors.red,
          //size: 90,
          size: SizeConfig.heightMultiplier * 13.17,
        ),
      ),
    );
  }
}

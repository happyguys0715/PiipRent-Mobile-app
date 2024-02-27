import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/widgets/size_config.dart';

class MoreButton extends StatelessWidget {
  final bool? isShow;
  final Stream? stream;
  final VoidCallback? onPressed;

  MoreButton({this.isShow, this.stream, this.onPressed});

  _buildWrapper(child) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          //bottom: 8.0,
          bottom: SizeConfig.heightMultiplier * 1.17,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // Orientation orientation = MediaQuery.of(context).orientation;
    // BoxConstraints constraints =
    //     BoxConstraints(maxHeight: size.height, maxWidth: size.width);
    if (!isShow!) {
      return SizedBox();
    }

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        bool fetching = snapshot.hasData && snapshot.data;

        if (fetching) {
          return _buildWrapper(CircularProgressIndicator());
        }

        return _buildWrapper(
          ElevatedButton(
            onPressed: onPressed,
            child: Text(
              translate('button.load'),
              style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
          ),
        );
      },
    );
  }
}

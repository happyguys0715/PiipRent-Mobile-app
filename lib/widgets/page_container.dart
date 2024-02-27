import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  PageContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // constraints: BoxConstraints(
      //   maxWidth: 1250,
      //   maxHeight: 2600
      // ),
      child: child,
    );
  }
}

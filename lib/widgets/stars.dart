import 'package:flutter/material.dart';

class Stars extends StatefulWidget {
  final bool? canEdit;
  final Function? onChange;
  final int? active;

  Stars({this.canEdit, this.onChange, this.active = 0});

  @override
  _StarsState createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  int? _active;

  @override
  void initState() {
    super.initState();
    if (widget.active.runtimeType == int) {
      _active = widget.active;
    } else {
      _active = widget.active?.floor();
    }
  }

  Widget _buildStar(int index) {
    return GestureDetector(
      onTap: () {
        if (widget.canEdit!) {
          setState(() {
            _active = index;
          });
        }
      },
      child: Icon(
        Icons.star,
        color: index == _active || index < _active!
            ? Colors.orangeAccent
            : Colors.orangeAccent[100],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStar(1),
        _buildStar(2),
        _buildStar(3),
        _buildStar(4),
        _buildStar(5),
      ],
    );
  }
}

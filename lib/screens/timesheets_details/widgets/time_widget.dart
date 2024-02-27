import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TimeButtonWidget extends StatefulWidget {
  TimeButtonWidget({Key? key}) : super(key: key);

  @override
  _TimeButtonWidgetState createState() => _TimeButtonWidgetState();
}

class _TimeButtonWidgetState extends State<TimeButtonWidget> {
  TimeOfDay _time = new TimeOfDay.now();

  Future selectTime(BuildContext context) async {
    TimeOfDay? _picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (_picked != null && _picked != _time) {
      setState(() {
        _time = _picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xffEEF6FF),
            border: Border.all(
              width: 1,
              color: Color(0xffD3DEEA),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0), //         <--- border radius here
            ),
          ),
          width: 155,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time',
                style: TextStyle(fontSize: 16),
              ),
              SvgPicture.asset("images/icons/ic_time.svg"),
            ],
          ),
        ),
        onPressed: () => selectTime(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/widgets/size_config.dart';

class Evaluate extends StatefulWidget {
  final int? score;
  final bool? active;
  final Function? onChange;

  Evaluate({
    this.score,
    this.active,
    this.onChange,
  });

  @override
  _EvaluateState createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  List<bool> _scoreMap = [];
  int? _score;

  Widget _buildStar(bool active, int index) {
    return GestureDetector(
      onTap: widget.active!
          ? () {
              widget.onChange!(index + 1);
              setState(() {
                _score = index + 1;
                _scoreMap = _fillStars();
              });
            }
          : () {},
      child: Container(
        margin:EdgeInsets.symmetric(
            //horizontal: 3.0,
            horizontal:SizeConfig.widthMultiplier*0.72,
        ),
        padding:EdgeInsets.symmetric(
            // horizontal: 6.0,
            // vertical: 4.0,
          horizontal:SizeConfig.widthMultiplier*1.46,
            vertical:SizeConfig.heightMultiplier*0.59,
        ),
        child: Icon(
          Icons.star,
          //size: 22,
          size:SizeConfig.heightMultiplier*3.22,
          color: active ? Colors.amber : Colors.grey,
        ),
      ),
    );
  }

  @override
  void initState() {
    _score = widget.score;
    _scoreMap = _fillStars();
    super.initState();
  }

  List<bool> _fillStars() {
    List<bool> scoreMap = [];
    for (var i = 0; i < 5; i++) {
      scoreMap.add(i < _score!);
    }

    return scoreMap;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);

    return Container(
      //width: 300,
      width: SizeConfig.widthMultiplier * 72.99,
      margin: EdgeInsets.symmetric(
        //vertical: 15.0,
        vertical: SizeConfig.heightMultiplier * 2.34,
        horizontal: SizeConfig.widthMultiplier * 2.76,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 1.76,
        vertical: SizeConfig.heightMultiplier * 0.73,
        // horizontal: 12.0,
        // vertical: 5.0,
      ),
      decoration: widget.active!
          ? BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(
                //Radius.circular(20.0),
                Radius.circular(
                  SizeConfig.heightMultiplier * 2.93,
                ),
              ),
            )
          : null,
      child: Row(
        children: [
          widget.active!
              ? Expanded(
                  flex: 1,
                  child: Text(
                    translate('timesheet.evaluate'),
                    style: TextStyle(
                      //fontSize: 18.0,
                      fontSize:SizeConfig.heightMultiplier*2.64,
                    ),
                  ),
                )
              : SizedBox(),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _scoreMap
                  .asMap()
                  .map(
                    (key, active) => MapEntry(
                      key,
                      _buildStar(active, key),
                    ),
                  )
                  .values
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

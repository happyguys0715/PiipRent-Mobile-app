import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/widgets/filter_dialog.dart';
import 'package:piiprent/widgets/size_config.dart';

class FilterDialogButton extends StatefulWidget {
  final String? from;
  final String? to;
  final Function onClose;

  FilterDialogButton({
    this.from,
    this.to,
    required this.onClose,
  });

  @override
  _FilterDialogButtonState createState() => _FilterDialogButtonState();
}

class _FilterDialogButtonState extends State<FilterDialogButton> {
  DateTime? _from;
  DateTime? _to;

  get hasData {
    return _from != null || _to != null;
  }

  @override
  void initState() {
    if (widget.from != null) {
      _from = DateTime.parse(widget.from as String);
    }

    if (widget.to != null) {
      _to = DateTime.parse(widget.to as String);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showDialog,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.filter_list,
            color: Colors.blue,
            size: SizeConfig.heightMultiplier * 3.66,
          ),

          // TODO: implement showing functionality
          hasData
              ? Positioned(
                  top: -(SizeConfig.heightMultiplier * 0.29),
                  right: -(SizeConfig.widthMultiplier * 0.49),
                  // top: -2.0,
                  // right: -2.0,
                  child: Container(
                    alignment: Alignment.topRight,
                    height: SizeConfig.heightMultiplier * 1.76,
                    width: SizeConfig.widthMultiplier * 2.92,
                    // height: 12.0,
                    // width: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red[300],
                      border: Border.all(
                        color: Colors.white,
                        //width: 3.0,
                        width: SizeConfig.widthMultiplier * 0.73,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  _onClose(dynamic event) {
    if (event == FilterDialogResult.Submit) {
      widget.onClose({
        "from": _from != null ? DateFormat('yyyy-MM-dd').format(_from!) : null,
        "to": _to != null ? DateFormat('yyyy-MM-dd').format(_to!) : null,
      });
    } else if (event == FilterDialogResult.Clear) {
      widget.onClose({"from": null, "to": null});
      setState(() {
        _from = null;
        _to = null;
      });
    } else {
      widget.onClose({"from": widget.from, "to": widget.to});
    }
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(FilterDialogResult.Clear);
            },
            child: Text(
              translate('button.clear'),
              style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(FilterDialogResult.Submit);
            },
            // color: Colors.blueAccent,
            child: Text(
              translate('button.submit'),
              style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
          ),
        ],
        title: Text(
          translate('dialog.choose_dates'),
          style: TextStyle(
            fontSize: SizeConfig.heightMultiplier * 2.34,
          ),
        ),
        contentPadding: EdgeInsets.all(
          //8.0,
          SizeConfig.heightMultiplier*1.17,
        ),
        titlePadding:EdgeInsets.symmetric(
          horizontal:SizeConfig.widthMultiplier*1.94,
          vertical:SizeConfig.heightMultiplier*1.46,
          // horizontal: 8.0,
          // vertical: 10.0,
        ),
        content: FilterDialog(
          from: _from,
          to: _to,
          onChange: (Map<String, DateTime> data) {
            setState(() {
              _from = data["from"];
              _to = data["to"];
            });
          },
        ),
      ),
    ).then(_onClose);
  }
}

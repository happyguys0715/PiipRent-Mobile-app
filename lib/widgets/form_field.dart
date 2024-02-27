import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/widgets/size_config.dart';

class Field extends StatefulWidget {
  final String? label;
  final Function? onFocus;
  final Function? validator;
  final Function? onSaved;
  final TextInputType type;
  final bool obscureText;
  final dynamic initialValue;
  final bool datepicker;
  final bool readOnly;
  final void Function(String?)? onChanged;
  final Stream? setStream;
  final Widget? leading;

  Field({
    this.label,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.onFocus,
    this.obscureText = false,
    this.type = TextInputType.text,
    this.datepicker = false,
    this.readOnly = false,
    this.onChanged,
    this.setStream,
    this.leading,
  });

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final myController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    _setValue(widget.initialValue);

    if (widget.setStream != null) {
      widget.setStream!.listen((event) {
        _setValue(event);
      });
    }

    super.initState();
  }

  _setValue(dynamic value) {
    if (widget.datepicker&& value != null) {
      setState(() {
        _date = value;
        myController.text = DateFormat('dd/MM/yyyy').format(value);
      });
    } else {
      myController.text = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.leading != null ? widget.leading! : SizedBox(),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(
                //8.0,
                SizeConfig.heightMultiplier*1.17,
            ),
            child: TextFormField(
              controller: myController,
              decoration: InputDecoration(
                labelText:
                    '${widget.label} ${widget.validator == requiredValidator ? '*' : ''}',
                labelStyle: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 2.34,
                ),
                border: UnderlineInputBorder(
                  borderSide:
                      widget.readOnly == true ? BorderSide.none : BorderSide(),
                ),
              ),
              onChanged: widget.onChanged,
              onTap: widget.datepicker
                  ? () {
                      showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            myController.text =
                                DateFormat('dd/MM/yyyy').format(date);
                            _date = date;
                            if (widget.onChanged != null) {
                              widget.onChanged!(date.toLocal().toString());
                            }
                          });
                        }
                      });
                    }
                  : widget.onFocus as void Function()?,
              validator: widget.validator as String? Function(String?)?,
              obscureText: widget.obscureText,
              keyboardType: widget.type,
              onSaved: widget.onSaved as void Function(String?)?,
              readOnly: widget.datepicker || widget.readOnly,
              style: TextStyle(
                color: widget.datepicker || widget.readOnly
                    ? Colors.grey[600]
                    : Colors.black,
                fontSize: SizeConfig.textMultiplier * 2.34,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    myController.dispose();
    super.dispose();
  }
}

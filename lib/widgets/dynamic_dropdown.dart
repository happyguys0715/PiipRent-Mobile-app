import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

import 'form_field.dart';

class DynamicDropdown extends StatefulWidget {
  final String? label;
  final Function? future;
  final Function? onChange;

  DynamicDropdown({this.label, this.future, this.onChange});

  @override
  _DynamicDropdownState createState() => _DynamicDropdownState();
}

class _DynamicDropdownState extends State<DynamicDropdown> {
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Field(
            label: widget.label,
            onFocus: () {
              setState(() {
                _isOpen = true;
              });
            }, initialValue: null, validator: null, onSaved: null, onChanged: null, setStream: null, leading: null,
          ),
          _isOpen
              ? Container(
                  //height: 200,
                  height:SizeConfig.heightMultiplier*29.28,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius:SizeConfig.heightMultiplier*0.44,
                          blurRadius:SizeConfig.heightMultiplier*0.73,
                          // spreadRadius: 3,
                          // blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                        //8.0,
                        SizeConfig.heightMultiplier*1.17,
                      ),
                      border: Border.all(
                          width: 1,
                          color: (Colors.grey[700])!,
                          style: BorderStyle.solid)),
                  child: FutureBuilder(
                    future: widget.future!(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> data = snapshot.data;

                        return ListView(
                          shrinkWrap: true,
                          children: data
                              .map(
                                (data) => ListTile(
                                  title: Text(data.name,style: TextStyle(
                                    fontSize: SizeConfig.heightMultiplier*2.34,
                                  ),),
                                  onTap: () => widget.onChange!(data.id),
                                ),
                              )
                              .toList(),
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

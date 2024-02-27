import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/widgets/size_config.dart';

class AsyncDropdown<T> extends StatefulWidget {
  const AsyncDropdown({
    Key? key,
    this.label,
    this.future,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.multiple,
    this.items,
    required this.renderFn,
    required this.compareFn,
  }) : super(key: key);

  final String? label;
  final Function? future;
  final Function? onChanged;
  final String? Function(T?)? validator;
  final Function? onSaved;
  final bool? multiple;
  final List<T>? items;
  final String Function(T) renderFn;
  final bool Function(T, T) compareFn;

  @override
  _AsyncDropdownState<T> createState() => _AsyncDropdownState<T>();
}

class _AsyncDropdownState<T> extends State<AsyncDropdown> {
  Future<List> _fetchOptions(String query) async {
    try {
      List list = await widget.future!({'search': query});

      if (list.isEmpty) {
        return [];
      }

      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget? _multipleDropDown() {
    // return DropdownSearch<T>.multiSelection(
    //   label:
    //       '${widget.label} ${widget.validator == requiredValidator ? '*' : ''}',
    //   validator: widget.validator,
    //   isFilteredOnline: true,
    //   mode: Mode.DIALOG,
    //   onFind: widget.future != null
    //       ? (text) async {
    //           return await _fetchOptions(text);
    //         }
    //       : null,
    //   itemAsString: widget.renderFn,
    //   onChanged: (List<T> value) {
    //     if (widget.onChanged != null) {
    //       widget.onChanged(value);
    //     }
    //   },
    //   onSaved: (List<T?>? value) {
    //     if (widget.onSaved != null) {
    //       widget.onSaved(value);
    //     }
    //   },
    //   // searchDelay: Duration(milliseconds: 800),
    //   // showSearchBox: widget.items == null,
    //   items: widget.items as List<T>,
    //   dropDownButton: Icon(
    //     Icons.expand_more,
    //     color: Colors.grey,
    //   ),
    //   dropdownSearchDecoration: InputDecoration(
    //     contentPadding: EdgeInsets.all(0.0),
    //     border: UnderlineInputBorder(
    //       borderSide: BorderSide(),
    //     ),
    //   ),
    //   searchFieldProps: TextFieldProps(
    //     decoration: InputDecoration(
    //       border: UnderlineInputBorder(
    //         borderSide: BorderSide(),
    //       ),
    //     ),
    //   ),
    //   compareFn: widget.compareFn,
    //   showSelectedItems: widget.compareFn != null,
    // );
    return null;
  }

  Widget? _singleValueDropdown() {
    // return DropdownSearch<T>(
    //   label:
    //       '${widget.label} ${widget.validator == requiredValidator ? '*' : ''}',
    //   validator: widget.validator,
    //   isFilteredOnline: true,
    //   mode: Mode.DIALOG,
    //   onFind: (text) async {
    //     return await _fetchOptions(text);
    //   },
    //   itemAsString: widget.renderFn,
    //   onChanged: (T? instance) {
    //     if (widget.onChanged != null) {
    //       widget.onChanged(instance);
    //     }
    //   },
    //   onSaved: (T? instance) {
    //     if (widget.onSaved != null) {
    //       widget.onSaved(instance);
    //     }
    //   },
    //   searchDelay: Duration(milliseconds: 800),
    //   showSearchBox: widget.items == null,
    //   items: widget.items as List<T>,
    //   dropDownButton: Icon(
    //     Icons.expand_more,
    //     color: Colors.grey,
    //   ),
    //   dropdownSearchDecoration: InputDecoration(
    //     contentPadding: EdgeInsets.all(0.0),
    //     border: UnderlineInputBorder(
    //       borderSide: BorderSide(),
    //     ),
    //   ),
    //   searchFieldProps: TextFieldProps(
    //     decoration: InputDecoration(
    //       border: UnderlineInputBorder(
    //         borderSide: BorderSide(),
    //       ),
    //     ),
    //   ),
    //   compareFn: widget.compareFn,
    //   showSelectedItems: widget.compareFn != null,
    // );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        //8.0,
        SizeConfig.heightMultiplier*1.17,
      ),
      child: widget.multiple == true
          ? _multipleDropDown()
          : _singleValueDropdown(),
    );
  }
}

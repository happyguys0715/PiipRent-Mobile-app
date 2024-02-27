import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/job_model.dart';
import 'package:piiprent/models/shift_model.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/client_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class ClientJobDetailsScreen extends StatefulWidget {
  final String? position;
  final String? jobsite;
  final DateTime? workStartDate;
  final String? notes;
  final List<dynamic>? tags;
  final String? id;
  final String? contact;
  final String? company;

  ClientJobDetailsScreen({
    this.position,
    this.jobsite,
    this.workStartDate,
    this.notes,
    this.tags,
    this.id,
    this.contact,
    this.company,
  });

  @override
  _ClientJobDetailsScreenState createState() => _ClientJobDetailsScreenState();
}

class _ClientJobDetailsScreenState extends State<ClientJobDetailsScreen> {
  String _from = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: 7)));
  String? _to;

  bool show_shift = false;

Widget _buildTableCell(String text, [Color color = Colors.black, bool centerText = false, VoidCallback? onTap]) {
  final cellContent = Text(
    text,
    textAlign: centerText ? TextAlign.center : TextAlign.left,
    style: TextStyle(
      color: color,
      fontSize: SizeConfig.heightMultiplier * 2.34,
    ),
  );

  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: SizeConfig.heightMultiplier * 1.17,
      horizontal: SizeConfig.widthMultiplier * 0.97,
    ),
    child: onTap != null
        ? InkWell(
            onTap: onTap,
            child: Center(child: cellContent),
          )
        : Center(child: cellContent),
  );
}

  Widget _buildTable(List<Shift> data) {
    return Column(
      children: [
        show_shift == false ?
        (MaterialButton(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 7,
            vertical: SizeConfig.heightMultiplier * 1.46,
            // horizontal: 60,
            // vertical: 10,
          ),
          
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(20),
            borderRadius: BorderRadius.circular(
                SizeConfig.heightMultiplier * 2.92),
          ),
          onPressed: () {
            setState(() {
              show_shift = true;
            });
          },
          child: Text(
            translate('table.shifts'),
            style: TextStyle(
                //fontSize: 16,
                fontSize: SizeConfig.heightMultiplier * 2.34),
          ),
        )) :
        (Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Colors.grey,
            ),
          ),
          children: data.length > 0
              ? data.asMap().entries.map((e) {
                  int i = e.key;
                  Shift shift = e.value;

                  if (i == 0) {
                    return TableRow(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      children: [
                        _buildTableCell('Date', Colors.black, true),
                        _buildTableCell('Employees', Colors.black, true),
                        _buildTableCell('Candidate', Colors.black, true),
                        _buildTableCell('Timesheet', Colors.black, true),
                      ],
                    );
                  }

                  return TableRow(
                    children: [
                      _buildTableCell(DateFormat('dd/MM/yyyy').format(shift.datetime!), Colors.black, true),
                      _buildTableCell(shift.workers.toString(), Colors.black, true),
                      _buildTableCell(
                        shift.isFulfilled! ? 'Fulfilled' : 'Unfulfilled',
                        shift.isFulfilled! ? (Colors.green[400])! : (Colors.red[400])!,
                        true
                      ),
                      _buildTableCell( shift.isFulfilled! ? 'Link' : '', Colors.blue, true, shift.isFulfilled! ? () => Navigator.pushNamed(context, '/client_timesheets') : null,), 
                    ],
                  );
                }).toList()
              : [
                  TableRow(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Center(
                          child: Text(
                            translate('message.no_data'),
                            style: TextStyle(
                              fontSize: SizeConfig.heightMultiplier * 2.34,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    JobService jobService = Provider.of<JobService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);
    return DefaultTabController(
      length: 0,
      child: Scaffold(
        appBar: getClientAppBar(translate('page.title.job'), context, tabs: [], 
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color:Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: SizeConfig.heightMultiplier * 5.27,
              ),
              onPressed: () {
                Get.back();
              },
            );
          },
        )),

        // Filter button on the bottom-right corner. Not needed but if there are demands of users wanting to use filter, uncomment the below code
        // floatingActionButton: FilterDialogButton(
        //   from: _from,
        //   onClose: (data) {
        //     setState(() {
        //       _from = data['from'] as String;
        //       _to = data['to'] as String;
        //     });
        //   },
        // ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              //10.0,
              SizeConfig.heightMultiplier * 1.46,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  //height: 25.0,
                  height: SizeConfig.heightMultiplier * 3.66,
                ),
                Text(
                  widget.company!,
                  style: TextStyle(
                    //fontSize: 22.0,
                    fontSize: SizeConfig.heightMultiplier * 3.22,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Text(
                //   widget.jobsite!,
                //   style: TextStyle(
                //     //fontSize: 18.0,
                //     fontSize: SizeConfig.heightMultiplier * 2.64,
                //     color: Colors.grey[500],
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(
                  //height: 15.0,
                  height: SizeConfig.heightMultiplier * 2.34,
                ),
                GroupTitle(title: translate('group.title.tags')),
                widget.tags!.length > 0
                    ? Text(widget.tags!
                        .reduce((value, element) => '$value, $element'))
                    : SizedBox(),
                GroupTitle(title: translate('group.title.job_information')),
                SizedBox(
                  //height: 15.0,
                  height: SizeConfig.heightMultiplier * 2.34,
                ),
                DetailsRecord(
                    label: translate('field.jobsite'),
                    value: widget.jobsite!, button: null,),
                DetailsRecord(
                  label: translate('field.job_position'),
                  value: widget.position!, button: null,),
                DetailsRecord(
                  label: translate('field.site_supervisor'),
                  value: widget.contact!, button: null,), 
                DetailsRecord(
                  label: translate('field.shift_starting_time'),
                  value: DateFormat.jm().format(widget.workStartDate!), button: null,
                ),
                DetailsRecord(
                  label: translate('field.shift_date'),
                  value: DateFormat('dd/MM/yyyy').format(widget.workStartDate!), button: null,
                ),
                DetailsRecord(
                    label: translate('field.note'), value: widget.notes!, button: null,),
                SizedBox(
                  //height: 15.0,
                  height: SizeConfig.heightMultiplier * 2.34,
                ),
                GroupTitle(title: translate('group.title.shift_information')),
                FutureBuilder(
                  future: jobService.getShifts({
                    'job': widget.id,
                    // 'client_contact': loginService.user!.id,
                    'ordering': '-date.shift_date,-time',
                    // 'date__shift_date_0': _from,
                    // 'date__shift_date_1': _to
                  }),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          translate('message.has_error'),
                          style: TextStyle(
                            fontSize: SizeConfig.heightMultiplier * 2.34,
                          ),
                        ),
                      );
                    }

                    return _buildTable(snapshot.data['list']);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

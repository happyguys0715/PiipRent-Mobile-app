import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/jobsite_model.dart';
import 'package:piiprent/widgets/client_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/group_title.dart';

import '../widgets/size_config.dart';

class ClientJobsiteDetailsScreen extends StatefulWidget {
  final Jobsite? jobsite;

  ClientJobsiteDetailsScreen({
    this.jobsite,
  });

  @override
  _ClientJobsiteDetailsScreenState createState() =>
      _ClientJobsiteDetailsScreenState();
}

class _ClientJobsiteDetailsScreenState
    extends State<ClientJobsiteDetailsScreen> {
 // GoogleMapController _mapController;
  Completer<GoogleMapController> _mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  int _id = 1;
  var isMapVisible = true;

  void _add(double latitude, double longitude) {
    final MarkerId markerId = MarkerId(_id.toString());

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        latitude,
        longitude,
      ),
    );

    setState(() {
      markers[markerId] = marker;
      _id = _id + 1;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
   setState(() {
     _mapController.complete(controller);
   });
  }

  @override
  void initState() {
    super.initState();
    _add(
      widget.jobsite!.latitude!,
      widget.jobsite!.longitude!,
    );
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
    BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isMapVisible = !isMapVisible;
        });
        return true;
      },
      child: Scaffold(
        appBar: getClientAppBar(
          translate('page.title.jobsite'),
          context,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                color:Colors.white,
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  //size: 36.0,
                  size:SizeConfig.heightMultiplier*3.27,
                ),
                onPressed: () {
                  setState(() {
                    isMapVisible = !isMapVisible;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ), tabs: [],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
                //16.0,
                SizeConfig.heightMultiplier*2.34
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  //height: 25.0,
                  height:SizeConfig.heightMultiplier*3.66,
                ),
                Text(
                  widget.jobsite!.name!,
                  style: TextStyle(
                    //fontSize: 22.0,
                    fontSize:SizeConfig.heightMultiplier*3.22,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Text(
                //   widget.jobsite!.company!,
                //   style: TextStyle(
                //     //fontSize: 18.0,
                //     fontSize:SizeConfig.heightMultiplier*2.64,
                //     color: Colors.grey[500],
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(
                  //height: 15.0,
                  height:SizeConfig.heightMultiplier*2.34,
                ),
                // TODO: Add tags
                // GroupTitle(title: 'Tags'),
                // GroupTitle(
                //   title: translate('group.title.primary_contact'),
                // ),
                // SizedBox(
                //   //height: 15.0,
                //   height:SizeConfig.heightMultiplier*2.34,
                // ),
                // DetailsRecord(
                //   label: translate('field.name'),
                //   value: widget.jobsite!.primaryContact!.str!, button: null,
                // ),
                // DetailsRecord(
                //   label: translate('field.job_title'),
                //   value: widget.jobsite!.primaryContactJobTitle!, button: null,
                // ),
                // DetailsRecord(
                //   label: translate('field.phone'),
                //   value: widget.jobsite!.primaryContact!.phoneMobile!, button: null,
                // ),
                // SizedBox(
                //   //height: 15.0,
                //   height:SizeConfig.heightMultiplier*2.34,
                // ),
                GroupTitle(
                  title: translate('group.title.jobsite_information'),
                ),
                // SizedBox(
                //   //height: 15.0,
                //   height:SizeConfig.heightMultiplier*1,
                // ),
                DetailsRecord(
                  label: translate('field.jobsite'),
                  value: widget.jobsite!.address!, button: null,
                ),
                DetailsRecord(
                  label: translate('field.industry'),
                  value: widget.jobsite!.industry, button: null,
                ),
                DetailsRecord(
                  label: translate('field.start_date'),
                  value: widget.jobsite!.startDate != null
                      ? DateFormat('dd/MM/yyyy').format(widget.jobsite!.startDate!)
                      : '', button: null,
                ),
                DetailsRecord(
                  label: translate('field.end_date'),
                  value: widget.jobsite!.endDate != null
                      ? DateFormat('dd/MM/yyyy').format(widget.jobsite!.endDate!)
                      : '', button: null,
                ),
                DetailsRecord(
                  label: translate('field.note'),
                  value: widget.jobsite!.notes!, button: null,
                ),
                // SizedBox(
                //   //height: 15.0,
                //   height:SizeConfig.heightMultiplier*1,
                // ),
                GroupTitle(
                  title: translate('group.title.portfolio_manager'),
                ),
                // SizedBox(
                //   //height: 15.0,
                //   height:SizeConfig.heightMultiplier*2.34,
                // ),
                DetailsRecord(
                  label: translate('field.name'),
                  value: widget.jobsite!.portfolioManager!.str!, button: null,
                ),
                DetailsRecord(
                  label: translate('field.job_title'),
                  value: widget.jobsite!.portfolioManagerJobTitle!, button: null,
                ),
                DetailsRecord(
                  label: translate('field.phone'),
                  value: widget.jobsite!.portfolioManager!.phoneMobile!, button: null,
                ),
                SizedBox(
                  //height: 15.0,
                  height:SizeConfig.heightMultiplier*2.34,
                ),
                GroupTitle(
                  title: translate('group.title.map'),
                ),
                SizedBox(
                  //height: 15.0,
                  height:SizeConfig.heightMultiplier*2.34,
                ),
                Visibility(
                  visible: isMapVisible,
                  child: SizedBox(
                  // height: 350.0,
                  // width: 20.0,
                    height:SizeConfig.heightMultiplier*51.24,
                    width:SizeConfig.widthMultiplier*4.87,
                    child: GoogleMap(
                      cameraTargetBounds: CameraTargetBounds.unbounded,
                      indoorViewEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.jobsite!.latitude!,
                          widget.jobsite!.longitude!,
                        ),
                        zoom: 10.0,
                      ),
                      markers: Set<Marker>.of(markers.values),
                    ),
                  ),
                ),
                SizedBox(
                  //height: 15.0,
                  height:SizeConfig.heightMultiplier*4.34,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

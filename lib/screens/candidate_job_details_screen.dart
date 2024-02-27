import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/details_record.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:get/get.dart';
import '../widgets/size_config.dart';


class CandidateJobDetailsScreen extends StatefulWidget {
  final JobOffer? jobOffer;

  CandidateJobDetailsScreen({
    this.jobOffer,
  });

  @override
  _CandidateJobDetailsScreenState createState() =>
      _CandidateJobDetailsScreenState();
}

class _CandidateJobDetailsScreenState extends State<CandidateJobDetailsScreen> {
  //GoogleMapController _mapController;
  Completer<GoogleMapController> _mapController = Completer();
  Location _location = Location();
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
    _mapController.complete(controller);
    // debugPrint(widget.jobOffer.latitude + widget.jobOffer.longitude);
  }

  LocationData? _currentPosition;
  String? _address;
  Location location = new Location();
  fetchLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      // setState(() {
      //   _currentPosition = currentLocation;
      //   getAddress(_currentPosition.latitude, _currentPosition.longitude)
      //       .then((value) {
      //     setState(() {
      //       _address = "${value.first.addressLine}";
      //     });
      //   });
      // });
    });
  }
  @override
  void initState() {
    super.initState();
    _add(
      double.parse(widget.jobOffer!.latitude!),
      double.parse(widget.jobOffer!.longitude!),
    );
    fetchLocation();
  }

  void showConcernDialog(Function allowed) {
    showProminentDisclosureDialog(context, (bool isAllowed) {
      if (isAllowed == true) {
        allowed();
      } else if (isAllowed == false) {
        showDenyAlertDialog(context, (bool isAllowed) {
          if (isAllowed == true) {
            showConcernDialog(allowed);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isMapVisible = !isMapVisible;
        });
        return true;
      },
      child: Scaffold(
        appBar: getCandidateAppBar(translate('page.title.job'), context, tabs: [],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color:Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: SizeConfig.heightMultiplier * 5.27,
              ),
              onPressed: () {
                setState(() {
                  isMapVisible = !isMapVisible;
                });
                Get.back();
              },
            );
          },
        )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              //16.0,
              SizeConfig.heightMultiplier * 2.34,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  //height: 25.0,
                  height: SizeConfig.heightMultiplier * 3.66,
                ),
                Text(
                  widget.jobOffer?.position,
                  style: TextStyle(
                    //fontSize: 22.0,
                    fontSize: SizeConfig.heightMultiplier * 3.22,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.jobOffer!.company!,
                  style: TextStyle(
                    //fontSize: 18.0,
                    fontSize: SizeConfig.heightMultiplier * 2.64,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  //height: 15.0,
                  height: SizeConfig.heightMultiplier * 2.34,
                ),
                // TODO: Add tags
                // GroupTitle(title: 'Tags'),
                GroupTitle(title: translate('group.title.job_information')),
                SizedBox(
                  //height: 15.0,
                  height: SizeConfig.heightMultiplier * 2.34,
                ),
                DetailsRecord(
                  label: translate('field.site_supervisor'),
                  value: widget.jobOffer!.clientContact!, button: null,
                ),
                DetailsRecord(
                  label: translate('field.shift_date'),
                  value:
                      DateFormat('dd/MM/yyyy').format(widget.jobOffer!.datetime!), button: null,
                ),
                DetailsRecord(
                  label: translate('field.shift_starting_time'),
                  value: DateFormat.jm().format(widget.jobOffer!.datetime!), button: null,
                ),
                DetailsRecord(
                  label: translate('field.note'),
                  value: widget.jobOffer!.notes!, button: null,
                ),
                SizedBox(
                  //height: 15.0,
                  height: SizeConfig.heightMultiplier * 2.34,
                ),
                // MaterialButton(
                //   color: Colors.white,
                //   child: Text(translate('button.show')),
                //   onPressed: () async {
                //     showConcernDialog(() async {
                //       try {
                //         LocationData data = await _location.getLocation();
                //
                //         _add(data.latitude, data.longitude);
                //         _mapController.animateCamera(
                //           CameraUpdate.newCameraPosition(
                //             CameraPosition(
                //               target: LatLng(data.latitude, data.longitude),
                //             ),
                //           ),
                //         );
                //       } catch (e) {
                //         print(e);
                //       }
                //     });
                //   },
                // ),
                // ShowDirections(),
                MaterialButton(
                  color: Colors.white,
                  child: Text(
                    translate('button.direct_me'),
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  onPressed: () async {
                    final availableMaps = await MapLauncher.installedMaps;
                    print("availableMaps : $availableMaps");

                    // await availableMaps.first.showMarker(
                    //   coords: Coords(double.parse(widget.jobOffer.latitude),
                    //       double.parse(widget.jobOffer.longitude)),
                    //   title: widget.jobOffer.company,
                    // );
                    for (var map in availableMaps){
                      map.showDirections(
                        destination: Coords(
                          double.parse(widget.jobOffer!.latitude!),
                          double.parse(widget.jobOffer!.longitude!),
                        ),
                        destinationTitle: widget.jobOffer?.company,
                        origin: Coords(58.369911000000000, 26.783764000000000),
                        // origin: Coords(_currentPosition.latitude, _currentPosition.longitude),
                        // originTitle: originTitle,
                        // waypoints: waypoints,
                        directionsMode: DirectionsMode.driving,
                      );
                    }
                  },
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
                          double.parse(widget.jobOffer!.latitude!),
                          double.parse(widget.jobOffer!.longitude!),
                        ),
                        zoom: 10.0,
                      ),
                      markers: Set<Marker>.of(markers.values),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

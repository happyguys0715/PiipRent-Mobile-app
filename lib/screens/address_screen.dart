import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_place/google_place.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/widgets/form_field.dart';

import '../widgets/size_config.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen();

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    // googlePlace = GooglePlace(googleApiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        ),
        title: Text(
          translate('page.title.address'),
          style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Field(
                label: '',
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    autoCompleteSearch(value);
                  } else {
                    if (predictions.length > 0 && mounted) {
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                }, initialValue: '', validator: null, onSaved: null, setStream: null, onFocus: null, leading: null,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                          size: SizeConfig.heightMultiplier*3.66,
                        ),
                      ),
                      title: Text(predictions[index].description!,style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier*2.34,
                      ),),
                      onTap: () async {
                        var address = predictions[index];
                        this.googlePlace!.details.getJson(address.placeId!).then(
                          (value) {
                            final decodedResponse = json.decode(value!);
                            final Map<String, dynamic> address =
                                decodedResponse['result'];

                            final Map<String, dynamic> address0 = address;
                            address0['geometry']['viewport'] = {
                              "south": address['geometry']['viewport']
                                  ['southwest']['lat'],
                              "west": address['geometry']['viewport']
                                  ['southwest']['lng'],
                              "north": address['geometry']['viewport']
                                  ['northeast']['lat'],
                              "east": address['geometry']['viewport']
                                  ['northeast']['lng']
                            };
                            final String streetAddress =
                                address['formatted_address'];

                            Navigator.pop(context, {
                              'streetAddress': streetAddress,
                              'address': address0,
                            });
                          },
                        ).catchError(
                          (onError) => print(onError),
                        );
                      },
                    );
                  },
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(top: 10, bottom: 10),
              //   child: Image.asset("assets/powered_by_google.png"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    googlePlace = GooglePlace(googleApiKey);
    var result = await googlePlace!.autocomplete.get(
      value,
    );

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}

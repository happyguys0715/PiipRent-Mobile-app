import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/models/candidate_model.dart';
import 'package:piiprent/models/candidate_skill_model.dart';
import 'package:piiprent/screens/change_password_screen.dart';
import 'package:piiprent/screens/widgets/network_image_widgets.dart';
import 'package:piiprent/services/candidate_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/profile_group.dart';
import 'package:piiprent/widgets/score_badge.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class CandidateProfileScreen extends StatefulWidget {
  const CandidateProfileScreen({Key? key}) : super(key: key);

  @override
  _CandidateProfileScreenState createState() => _CandidateProfileScreenState();
}

class _CandidateProfileScreenState extends State<CandidateProfileScreen> {
  int? _height;
  int? _weight;
  String? _firstName;
  String? _address;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  bool _fetching = false;
  dynamic _formError;
  Map<String, bool> _editMap = {
    'details': false,
    'skills': false,
    'contact': false,
  };
  final GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _contactFormKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  String imageUrl = '';

  _onTapImage(
    CandidateService candidateService,
    Candidate candidate,
    BuildContext context,
  ) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File imageFile = File(image!.path);
    if (image != null) {
      var bytes = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        minWidth: 150,
        minHeight: 150,
        quality: 40,
        rotate: 0,
      );
      print('original file size: ${imageFile.lengthSync()}');
      print('compressed file size: ${bytes!.length}');
      // final bytes = await image.readAsBytes();
      final picture = 'data:image/jpeg;base64,${base64.encode(bytes)}';
      final String contactId = candidate.contact!.id!;

      final result = await candidateService.updatePicture(
        contactId: contactId,
        title: candidate.contact?.title ?? '',
        birthday: candidate.contact?.birthday ?? '',
        firstName: _firstName == null ? candidate.firstName as String : _firstName!,
        lastName: _lastName == null ? candidate.lastName as String : _lastName!,
        email: _email == null ? candidate.email as String : _email!,
        phoneMobile: _phoneNumber == null ? candidate.phone as String : _phoneNumber!,
        picture: picture,
      );

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Avatar updated',
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
          ),
        );

        setState(() {
          _imageBytes = bytes;
        });
      }
    }
  }

  _onSavePersonalDetails(
    CandidateService candidateService,
    Candidate candidate,
  ) async {
    String id = candidate.id!;
    String contactId = candidate.contact!.id!;

    if (!_detailsFormKey.currentState!.validate() ||
        !_contactFormKey.currentState!.validate()) {
      return;
    }

    _detailsFormKey.currentState!.save();
    _contactFormKey.currentState!.save();

    setState(() {
      _fetching = true;
      _formError = null;
    });

    try {
      Object result = await candidateService.updatePersonalDetails(
        id: id,
        contactId: contactId,
        address: _address == null ? candidate.address as String : _address!,
        height: _height == null ? candidate.height as int : _height!,
        weight: _weight == null ? candidate.weight as int: _weight!,
        firstName: _firstName == null ? candidate.firstName as String : _firstName!,
        lastName: _lastName == null ? candidate.lastName as String : _lastName!,
        email: _email == null ? candidate.email as String : _email!,
        phoneMobile: _phoneNumber == null ? candidate.phone as String : _phoneNumber!,
      );

      if (result != null) {
        setState(() {
          _editMap['details'] = false;
          _editMap['contact'] = false;
        });
      }
    } catch (e) {
      setState(() {
        _formError = e;
      });
    } finally {
      setState(() {
        _fetching = false;
      });
    }
  }

  Widget _listItem({required Widget child}) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        // 16.0,
        // 4.0,
        // 16.0,
        // 4.0,
        SizeConfig.widthMultiplier * 3.89,
        SizeConfig.heightMultiplier * 0.58,
        SizeConfig.widthMultiplier * 3.89,
        SizeConfig.heightMultiplier * 0.58,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: (Colors.grey[700])!,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 1.95,
        vertical: SizeConfig.heightMultiplier * 1.17,
        // horizontal: 8.0,
        // vertical: 8.0,
      ),
      child: child,
    );
  }

  Widget _buildPersonalDetails(
    Candidate candidate, [
    bool edit = false,
    final void Function()? onEdit,
  ]) {
    CandidateService candidateService = Provider.of<CandidateService>(context);

    return ProfileGroup(
      title: translate('group.title.personal_details'),
      content: [
        Row(
          children: [
            Expanded(
              child: Field(
                label: translate('field.first_name'),
                initialValue: candidate.firstName,
                readOnly: !edit,
                onChanged: (String? value) {
                  setState(() {
                    _firstName = value;
                  });
                }, validator: null, onSaved: null, onFocus: null, setStream: null, leading: null,
              ),
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 1.95,
              //width: 8.0,
            ),
            Expanded(
              child: Field(
                label: translate('field.last_name'),
                initialValue: candidate.lastName,
                readOnly: !edit,
                onChanged: (String? value) {
                  setState(() {
                    _lastName = value;
                  });
                }, validator: null, onSaved: null, onFocus: null, setStream: null, leading: null,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: '${translate('field.height')} (cm)',
                type: TextInputType.number,
                initialValue: candidate.height.toString(),
                readOnly: !edit,
                validator: numberValidator,
                onChanged: (String? value) {
                  setState(() {
                    _height = int.parse(value!);
                  });
                }, onSaved: null, onFocus: null, setStream: null, leading: null,
              ),
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 1.95,
              //width: 8.0,
            ),
            Expanded(
              child: Field(
                label: '${translate('field.weight')} (kg)',
                initialValue: candidate.weight.toString(),
                readOnly: !edit,
                validator: numberValidator,
                onChanged: (String? value) {
                  setState(() {
                    _weight = int.parse(value!);
                  });
                }, onSaved: null, onFocus: null, setStream: null, leading: null,
              ),
            ),
          ],
        ),
        // Container(
        //   child: Field(
        //     label: translate('field.bmi'),
        //     initialValue: candidate.bmi,
        //     readOnly: true,
        //   ),
        // ),
        Container(
          child: Field(
            label: translate('field.birthday'),
            initialValue: DateFormat('dd/MM/yyyy').format(candidate.birthday!),
            readOnly: true, validator: null, onSaved: null, onFocus: null, onChanged: null, setStream: null, leading: null,
          ),
        ),
        edit
            ? FormSubmitButton(
                disabled: _fetching,
                onPressed: () => _onSavePersonalDetails(
                  candidateService,
                  candidate,
                ),
                label: translate('button.update'),
              )
            : FormSubmitButton(
                disabled: _fetching,
                onPressed: onEdit!,
                label: translate('button.edit'),
              ),
      ], onEdit: null,
    );
  }

  Widget _buildContactDetails(
    Candidate candidate, [
    bool edit = false,
    final void Function()? onEdit,
  ]) {
    CandidateService candidateService = Provider.of<CandidateService>(context);

    return ProfileGroup(
      title: translate('group.title.contact_details'),
      content: [
        Container(
          child: Field(
            label: translate('field.email'),
            initialValue: candidate.email,
            readOnly: !edit,
            onChanged: (String? value) {
              setState(() {
                _email = value;
              });
            }, validator: null, onSaved: null, onFocus: null, setStream: null, leading: null,
          ),
        ),
        Container(
          child: Field(
            label: translate('field.phone'),
            initialValue: candidate.phone,
            readOnly: !edit,
            onChanged: (String? value) {
              setState(() {
                _phoneNumber = value;
              });
            }, validator: null, onSaved: null, onFocus: null, setStream: null, leading: null,
          ),
        ),
        Container(
          child: Field(
            label: translate('field.address'),
            initialValue: candidate.address,
            readOnly: !edit,
            onChanged: (String? v) {
              _address = v;
            }, validator: null, onSaved: null, onFocus: null, setStream: null, leading: null,
          ),
        ),
        edit
            ? FormSubmitButton(
                disabled: _fetching,
                onPressed: () => _onSavePersonalDetails(
                  candidateService,
                  candidate,
                ),
                label: translate('button.update'),
              )
            : FormSubmitButton(
                disabled: _fetching,
                onPressed: onEdit!,
                label: translate('button.edit'),
              ),
      ], onEdit: null,
    );
  }

  Widget _buildSkills(List<CandidateSkill> skills) {
    return ProfileGroup(
      title: translate('group.title.skills'),
      onEdit: () {},
      canEdit: false,
      content: skills
          .map(
            (e) => _listItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.skill!.name!,
                    style:
                        TextStyle(fontSize: SizeConfig.heightMultiplier * 2.14),
                  ),
                  ScoreBadge(score: e.score),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // Widget _buildScore(AverageScores averageScores) {
  //   return ProfileGroup(
  //     title: translate('group.title.score'),
  //     content: [
  //       _listItem(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(translate('skill.average_test')),
  //             Stars(
  //               active: averageScores.recruitmentScore,
  //             )
  //           ],
  //         ),
  //       ),
  //       _listItem(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(translate('skill.client_feedback')),
  //             Stars(
  //               active: averageScores.clientFeedback,
  //             )
  //           ],
  //         ),
  //       ),
  //       _listItem(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(translate('skill.reliability')),
  //             Stars(
  //               active: averageScores.reliability,
  //             )
  //           ],
  //         ),
  //       ),
  //       _listItem(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(translate('skill.loyality')),
  //             Stars(
  //               active: averageScores.loyality,
  //             )
  //           ],
  //         ),
  //       ),
  //       _listItem(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(translate('skill.avarage_skill')),
  //             Stars(
  //               active: averageScores.skillScore,
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildResidency(Candidate candidate) {
    return ProfileGroup(
      title: translate('group.title.residency'),
      content: [
        Row(
          children: [
            Expanded(
              child: Field(
                label: translate('field.residency_status'),
                initialValue: candidate.residency != null
                    ? Residency[candidate.residency]
                    : '',
                readOnly: true, validator: null, onSaved: null, onFocus: null, onChanged: null, setStream: null, leading: null,
              ),
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 1.95,
              //width: 8.0,
            ),
            Expanded(
              child: Field(
                label: translate('field.nationality'),
                initialValue: candidate.nationality,
                readOnly: true, validator: null, onSaved: null, onChanged: null, onFocus: null, setStream: null, leading: null,
              ),
            ),
          ],
        ),
        candidate.residency == 3
            ? Row(
                children: [
                  Expanded(
                    child: Field(
                      label: translate('field.visa_type'),
                      initialValue: candidate.visaType,
                      readOnly: true, validator: null, onSaved: null, onFocus: null, onChanged: null, setStream: null, leading: null,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 1.95,
                    //width: 8.0,
                  ),
                  Expanded(
                    child: Field(
                      label: translate('field.visa_expire_date'),
                      initialValue: candidate.visaExpiryDate != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(candidate.visaExpiryDate!)
                          : '',
                      readOnly: true, validator: null, onSaved: null, onFocus: null, onChanged: null, setStream: null, leading: null,
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ], onEdit: null,
    );
  }

  // Widget _buildTags(List<CandidateTag> tags) {
  //   return ProfileGroup(
  //     title: translate('group.title.tags'),
  //     content: tags
  //         .map(
  //           (e) => _listItem(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(e.tag.name),
  //               ],
  //             ),
  //           ),
  //         )
  //         .toList(),
  //   );
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CandidateService candidateService = Provider.of<CandidateService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(
          builder: (context, constraints) {
            SizeConfig().init(constraints, orientation);

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar:
                    getCandidateAppBar(translate('page.title.profile'), context, tabs: [],
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
                    ),),
                body: FutureBuilder(
                  future: candidateService
                      .getCandidate(loginService.user!.candidateId!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    Candidate candidate = snapshot.data as Candidate;
                    imageUrl = candidate.contact?.userAvatarUrl() as String;
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left:SizeConfig.widthMultiplier*3.89,
                            right:SizeConfig.widthMultiplier*3.89,
                            // left: 15.0,
                            // right: 15.0,
                          ),
                          child: orientation == Orientation.landscape
                              ? size.width > 900
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.heightMultiplier * 0.12,
                                      ),
                                      child: _landscapeView(
                                        candidateService,
                                        candidate,
                                        size,
                                      ),
                                    )
                                  : _landscapeView(
                                      candidateService,
                                      candidate,
                                      size,
                                    )
                              : _portraitView(
                                  candidateService,
                                  candidate,
                                  size,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _landscapeView(candidateService, candidate, size) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildProfileImage(
                      context, candidateService, candidate, size),
                  _buildChangePassword(),
                ],
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.widthMultiplier * 1.17,
            //width: 15,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1.06,
                  //height: 20.0,
                ),
                Form(
                  key: _detailsFormKey,
                  child: _buildPersonalDetails(
                    candidate,
                    _editMap['details']!,
                    () {
                      bool isEdit = _editMap['details']!;
                      setState(
                        () {
                          _editMap['details'] = !isEdit;
                          _editMap = _editMap;
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 0.79,
                  //height: 15.0,
                ),
                Form(
                  key: _contactFormKey,
                  child: _buildContactDetails(
                    candidate,
                    _editMap['contact']!,
                    () {
                      bool isEdit = _editMap['contact']!;
                      setState(
                        () {
                          _editMap['contact'] = !isEdit;
                          _editMap = _editMap;
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 0.79,
                  //height: 15.0,
                ),
                _buildSkills(candidate.skills),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 0.79,
                  //height: 15.0,
                ),
                _buildResidency(candidate),
              ],
            ),
          ),
        ],
      );
  _portraitView(candidateService, candidate, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width > 900 ? size.width * 0.1 : 8.0),
      child: Column(
        children: [
          _buildProfileImage(context, candidateService, candidate, size),
          Form(
            key: _detailsFormKey,
            child: _buildPersonalDetails(
              candidate,
              _editMap['details']!,
              () {
                bool isEdit = _editMap['details']!;
                setState(
                  () {
                    _editMap['details'] = !isEdit;
                    _editMap = _editMap;
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 0.79,
            //height: 15.0,
          ),
          Form(
            key: _contactFormKey,
            child: _buildContactDetails(
              candidate,
              _editMap['contact']!,
              () {
                bool isEdit = _editMap['contact']!;
                setState(
                  () {
                    _editMap['contact'] = !isEdit;
                    _editMap = _editMap;
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 0.79,
            //height: 15.0,
          ),
          _buildSkills(candidate.skills),
          SizedBox(
            height: SizeConfig.heightMultiplier * 0.79,
            //height: 15.0,
          ),
          _buildResidency(candidate),
          _buildChangePassword(),
        ],
      ),
    );
  }

  _buildChangePassword() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 2.19,
          //  height: 15.0,
        ),
        MaterialButton(
          //padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 14.59,
              vertical: SizeConfig.heightMultiplier * 1.46),
          color: Colors.blueAccent,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              //borderRadius: BorderRadius.circular(20)
              borderRadius:
                  BorderRadius.circular(SizeConfig.heightMultiplier * 2.92)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangePasswordScreen(),
              ),
            );
          },
          child: FittedBox(
            child: Text(
              translate('button.change_password'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  //fontSize: 16,
                  fontSize: SizeConfig.textMultiplier * 2.34),
            ),
          ),
        ),
      ],
    );
  }
  // _buildSwitchAccount() {
  //   return Column(
  //     children: [
  //       SizedBox(
  //         height: 15.0,
  //       ),
  //       MaterialButton(
  //         padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
  //         color: Colors.blueAccent,
  //         textColor: Colors.white,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         onPressed: () {
  //           showCupertinoModalBottomSheet(context: context, builder:(context){
  //             return Column(
  //               children: [
  //
  //               ],
  //             );
  //           },);
  //         },
  //         child: Text(
  //           'Switch Account', //todo: add translator text
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 16),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  _buildProfileImage(BuildContext context, CandidateService candidateService,
      candidate, Size size) {
    return Column(
      children: [
        SizedBox(
          //height:20,
          height: SizeConfig.heightMultiplier * 2.42,
        ),
        Center(
          child: InkWell(
            onTap: () => _onTapImage(
              candidateService,
              candidate,
              context,
            ),
            child: Container(
              // height: SizeConfig.heightMultiplier * 18.04,
              // width: SizeConfig.widthMultiplier * 27.03,
              height: size.width > 950 && size.height > 450 ? 300 : 150,
              width: size.width > 950 && size.height > 450 ? 300 : 150,
              constraints: BoxConstraints(
                maxWidth: 300,
                maxHeight: 300,
                minWidth: 120,
                minHeight: 120,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(.1),
              ),
              child: imageUrl == null
                  ? Icon(
                      CupertinoIcons.person_fill,
                      size: 90,
                      // size:
                      // SizeConfig.heightMultiplier * 13.17,
                      color: primaryColor,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                          // size.width > 950 && size.height > 450 ? 180 : 60
                          SizeConfig.heightMultiplier * 20.78),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder: (context, val, progress) {
                          return ImageLoadingContainer();
                        },
                        errorWidget: (context, url, error) =>
                            ImageErrorWidget(),
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 1.26,
          //height: 10.0,
        ),
        Text(
          '${candidate.firstName} ${candidate.lastName}',
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: SizeConfig.heightMultiplier * 2.63
              //fontSize: 18.0,
              ),
        ),
        SizedBox(
          //height:20,
          height: SizeConfig.heightMultiplier * 1.42,
        ),
      ],
    );
  }
}

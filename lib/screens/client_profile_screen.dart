import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/models/client_contact_model.dart';
import 'package:piiprent/screens/change_password_screen.dart';
import 'package:piiprent/screens/widgets/network_image_widgets.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/client_app_bar.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/profile_group.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class ClientProfileScreen extends StatelessWidget {
  Widget _buildContactExpandable(ClientContact contact) {
    return ProfileGroup(
      title: translate('group.title.contact_details'),
      onEdit: () {},
      content: [
        Container(
          child: Field(
            label: translate('field.email'),
            initialValue: contact.email,
            readOnly: true, validator: null, onSaved: null, onFocus: null, onChanged: null, setStream: null, leading: null,
          ),
        ),
        Container(
          child: Field(
            label: translate('field.phone'),
            initialValue: contact.phone,
            readOnly: true, validator: null, onSaved: null, onFocus: null, onChanged: null, setStream: null, leading: null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ContactService contactService = Provider.of<ContactService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            Size size = Size(constraints.maxWidth, constraints.maxHeight);
            SizeConfig().init(constraints, orientation);
            return DefaultTabController(
              length: 0,
              child: Scaffold(
                appBar: getClientAppBar(translate('page.title.profile'), context, tabs: [],
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
                  future: contactService
                      .getCompanyContactDetails(loginService.user!.id!),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    ClientContact contact = snapshot.data;

                    return SafeArea(
                      child: size.width > 798 && size.height > 360
                          ? Container(
                              width: size.width,
                              height: size.height,
                              child: Center(
                                child: _buildProfileWidget(
                                    context, size, contact, orientation),
                              ),
                            )
                          : _buildProfileWidget(
                              context, size, contact, orientation),
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

  Widget _buildProfileWidget(
      context, Size size, contact, Orientation orientation) {
    return Container(
      width: size.width,
      constraints: BoxConstraints(maxWidth: 650),
      child: Padding(
        //padding: EdgeInsets.symmetric(horizontal: 15.0),
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 3.65),
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.width < 801) && orientation == Orientation.landscape
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildImageAndContactDetails(
                                  context, contact, size, orientation),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 2.19,
                                //height: 15.0,
                              ),
                              MaterialButton(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.widthMultiplier * 14.60,
                                  vertical: SizeConfig.heightMultiplier * 1.46,
                                  // horizontal: 60,
                                  // vertical: 10,
                                ),
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  //borderRadius: BorderRadius.circular(20),
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.heightMultiplier * 2.92,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangePasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  translate('button.change_password'),
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.heightMultiplier * 2.34,
                                    //fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 2.34,
                                //height: 15.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 3.65,
                          //width: 15,
                        ),
                        Expanded(child: _buildContactExpandable(contact))
                      ],
                    )
                  : Column(
                      children: [
                        _buildImageAndContactDetails(
                            context, contact, size, orientation),
                        _buildContactExpandable(contact),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2.34,
                          //height: 15.0,
                        ),
                        MaterialButton(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 14.60,
                            vertical: SizeConfig.heightMultiplier * 1.46,
                            // horizontal: 60,
                            // vertical: 10,
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            //borderRadius: BorderRadius.circular(20),
                            borderRadius: BorderRadius.circular(
                                SizeConfig.heightMultiplier * 2.92),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            translate('button.change_password'),
                            style: TextStyle(
                                //fontSize: 16,
                                fontSize: SizeConfig.heightMultiplier * 2.34),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 4.34,
                          //height: 15.0,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _buildImageAndContactDetails(
      context, contact, Size size, Orientation orientation) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 2.92,
          //height: 20.0,
        ),
        Center(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  // size.width > 950 && size.height > 450 ? 180 : 60
                  SizeConfig.heightMultiplier * 20.78,),
              child: CachedNetworkImage(
                imageUrl: contact.avatar ?? '',
                fit: BoxFit.fill,
                progressIndicatorBuilder:
                    (context, val, progress) {
                  return ImageLoadingContainer();
                },
                errorWidget: (context, url, error) =>ImageErrorWidget(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 1.46,
          // height: 10.0,
        ),
        Text(
          contact.fullName,
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: SizeConfig.heightMultiplier * 2.64,
            //fontSize: 18.0,
          ),
        ),
        Center(
          child: Text(
            contact.company,
            style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2.34
                //fontSize: 16.0,
                ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 1.46,
          // height: 10.0,
        ),
        Center(
          child: Text(
            contact.jobTitle,
            style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2.34
                //fontSize: 16.0,
                ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 2.34,
          //height: 15.0,
        ),
      ],
    );
  }
}
class ImageContainer1 extends StatelessWidget {
  const ImageContainer1({Key? key, this.content}) : super(key: key);
  final Widget? content;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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

      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 0.2,
        ),
      ),
      child: content,
    );
  }
}
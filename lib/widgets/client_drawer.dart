import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/screens/widgets/network_image_widgets.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

class ClientDrawer extends StatefulWidget {
  final bool dashboard;

  ClientDrawer({this.dashboard = false});

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
  final TextStyle _textStyle = TextStyle(fontSize: 17, color: Colors.blue);
  LoginService? _loginService;
  bool _isLoading = true;
  @override
  void initState() {
    _loginService = Provider.of<LoginService>(context, listen: false);

    if (Provider.of<LoginProvider>(context, listen: false).image == null)
      Provider.of<ContactService>(context, listen: false)
          .getContactPicture(_loginService!.user!.userId!)
          .then((value) {
          print('client image: ==== $value');
          Provider.of<LoginProvider>(context, listen: false).image = value;
          setState(() {});
        });
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);
    ContactService contactService = Provider.of<ContactService>(context);

    return Drawer(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              FutureBuilder(
                future: loginService.user?.userId != null
                  ? contactService.getContactPicture(loginService.user!.userId!)
                  : Future.value(null),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Container(
                    //margin: EdgeInsets.symmetric(vertical: 15),
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier * 2.34),
                    child: Center(
                      child: Consumer<LoginProvider>(
                        builder: (_, login, __) {
                          String name = '';
                          if(loginService.user != null){
                            name = loginService.user!.name!;
                            var nameParts = name.split(' ');
                            if( nameParts.length > 2 ){
                              name = nameParts[0] +' '+ nameParts[1];
                            }
                          }
                          return Column(
                            children: [
                              Container(
                                // height: SizeConfig.heightMultiplier * 15.04,
                                // width: SizeConfig.widthMultiplier * 22.43,
                                height: 120,
                                width: 120,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor.withOpacity(.1),
                                ),
                                child: login.image == ''
                                    ? Icon(
                                        CupertinoIcons.person_fill,
                                        size: 90,
                                        // size:
                                        //     SizeConfig.heightMultiplier * 13.17,
                                        color: primaryColor,
                                      )
                                    : ClipRRect(
                                        //borderRadius: BorderRadius.circular(60),
                                        borderRadius: BorderRadius.circular(
                                          SizeConfig.heightMultiplier *
                                              34.5 /
                                              SizeConfig.widthMultiplier *
                                              40.345,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: login.image ?? '',
                                          fit: BoxFit.fill,
                                          progressIndicatorBuilder:
                                              (context, val, progress) {
                                            return ImageLoadingContainer();
                                          },
                                          errorWidget: (context, url, error) =>
                                              ImageErrorWidget(),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 1.46,
                                //height: 10,
                              ),
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  //fontSize: 14,
                                  fontSize: SizeConfig.heightMultiplier * 2.05,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              !widget.dashboard
                  ? ListTile(
                      title: Text(
                        translate('page.title.dashboard'),
                        style: _textStyle.copyWith(
                          fontSize: SizeConfig.textMultiplier * 2.64,
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(context, '/client_home'),
                    )
                  : SizedBox(),
              !widget.dashboard
                  ? Divider(
                      color: Colors.grey[300],
                    )
                  : SizedBox(),
              ListTile(
                title: Text(
                  translate('page.title.profile'),
                  style: _textStyle.copyWith(
                    fontSize: SizeConfig.textMultiplier * 2.64,
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, '/client_profile'),
              ),
              Divider(
                color: Colors.grey[300],
              ),
              ListTile(
                title: Text(
                  translate('page.title.jobsites'),
                  style: _textStyle.copyWith(
                    fontSize: SizeConfig.textMultiplier * 2.64,
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, '/client_jobsites'),
              ),
              Divider(
                color: Colors.grey[300],
              ),
              ListTile(
                title: Text(
                  translate('page.title.jobs'),
                  style: _textStyle.copyWith(
                    fontSize: SizeConfig.textMultiplier * 2.64,
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, '/client_jobs'),
              ),
              Divider(
                color: Colors.grey[300],
              ),
              ListTile(
                title: Text(
                  translate('page.title.timesheets'),
                  style: _textStyle.copyWith(
                    fontSize: SizeConfig.textMultiplier * 2.64,
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, '/client_timesheets'),
              ),
              Divider(
                color: Colors.grey[300],
              ),
              ListTile(
                title: Text(
                  translate('button.logout'),
                  style: _textStyle.copyWith(
                    fontSize: SizeConfig.textMultiplier * 2.64,
                  ),
                ),
                onTap: () => {
                  loginService.logout(context: context).then(
                        (bool success) => Navigator.pushNamed(context, '/'),
                      ),
                },
              ),
              Divider(
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

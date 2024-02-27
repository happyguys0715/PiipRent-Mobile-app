import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/models/client_contact_model.dart';
import 'package:piiprent/screens/widgets/primary_button.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

class SwitchAccount extends StatefulWidget {
  const SwitchAccount({Key? key}) : super(key: key);

  @override
  State<SwitchAccount> createState() => _SwitchAccountState();
}

class _SwitchAccountState extends State<SwitchAccount> {
  LoginService? loginService;
  LoginProvider? loginProvider;
  ContactService? contactService;
  ClientContact? clientContact;

void init() async {
  final result = await contactService!.getCompanyContactDetails(loginService!.user!.id!);
  if (mounted) {
    setState(() {
      clientContact = result;
    });
  }
}

  @override
  initState() {
    super.initState();
    loginService = Provider.of<LoginService>(context, listen: false);
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    contactService = Provider.of<ContactService>(context, listen: false);
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<Role>? roles = loginService?.user?.roles;
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);

    return PopupMenuButton(
      offset: Offset(MediaQuery.of(context).size.width, 0),
      elevation: 1,
      position: PopupMenuPosition.under,
      constraints: BoxConstraints(minWidth: double.infinity),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(12.0),
      //   ),
      // ),
      itemBuilder: (context) {
        var data = roles!.map((role) {
          return PopupMenuItem(
            value: role.id,
            padding: EdgeInsets.zero,
            child: Container(
              width: Get.width,
              color: (role.active)
                  ? Colors.blue[400]?.withOpacity(0.15)
                  : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 1),
                child: InkWell(
                  onTap: () async {
                    if (!role.active) {
                      role.active = true;
                      int index = roles.indexWhere((element) => element.id == role.id);
                      loginProvider.switchRole = index;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(width: SizeConfig.widthMultiplier * 10),
                      Icon(
                        role.active ? Icons.radio_button_on : Icons.radio_button_off,
                        size: 16,
                        color: role.active ? primaryColor : hintColor,
                      ),
                      SizedBox(width: SizeConfig.widthMultiplier * 2),
                      Container(
                        // height: 70,
                        // width: 70,
                        height: SizeConfig.heightMultiplier * 6.46,
                        width: SizeConfig.widthMultiplier * 11.99,
                        decoration: BoxDecoration(
                          color: role.active ? Colors.grey[300] : const Color.fromRGBO(224, 224, 224, .3),
                          shape: BoxShape.circle,
                          image: (clientContact?.avatar != null)
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(clientContact!.avatar!),
                                  colorFilter: ColorFilter.mode(
                                  role.active ? Colors.black : Colors.black.withOpacity(0.3),
                                    BlendMode.dstIn,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: SizeConfig.widthMultiplier * 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loginService!.user!.name!,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier * 2.50,
                                color: role.active ? Colors.blue[700] : const Color.fromRGBO(25, 118, 210, .3),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.61),
                              child: Text(
                                getRolePosition(role),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 1.95,
                                  color: role.active ? Colors.grey : const Color.fromRGBO(158, 158, 158, .3),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList();

        return [
          ...data,
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: SizeConfig.heightMultiplier * 0.59,
                ),
                Divider(),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 0.59,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(0.5),
                    child: PrimaryButton(
                      height: SizeConfig.heightMultiplier * 6,
                      btnText: 'Logout',
                      buttonColor: Color.fromRGBO(33, 150, 243, 1),
                      onPressed: () {
                        loginService?.logout(context: context).then(
                              (bool success) =>
                                  Navigator.pushNamed(context, '/'),
                            );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1.46,
                ),
              ],
            ),
          )
        ];
      },
      child: InkWell(
        child: AccountImage(),
      ),
    );
  }
}

String roleAndName(index, name, loginService) {
  String n = name[index].contains(loginService.user.name)
      ? name[index].replaceAll("${loginService.user.name}", ",")
      : (name[index].split("-").first + ",");
  String c = "${loginService.user.companyName}";
  return n + c;
}

class AccountImage extends StatefulWidget {
  const AccountImage({Key? key}) : super(key: key);

  @override
  State<AccountImage> createState() => _AccountImageState();
}

class _AccountImageState extends State<AccountImage> {
  LoginService? loginService;

  @override
  initState() {
    loginService = Provider.of<LoginService>(context, listen: false);
    // debugPrint('roles: ============= ${loginService.user.roles}');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ContactService contactService = Provider.of<ContactService>(context);
    return FutureBuilder(
      future: loginService?.user?.userId != null
      ? contactService.getContactPicture(loginService!.user!.userId!)
      : null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          //margin: EdgeInsets.symmetric(vertical: 15),
          // margin: EdgeInsets.symmetric(
          //   vertical: 12/*SizeConfig.heightMultiplier * 2.34*/,
          // ),
          margin: EdgeInsets.only(top: 3, right: 5),
          height: 28,
          width: 28,
          child: Consumer<LoginProvider>(
            builder: (_, login, __) {
              return Container(
                height: SizeConfig.heightMultiplier * 6.86,
                width: SizeConfig.widthMultiplier * 9.73,
                // height: 40,
                // width: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  CupertinoIcons.person_fill,
                  size: SizeConfig.heightMultiplier * 4.06,
                  color: primaryColor,
                ),
                // child: login.image == null || login.image == ''
                //     ? Icon(
                //         CupertinoIcons.person_fill,
                //         // size: 90,
                //         size: SizeConfig.heightMultiplier * 4.06,
                //         color: primaryColor,
                //       )
                //     : ClipRRect(
                //         borderRadius: BorderRadius.circular(60),
                //         // borderRadius: BorderRadius.circular(
                //         //   SizeConfig.heightMultiplier *
                //         //       34.5 /
                //         //       SizeConfig.widthMultiplier *
                //         //       40.345,
                //         // ),
                //         child: CachedNetworkImage(
                //           imageUrl: login.image,
                //           fit: BoxFit.cover,
                //           cacheManager: login.cacheManager,
                //           progressIndicatorBuilder: (context, val, progress) {
                //             return Loading();
                //           },
                //           errorWidget: (context, url, error) => Error(),
                //         ),
                //       ),
              );
            },
          ),
        );
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: SizeConfig.heightMultiplier * 6.86,
      // width: SizeConfig.widthMultiplier * 9.73,
      height: 40,
      width: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class Error extends StatelessWidget {
  const Error({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 6.86,
      width: SizeConfig.widthMultiplier * 9.73,
      // height: 40,
      // width: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Icon(
          Icons.error,
          color: Colors.red,
          //size: 90,
          size: SizeConfig.heightMultiplier * 13.17,
        ),
      ),
    );
  }
}

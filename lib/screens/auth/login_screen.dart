import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/screens/auth/register_screen.dart';
import 'package:piiprent/screens/widgets/primary_button.dart';
import 'package:piiprent/screens/forgot_password_screen.dart';
import 'package:piiprent/screens/widgets/custom_text_field_without_label.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/push_notification_service.dart';
import 'package:piiprent/widgets/language-select.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static final String name = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future deleteImageFromCache({required BuildContext context}) async {
  Provider.of<LoginProvider>(context, listen: false).image = null;
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _formError;
  bool _fetching = false;

  TextEditingController _usernameController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  TextEditingController _passwordController =
      TextEditingController.fromValue(TextEditingValue(text: ''));

  _onLogin(LoginService loginService, ContactService contactService) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    // _formKey.currentState.save();
    //await _deleteImageFromCache(loginProvider.image);
    PaintingBinding.instance.imageCache.clear();

    setState(() {
      _fetching = true;
      _formError = '';
    });

    try {
      RoleType type = await loginService.login(
          context: context,
          username: _usernameController.text,
          password: _passwordController.text);
            //await Provider.of<ContactService>(context,listen: false).switchAccount();

      await PushNotificationService(user: loginService.user?.email)
          .initNotifications();

      if (type == RoleType.Candidate) {
        // ignore: unnecessary_null_comparison
        if (loginProvider.image == null)
          Provider.of<ContactService>(context, listen: false)
              .getContactPicture(loginService.user!.userId!)
              .then((value) {
            loginProvider.image = value;
            setState(() {});
          });
        Navigator.pushNamed(context, '/candidate_home');

        return;
      } else if (type == RoleType.Client) {
        // ignore: unnecessary_null_comparison
        if (loginProvider.image == null)
          Provider.of<ContactService>(context, listen: false)
              .getContactPicture(loginService.user!.userId!)
              .then((value) {
            loginProvider.image = value;
            setState(() {});
          });

        List<Role> roles = await contactService.getRoles();

        // Verify that the contact type is correct in cases when there were some operations on roles
        // in admin dashboard. There is no validation logic when the admin user adds/removes the roles.
        if (roles.length > 0) {
          roles[0].active = true;
          loginService.user?.roles = roles;
          Navigator.pushNamed(context, '/client_home');
        } else {
          Navigator.pushNamed(context, '/candidate_home');
        }

        return;
      }
    } catch (e) {
      // showAlertDialog(context);
      setState(() {
        _fetching = false;
        _formError = e.toString() ?? 'Unexpected error occurred.';
      });
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();

    SharedPreferences.getInstance().then((prefs) =>
        _usernameController.text = prefs.getString('username') ?? '');
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  CustomPopupMenuController popupController = CustomPopupMenuController();
  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);
    ContactService contactService = Provider.of<ContactService>(context);
    
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxHeight: size.height, maxWidth: size.width);
    SizeConfig().init(constraints, orientation);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier * 1.46,
                              right: SizeConfig.widthMultiplier * 3.65,
                            ),
                            child: LanguageSelect(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 1.46),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'icon/icon.png',
                              width: SizeConfig.widthMultiplier * 21.89,
                              height: SizeConfig.heightMultiplier * 9.51,
                            ),
                            Image.asset(
                              'icon/logo.png',
                              height: SizeConfig.heightMultiplier * 50,
                              width: SizeConfig.widthMultiplier * 42.66,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translate('text.login_page'),
                        style: TextStyle(
                          color: greyColor,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // SizedBox(
                      //   width: SizeConfig.widthMultiplier * 1.22,
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegistrationScreen.name);
                        },
                        child: Text(
                          translate('link.register_here'),
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            color: primaryColor,
                            fontSize: SizeConfig.heightMultiplier * 2.34,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: SizedBox(
                          height: SizeConfig.heightMultiplier * 76,
                        ),
                      ),
                    ],
                  ),
                  // RegisterForm(
                  //   key: key,
                  //   settings: companyService.settings,
                  // ),
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4.65),
                  padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.65,
                    right: SizeConfig.widthMultiplier * 3.65,
                    top: SizeConfig.heightMultiplier * 2.19,
                  ),
                  width: MediaQuery.of(context).size.width - 32,
                  constraints: BoxConstraints(maxWidth: 550, maxHeight: 600),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 3,
                        ),
                        Text(
                          translate('page.title.login'),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.heightMultiplier * 3.51,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 5,
                        ),
                        // Spacer(),
                        CustomTextFieldWIthoutLabel(
                          hint: translate('field.email'),
                          controller: _usernameController,
                          validator: usernameValidator,
                          onSubmit: (val) {
                            // if(_password != null || _password != ""){
                            //   _onLogin(loginService, contactService);
                            // }
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 1.3,
                        ),
                        CustomTextFieldWIthoutLabel(
                          passowrd: true,
                          hint: translate('field.password'),
                          controller: _passwordController,
                          validator: requiredValidator,
                          onSubmit: (val) {
                            _onLogin(loginService, contactService);
                          },
                        ),
                        // Spacer(),
                        FormMessage(type: MessageType.Error, message: _formError ?? ''),
                        // Spacer(),
                        PrimaryButton(
                          btnText: translate('button.login'),
                          onPressed: () => _onLogin(loginService, contactService),
                          loading: _fetching,
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 1.3,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, ForgotPasswordScreen.name);
                          },
                          child: Text(
                            translate('link.forgot_password'),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: SizeConfig.heightMultiplier * 2.04,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2.39,
                        ),
                      ],
                    ),
                  ),
                  height: SizeConfig.heightMultiplier * 53,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff5D7CAC).withOpacity(.13),
                        blurRadius: SizeConfig.heightMultiplier * 5.56,
                        spreadRadius: 0,
                        offset: Offset(0, SizeConfig.heightMultiplier * 0.58),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      SizeConfig.heightMultiplier * 2.05,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// showAlertDialog(BuildContext context) {
//   Widget okButton = TextButton(
//     onPressed: () {
//       Navigator.pop(context);
//     }, 
//     child: Text("OK")
//   );

  // AlertDialog alert = AlertDialog(
  //   title: Text("Authentication Error"), 
  //   content: Text("Invalid username or password"), 
  //   actions: [
  //     okButton,
  //   ]
  // );
  
  // showDialog(
  //   context: context, 
  //   builder: (BuildContext context) {
  //     return alert;
  //   }
  // );
// }
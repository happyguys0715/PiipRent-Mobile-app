import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/screens/candidate/candidate_home_screen.dart';
import 'package:piiprent/screens/client_home_screen.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final void Function()? onRegister;

  LoginForm({this.onRegister});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? _username;
  String? _password;
  String? _formError;
  bool _fetching = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _onLogin(LoginService loginService, ContactService contactService) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _fetching = true;
      _formError = null;
    });

    try {
      RoleType type = await loginService.login(
          context: context, username: _username!, password: _password!);

      if (type == RoleType.Candidate) {
        debugPrint('type :: $type');

        Navigator.pushNamed(context, '/candidate_home');

        return;
      } else if (type == RoleType.Client) {
        List<Role> roles = await contactService.getRoles();
        roles[0].active = true;
        loginService.user?.roles = roles;

        Navigator.pushNamed(context, '/client_home');
        return;
      }
    } catch (e) {
      setState(() {
        _fetching = false;
        _formError = e?.toString() ?? 'Unexpected error occurred.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);
    ContactService contactService = Provider.of<ContactService>(context);

    loginService.getUser(context).then((RoleType role) {
      if (role == RoleType.Candidate) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CandidateHomeScreen(),
          ),
        );
      } else if (role == RoleType.Client) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClientHomeScreen(),
          ),
        );
      }
    } as FutureOr Function(RoleType? value));

    return Container(
      padding: EdgeInsets.symmetric(
        //horizontal: 12.0,
        horizontal: SizeConfig.widthMultiplier * 2.92,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Field(
              label: translate('field.email'),
              type: TextInputType.emailAddress,
              validator: emailValidator,
              onSaved: (String value) {
                _username = value;
              }, initialValue: null, onFocus: null, onChanged: null, setStream: null, leading: null,
            ),
            Field(
              label: translate('field.password'),
              obscureText: true,
              onSaved: (String value) {
                _password = value;
              }, initialValue: null, validator: null, onFocus: null, onChanged: null, setStream: null, leading: null,
            ),
            FormMessage(type: MessageType.Error, message: _formError!),
            SizedBox(
              //height: 16,
              height: SizeConfig.heightMultiplier * 2.34,
            ),
            FormSubmitButton(
              disabled: _fetching,
              onPressed: () => _onLogin(loginService, contactService),
              label: translate('button.login'),
            ),
            SizedBox(
              //height: 10,
              height: SizeConfig.heightMultiplier * 1.46,
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/forgot_password'),
              child: Text(
                translate('link.forgot_password'),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: SizeConfig.heightMultiplier * 2.34,
                ),
              ),
            ),
            SizedBox(
              //height: 16,
              height: SizeConfig.heightMultiplier * 2.34,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  translate('text.login_page'),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                  ),
                ),
                SizedBox(
                  //width: 5,
                  width:SizeConfig.widthMultiplier*1.22,
                ),
                GestureDetector(
                  onTap: widget.onRegister,
                  child: Text(
                    translate('link.register_here'),
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? _oldPass;
  String? _newPass;
  String? _confirmPass;

  bool _fetching = false;
  String? _error;
  String? _message;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _onSubmit(ContactService service, String id) async {
    // TODO: add more validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _fetching = true;
      _message = null;
      _error = null;
    });

    try {
      String message = await service.changePassowrd(
        oldPass: _oldPass!,
        newPass: _newPass!,
        confirmPass: _confirmPass!,
        id: id,
      );

      setState(() {
        _message = message;
      });
    } catch (err) {
      setState(() {
        dynamic err; // Assuming err is an object that may have a 'message' property

        String errorMessage = err is Error ? err.toString() : err?.message ?? "Unknown error";

        _error = errorMessage;
      });
    } finally {
      setState(() {
        _fetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ContactService contactService = Provider.of<ContactService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

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
        backgroundColor: Colors.blue[500],
        title: Text(translate('page.title.change_password'),style: TextStyle(
        fontSize: SizeConfig.heightMultiplier*2.34,
      ),),),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Field(
                  label: translate('field.current_password'),
                  obscureText: true,
                  onSaved: (String value) {
                    _oldPass = value;
                  }, initialValue: null, validator: null, onFocus: null, onChanged: null, setStream: null, leading: null,
                ),
                Field(
                  label: translate('field.new_password'),
                  obscureText: true,
                  onSaved: (String value) {
                    _newPass = value;
                  }, initialValue: null, validator: null, onFocus: null, onChanged: null, setStream: null, leading: null,
                ),
                Field(
                  label: translate('field.verify_pssword'),
                  obscureText: true,
                  onSaved: (String value) {
                    _confirmPass = value;
                  }, initialValue: null, validator: null, onFocus: null, onChanged: null, setStream: null, leading: null,
                ),
                FormMessage(
                  type: MessageType.Error,
                  message: _error as String,
                ),
                FormMessage(
                  type: MessageType.Success,
                  message: _message as String,
                ),
                SizedBox(
                  //height: 15.0,
                  height: SizeConfig.heightMultiplier*2.34,
                ),
                FormSubmitButton(
                  disabled: _fetching,
                  onPressed: () {
                    _onSubmit(contactService, loginService.user!.userId!);
                  },
                  label: translate('button.submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

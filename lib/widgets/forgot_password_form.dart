import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String? _email;
  bool _fetching = false;
  String _error = '';
  String _message = '';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _onSubmit(ContactService service) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _fetching = true;
      _message = '';
      _error = '';
    });

    try {
      await service.forgotPassowrd(_email!);

      setState(() {
        _message =
            'Password reset instructions were sent to this email address';
      });
    } catch (err) {
      setState(() {
        dynamic err;
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

    return Container(
      padding: EdgeInsets.symmetric(
        //horizontal: 18.0,
        horizontal:SizeConfig.widthMultiplier*3.89,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Field(
              label: translate('field.email'),
              validator: emailValidator,
              onSaved: (String? value) {
                _email = value;
              },
            ),
            FormMessage(
              type: MessageType.Error,
              message: _error,
            ),
            FormMessage(
              type: MessageType.Success,
              message: _message,
            ),
            FormSubmitButton(
              disabled: _fetching,
              onPressed: () => _onSubmit(contactService),
              label: translate('button.submit'),
            ),
            SizedBox(
              //height: 10,
              height: SizeConfig.heightMultiplier * 1.46,
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                translate('link.back_to_login'),
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: SizeConfig.heightMultiplier * 2.34,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

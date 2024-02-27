import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/models/worktype_model.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/services/worktype_service.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:piiprent/widgets/form_select.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class CandidateSkillActivityScreenOld extends StatefulWidget {
  final String? timesheet;
  final String? skill;
  final String? companyId;

  CandidateSkillActivityScreenOld({
    this.timesheet,
    this.skill,
    this.companyId,
  });

  @override
  _CandidateSkillActivityScreenOldState createState() =>
      _CandidateSkillActivityScreenOldState();
}

class _CandidateSkillActivityScreenOldState
    extends State<CandidateSkillActivityScreenOld> {
  String? _worktype;
  String? _rate;
  double? _value;

  bool _fetching = false;
  String? _error;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _onSubmit(SkillActivityService service, context) async {
    // TODO: add more validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState?.save();

    setState(() {
      _fetching = true;
      _error = null;
    });

    try {
      Navigator.pop(context, true);
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
    SkillActivityService skillActivityService =
        Provider.of<SkillActivityService>(context);
    WorktypeService worktypeService = Provider.of<WorktypeService>(context);
    var localizationDelegate = LocalizedApp.of(context).delegate;

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
          translate(
            'page.title.create_skill_activity',
          ),
          style: TextStyle(
            fontSize: SizeConfig.heightMultiplier*2.34,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FutureBuilder(
                  future: worktypeService.getSkillWorktypes({
                    'skill': widget.skill,
                    'company': widget.companyId,
                    'priced': 'true'
                  }),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Worktype> data = snapshot.data;

                      return FormSelect(
                        multiple: false,
                        title: translate('field.skill_activity'),
                        columns: 1,
                        onChanged: (String id) {
                          _worktype = id;
                          var el =
                              data.firstWhere((element) => element.id == id);
                          _rate = el.defaultRate;
                        },
                        options: data.map((Worktype el) {
                          return Option(
                            value: el.id,
                            title: el.name(localizationDelegate.currentLocale), translateKey: '',
                          );
                        }).toList(), onSave: null, validator: null,
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                Field(
                  label: translate('field.skill_activity_amount'),
                  type: TextInputType.number,
                  onSaved: (String value) {
                    _value = double.parse(value);
                  }, initialValue: null, validator: null, onFocus: null, onChanged: null, setStream: null, leading: null,
                ),
                FormMessage(
                  type: MessageType.Error,
                  message: _error as String,
                ),
                SizedBox(
                  //height: 15.0,
                  height:SizeConfig.heightMultiplier*2.34,
                ),
                FormSubmitButton(
                  disabled: _fetching,
                  onPressed: () {
                    _onSubmit(skillActivityService, context);
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

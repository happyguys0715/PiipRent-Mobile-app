import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/screens/auth/login_screen.dart';
import 'package:piiprent/services/company_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/push_notification_service.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatefulWidget {
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();

  bool _showErrorMessage = false;

  _redirect() async {
    LoginService loginService = Provider.of<LoginService>(
      key.currentContext as BuildContext,
      listen: false,
    );
    // ignore: unused_local_variable
    LoginProvider loginProvider = Provider.of<LoginProvider>(
      key.currentContext as BuildContext,
      listen: false,
    );

    final role = await loginService.getUser(context);
    if (role != null) {
      await PushNotificationService(user: loginService.user!.email)
          .initNotifications();
    }

    if (role == RoleType.Candidate) {
      // if (loginProvider.image == null)
      //   await Provider.of<ContactService>(context, listen: false)
      //       .getContactPicture(loginService.user.userId)
      //       .then((value) {
      //     loginProvider.image = value;
      //     setState(() {});
      //   });
      // print('image after login (Candidate): ${loginProvider.image}');
      Navigator.pushReplacementNamed(context, '/candidate_home');
    } else if (role == RoleType.Client) {
      // if (loginProvider.image == null)
      //   await Provider.of<ContactService>(context, listen: false)
      //       .getContactPicture(loginService.user.userId)
      //       .then((value) {
      //     loginProvider.image = value;
      //     setState(() {});
      //   });
      // print('image after login (Client): ${loginProvider.image}');
      Navigator.pushReplacementNamed(context, '/client_home');
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.name);
    }
  }

  _getSettings() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      CompanyService companyService = Provider.of<CompanyService>(
        key.currentContext as BuildContext,
        listen: false,
      );

      var result = await companyService.fetchSettings();

      if (result == true) {
        _redirect();
      } else {
        setState(() {
          _showErrorMessage = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _getSettings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/company_banner.png'),
            _showErrorMessage
                ? Text(
                    'Please turn on internet',
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      fileService: HttpFileService(),
    ),
  );
}

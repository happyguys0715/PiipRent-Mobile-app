import 'package:background_location/background_location.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/screens/address_screen.dart';
import 'package:piiprent/screens/auth/login_screen.dart';
import 'package:piiprent/screens/auth/register_screen.dart';
import 'package:piiprent/screens/candidate/candidate_home_screen.dart';
import 'package:piiprent/screens/candidate_job_offers_screen.dart';
import 'package:piiprent/screens/candidate_jobs_screen.dart';
import 'package:piiprent/screens/candidate_profile_screen.dart';
import 'package:piiprent/screens/candidate_timesheets_screen.dart';
import 'package:piiprent/screens/client_home_screen.dart';
import 'package:piiprent/screens/client_jobs_screen.dart';
import 'package:piiprent/screens/client_jobsites_screen.dart';
import 'package:piiprent/screens/client_profile_screen.dart';
import 'package:piiprent/screens/client_timesheets_screen.dart';
import 'package:piiprent/screens/forgot_password_screen.dart';
import 'package:piiprent/screens/preview_screen.dart';
import 'package:piiprent/services/candidate_service.dart';
import 'package:piiprent/services/company_service.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/country_service.dart';
import 'package:piiprent/services/industry_service.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/services/jobsite_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/note_service.dart';
import 'package:piiprent/services/notification_service.dart';
import 'package:piiprent/services/push_notification_service.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/services/skill_service.dart';
import 'package:piiprent/services/tag_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/services/worktype_service.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

void main() async {
  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await BackgroundLocation.setAndroidNotification(
  //   title: "Background Location Service",
  //   message: "Fetching your current location",
  //   icon: "@mipmap/ic_launcher",
  // );

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: [
      'en',
      'et',
      'fi',
      'ru',
    ],
  );

  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LoginProvider(),
          ),
          Provider<IndustryService>(
            create: (_) => IndustryService(),
          ),
          Provider<LoginService>(
            create: (_) => LoginService(),
          ),
          Provider<JobOfferService>(
            create: (_) => JobOfferService(),
          ),
          Provider<JobService>(
            create: (_) => JobService(),
          ),
          Provider<TimesheetService>(
            create: (_) => TimesheetService(),
          ),
          Provider<ContactService>(
            create: (_) => ContactService(),
          ),
          Provider<CandidateService>(
            create: (_) => CandidateService(),
          ),
          // ChangeNotifierProvider(
          //   create: (_) => CloseSwitchMenu(),
          // ),
          Provider<NotificationService>(
            create: (_) => NotificationService(),
          ),
          Provider<CompanyService>(
            create: (_) => CompanyService(),
          ),
          Provider<JobsiteService>(
            create: (_) => JobsiteService(),
          ),
          Provider<SkillActivityService>(
            create: (_) => SkillActivityService(),
          ),
          Provider<WorktypeService>(
            create: (_) => WorktypeService(),
          ),
          Provider<SkillService>(
            create: (_) => SkillService(),
          ),
          Provider<CountryService>(
            create: (_) => CountryService(),
          ),
          Provider<TagService>(
            create: (_) => TagService(),
          ),
          Provider<NoteService>(
            create: (_) => NoteService(),
          ),
        ],
        child: LocalizedApp(
          delegate,
          MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: Portal(
        child: GetMaterialApp(
          title: 'Piiprent',
          useInheritedMediaQuery: true,
          localizationsDelegates: [
            localizationDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          theme: new ThemeData(
            //accentColor: Colors.blueAccent,
            scaffoldBackgroundColor: Colors.grey[100],
            textTheme:
                GoogleFonts.sourceSansProTextTheme(Theme.of(context).textTheme),
          ),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          routes: <String, WidgetBuilder>{
            LoginScreen.name: (BuildContext context) => LoginScreen(),
            RegistrationScreen.name: (BuildContext context) =>
                RegistrationScreen(),
            '/candidate_home': (BuildContext context) => CandidateHomeScreen(),
            '/candidate_jobs': (BuildContext context) => CandidateJobsScreen(),
            CandidateJobOffersScreen.name: (BuildContext context) =>
                CandidateJobOffersScreen(),
            '/candidate_timesheets': (BuildContext context) =>
                CandidateTimesheetsScreen(),
            '/candidate_profile': (BuildContext context) =>
                CandidateProfileScreen(),
            '/client_home': (BuildContext context) => ClientHomeScreen(),
            '/client_profile': (BuildContext context) => ClientProfileScreen(),
            '/client_jobs': (BuildContext context) => ClientJobsScreen(),
            '/client_timesheets': (BuildContext context) =>
                ClientTimesheetsScreen(),
            '/client_jobsites': (BuildContext context) =>
                ClientJobsitesScreen(),
            ForgotPasswordScreen.name: (BuildContext context) =>
                ForgotPasswordScreen(),
            '/address': (BuildContext context) => AddressScreen(),
          },
          home: LayoutBuilder(
            builder: (context, constraints) {
              return OrientationBuilder(
                builder: (context, orientation) {
                  SizeConfig().init(constraints, orientation);
                  return PreviewScreen();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

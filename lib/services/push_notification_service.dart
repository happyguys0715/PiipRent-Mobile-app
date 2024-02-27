import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:piiprent/screens/candidate_job_offers_screen.dart';


final navigatorKey = GlobalKey<NavigatorState>();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

// class FirebaseApi {
class PushNotificationService {
  final user;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;
  
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'job_offer_channel',
    'Job Offer Notification',
    description: 'This channel is used for candidate job offer notifications',
    importance: Importance.defaultImportance,
  );


  PushNotificationService({
    this.user,
  });

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    
    navigatorKey.currentState?.pushNamed(
      CandidateJobOffersScreen.name,
      arguments: null,
    );
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        handleMessage(message);
      }
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (platform == null) return;

    await platform.createNotificationChannel(_androidChannel);
  }


  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode, 
        notification.title, 
        notification.body, 
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',

          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }
 
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    // await _saveDeviceToken(fcmToken);

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> _saveDeviceToken(fcmToken) async {
    var tokens = _db
        .collection('users')
        .doc(this.user)
        .collection('tokens')
        .doc(fcmToken);
    await tokens.set({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': Platform.operatingSystem // optional
    });
  }
}

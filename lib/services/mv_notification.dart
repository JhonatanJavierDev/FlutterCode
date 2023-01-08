import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:catalinadev/deeplink/deeplink_config.dart';
import 'package:catalinadev/screen/pages.dart';
import 'package:catalinadev/utils/global_variable.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

String? selectedNotificationPayload;

class MVNotification {
  static late SharedPreferences data;
  static late FirebaseMessaging messaging;

  static Future init() async {
    data = await SharedPreferences.getInstance();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      printLog(value!, name: 'Device Token');
      data.setString('device_token', value);
    });

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      description: 'This channel is used for important notifications.',
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message recieved");
      debugPrint("Notif Body ${event.notification!.body}");
      debugPrint("Notif Data ${event.data}");

      RemoteNotification? notification = event.notification;
      AppleNotification? apple = event.notification?.apple;
      AndroidNotification? android = event.notification?.android;

      var _imageUrl = '';

      if (Platform.isAndroid && android != null) {
        if (android.imageUrl != null) {
          _imageUrl = android.imageUrl!;
        }
      } else if (Platform.isIOS && apple != null) {
        if (apple.imageUrl != null) {
          _imageUrl = apple.imageUrl!;
        }
      }

      if (notification != null) {
        if (_imageUrl.isNotEmpty) {
          String? _bigPicturePath = '';
          DateTime _dateNow = DateTime.now();
          if (Platform.isIOS) {
            _bigPicturePath = await _downloadAndSaveFile(
                _imageUrl, 'notificationimg$_dateNow.jpg');
          }
          final IOSNotificationDetails iOSPlatformChannelSpecifics =
              IOSNotificationDetails(attachments: <IOSNotificationAttachment>[
            IOSNotificationAttachment(_bigPicturePath)
          ]);
          await showBigPictureNotificationURL(_imageUrl).then((value) {
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      icon: 'transparent',
                      channelDescription: channel.description,
                      styleInformation: value,
                      fullScreenIntent: true,
                    ),
                    iOS: iOSPlatformChannelSpecifics),
                payload: json.encode(event.data));
          });
        } else {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: 'transparent',
                  channelDescription: channel.description,
                ),
              ),
              payload: json.encode(event.data));
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print('Init onMessageOpenedApp!');
      debugPrint('onMessageOpenedApp Click ' + message.data.toString());
    });
  }

  static Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  static Future<BigPictureStyleInformation> showBigPictureNotificationURL(
      String url) async {
    final ByteArrayAndroidBitmap largeIcon =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(url));
    final ByteArrayAndroidBitmap bigPicture =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(url));

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture, largeIcon: largeIcon);

    return bigPictureStyleInformation;
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static configureSelectNotificationSubject(context) {
    selectNotificationSubject.stream.listen((String? payload) async {
      debugPrint("Payload : $payload");
      var _payload = json.decode(payload!);
      if (_payload['type'] == 'order') {
        await Navigator.of(GlobalVariable.navState.currentContext!).push(
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      } else if (_payload['type'] == 'chat') {
        await Navigator.of(GlobalVariable.navState.currentContext!)
            .push(MaterialPageRoute(
                builder: (context) => ChatHomeScreen(
                      receiverId: _payload['id'],
                    )));
      } else {
        print("Else");
        Uri uri = Uri.parse(_payload['click_action']);
        DeeplinkConfig().pathUrl(uri, context, false);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print('Reload onMessageOpenedApp!');
      debugPrint('Message Open Click ' + message.data.toString());

      if (message.data['type'] == 'order') {
        Navigator.of(GlobalVariable.navState.currentContext!).push(
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      } else if (message.data['type'] == 'chat') {
        Navigator.of(GlobalVariable.navState.currentContext!)
            .push(MaterialPageRoute(
                builder: (context) => ChatHomeScreen(
                      receiverId: message.data['id'],
                    )));
      } else {
        print("Else");
        Uri uri = Uri.parse(message.data['click_action']);
        DeeplinkConfig().pathUrl(uri, context, false);
      }
    });
  }

  static configureDidReceiveLocalNotificationSubject(context) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

typedef OnMessage = void Function(Map<String, dynamic> message);

class CloudMessagingService {
  CloudMessagingService({
    FirebaseMessaging? firebaseMessaging,
    Logger? logger,
    OnMessage? messageHandler,
  })  : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _logger = logger ?? Logger(),
        _messageHandler = messageHandler {
    _requestPermissions();
    _onBackgroundMessage();
    _onForegroundMessage();
    _handleMessageInteraction();
  }

  final FirebaseMessaging _firebaseMessaging;
  final Logger _logger;
  final OnMessage? _messageHandler;

  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<String?> get token async {
    final response = await _firebaseMessaging.getToken();
    _logger.d('FCM token: $response');

    return response;
  }

  Future<bool> _requestPermissions() async {
    _logger.d('Requesting permissions');
    try {
      final response = await _firebaseMessaging.requestPermission();

      return response.authorizationStatus == AuthorizationStatus.authorized;
    } on Exception catch (e, s) {
      _logger.e('Error requesting permissions', e, s);

      return false;
    }
  }

  /// Listen to foreground notifications
  StreamSubscription<RemoteMessage> _onForegroundMessage() {
    return FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        _logger.d('Foreground message received, data: ${message.data}');

        if (message.notification != null) {
          _logger.d(
            'Message has notification, '
            'notification: ${message.notification?.title}',
          );
          _displayNotificationsAndroid(message);
        }
      },
    );
  }

  /// Listen to background notifications
  void _onBackgroundMessage() {
    return FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp();

    log(
      'Background message received, '
      'data: ${message.data}, '
      'notification: ${message.notification?.title}',
    );
  }

  static void _displayNotificationsAndroid(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null || android == null) {
      return;
    }

    final androidNotificationDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      icon: 'ic_notification',
      colorized: true,
      color: const Color(0xFFE07C4F),
    );
    final payload = json.encode(message.data);

    _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(android: androidNotificationDetails),
      payload: payload,
    );
  }

  Future<void> _handleMessageInteraction() async {
    _logger.d('Handling message interactions');
    await _handleBackgroundMessageInteraction();
    _handleForegroundMessageInteraction();
    _handleLocalNotificationInteraction();
  }

  Future<void> _handleBackgroundMessageInteraction() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  StreamSubscription<RemoteMessage> _handleForegroundMessageInteraction() {
    return FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleLocalNotificationInteraction() {
    _localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onSelectNotification: (payload) {
        if (payload == null) return;

        final data = json.decode(payload) as Map<String, dynamic>;
        _messageHandler?.call(data);
      },
    );
  }

  void _handleMessage(RemoteMessage message) {
    _messageHandler?.call(message.data);
  }
}

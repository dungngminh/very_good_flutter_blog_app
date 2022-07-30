import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:very_good_blog_app/app/app.dart';

class FcmHelper {
  // FCM Messaging
  static late FirebaseMessaging messaging;

  // Notification lib
  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // initialize fcm and firebase core
      messaging = FirebaseMessaging.instance;

      // initialize notifications channel and libraries
      await _initNotification();

      // notification settings handler
      await _setupFcmNotificationSettings();

      // generate token if it not already generated and store it on shared pref
      await _generateFcmToken();

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

      // listen to notifications clicks
      listenToActionButtons();
    } catch (error) {
      print(error);
    }
  }

  /// when user click on notification or click on button on the notification
  static void listenToActionButtons() {
    awesomeNotifications.actionStream.listen(
      (ReceivedNotification receivedNotification) async {
        // TODO make ur actions (open screen or sth)
        // for ex:
      },
    );
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> _setupFcmNotificationSettings() async {
    //show notification with sound and badge
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    //NotificationSettings settings
    await messaging.requestPermission(
      provisional: true,
    );
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  static Future<void> _generateFcmToken() async {
    try {
      final token = await messaging.getToken();
      if (token != null) {
        await SecureStorageHelper.writeValueToKey(
          key: SecureStorageHelper.fcmToken,
          value: token,
        );
        _sendFcmTokenToServer();
      } else {
        await Future.delayed(const Duration(seconds: 5));
        await _generateFcmToken();
      }
    } catch (error) {
      log(error.toString());
    }
  }

  /// this method will be triggered when the app generate fcm
  /// token successfully
  static _sendFcmTokenToServer() {
    final token =
        SecureStorageHelper.getValueByKey(SecureStorageHelper.fcmToken);
    // TODO SEND FCM TOKEN TO SERVER
  }

  ///handle fcm notification when app is closed/terminated
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    _showNotification(
      id: 1,
      title: message.notification?.title ?? 'Tittle',
      body: message.notification?.body ?? 'Body',
    );
  }

  //handle fcm notification when app is open
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    _showNotification(
      id: 1,
      title: message.notification?.title ?? 'Tittle',
      body: message.notification?.body ?? 'Body',
    );
  }

  //display notification for user with sound
  static _showNotification({
    required String title,
    required String body,
    required int id,
    String? channelKey,
    String? groupKey,
    NotificationLayout? notificationLayout,
    String? summary,
    Map<String, String>? payload,
    String? largeIcon,
  }) async {
    await awesomeNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        awesomeNotifications.requestPermissionToSendNotifications();
      } else {
        // u can show notification
        awesomeNotifications.createNotification(
          content: NotificationContent(
            id: id,
            title: title,
            body: body,
            groupKey: groupKey,
            channelKey: channelKey ?? NotificationChannels.likeChannelKey,
            showWhen:
                true, // Hide/show the time elapsed since notification was displayed
            payload:
                payload, // data of the notification (it will be used when user clicks on notification)
            notificationLayout:
                notificationLayout, // notification shape (message,media player..etc) For ex => NotificationLayout.Messaging
            autoDismissible:
                true, // dismiss notification when user clicks on it
            summary:
                summary, // for ex: New message (it will be shown on status bar before notificaiton shows up)
            largeIcon:
                largeIcon, // image of sender for ex (when someone send you message his image will be shown)
          ),
        );
      }
    });
  }

  ///init notifications channels
  static _initNotification() async {
    await awesomeNotifications.initialize(
      null, // null mean it will show app icon on the notification (status bar)
      [
        NotificationChannel(
          channelGroupKey: NotificationChannels.followChannelGroupKey,
          channelKey: NotificationChannels.followChannelKey,
          channelName: NotificationChannels.followChannelName,
          groupKey: NotificationChannels.followGroupKey,
          channelDescription: NotificationChannels.followChannelDescription,
          channelShowBadge: true,
          playSound: true,
          importance: NotificationImportance.Max,
        ),
        NotificationChannel(
          channelGroupKey: NotificationChannels.likeChannelGroupKey,
          channelKey: NotificationChannels.likeChannelKey,
          channelName: NotificationChannels.likeChannelName,
          groupKey: NotificationChannels.likeGroupKey,
          channelDescription: NotificationChannels.likeChannelDescription,
          channelShowBadge: true,
          playSound: true,
          importance: NotificationImportance.Max,
        ),
        NotificationChannel(
          channelGroupKey: NotificationChannels.followingProfileChannelGroupKey,
          channelKey: NotificationChannels.followingProfileChannelKey,
          channelName: NotificationChannels.followingProfileChannelName,
          groupKey: NotificationChannels.followingProfileGroupKey,
          channelDescription:
              NotificationChannels.followingProfileChannelDescription,
          channelShowBadge: true,
          playSound: true,
          importance: NotificationImportance.Max,
        )
      ],

      channelGroups: [
        NotificationChannelGroup(
          channelGroupkey: NotificationChannels.likeChannelGroupKey,
          channelGroupName: NotificationChannels.likeChannelGroupName,
        ),
        NotificationChannelGroup(
          channelGroupkey: NotificationChannels.followChannelGroupKey,
          channelGroupName: NotificationChannels.followChannelGroupName,
        ),
        NotificationChannelGroup(
          channelGroupkey: NotificationChannels.followingProfileChannelGroupKey,
          channelGroupName: NotificationChannels.followingChannelGroupName,
        )
      ],
    );
  }
}

class NotificationChannels {
  /// Follower upload blog notification
  static String get followingProfileChannelKey => 'following_channel';
  static String get followingProfileChannelName => 'following channel';
  static String get followingProfileGroupKey => 'following group key';
  static String get followingProfileChannelGroupKey =>
      'following_channel_group';
  static String get followingChannelGroupName =>
      'following notifications channels';
  static String get followingProfileChannelDescription =>
      'Chat notifications channels';

  // Like notification
  static String get likeChannelKey => 'like_channel';
  static String get likeGroupKey => 'like_group_key';
  static String get likeChannelGroupKey => 'basic_channel_group';
  static String get likeChannelGroupName =>
      'like public notifications channels';
  static String get likeChannelName => 'like notifications channels';
  static String get likeChannelDescription => 'Notification channel for like';

  /// Follow notification
  ///
  ///
  static String get followChannelKey => 'follow_channel';
  static String get followGroupKey => 'basic group key';
  static String get followChannelGroupKey => 'basic_channel_group';
  static String get followChannelGroupName =>
      'follow public notifications channels';
  static String get followChannelName => 'follow notifications channels';
  static String get followChannelDescription =>
      'Notification channel for follow';
}

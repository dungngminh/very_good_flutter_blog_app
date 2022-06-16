import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/widgets/ink_response_widget.dart';

enum NotificationType {
  follow,
  likeBlog,
}

class NotificationTile extends StatelessWidget {
  NotificationTile({
    super.key,
    this.type = NotificationType.follow,
    required this.username,
    required this.timeOccured,
    this.blogName,
    required this.onTileTapAction,
    this.onAddUserTapAction,
    this.userImageUrl,
  }) : assert(
          () {
            if (type == NotificationType.likeBlog && blogName == null) {
              throw FlutterError(
                'NotificationType is likeBlog must show blogName,'
                ' blogName must be not null',
              );
            } else if (type == NotificationType.follow &&
                onAddUserTapAction == null) {
              throw FlutterError(
                'NotificationType is follow must have onAddUserAction,'
                ' onAddUserAction must be not null',
              );
            }
            return true;
          }(),
          '',
        );

  /// This setting for displaying dynamic ui of `NotificationTile`.
  ///
  /// * For Default : `NotificationType.follow` that means widget will render
  /// for displaying notification about who followed you, time followed and
  /// you can trigger `onAddUserAction` to follow back.
  /// WARNING: `onAddUserAction` default is nullable but
  /// `onAddUserAction` must be not null when `type`
  /// is `NotificationType.follow`.
  ///
  ///
  /// * Other option: `NotificationType.likeBlog` that means widget will render
  /// for displaying notification about who like your blog, blog's name and
  /// time occured.
  /// WARNING: `blogName` default is nullable but
  /// `blogName` must be not null when `type`
  /// is `NotificationType.likeBlog`.
  ///
  final NotificationType type;

  final String username;

  final String? userImageUrl;

  final String timeOccured;

  final String? blogName;

  final VoidCallback onTileTapAction;

  final VoidCallback? onAddUserTapAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppPalette.fieldColor,
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: Assets.images.komkat.image().image,
            radius: 24,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: AppTextTheme.darkW700TextStyle.copyWith(
                    fontSize: 16,
                    // height: 18 / 16,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text.rich(
                  type == NotificationType.follow
                      ? const TextSpan(text: 'Đã theo dõi bạn')
                      : TextSpan(
                          text: 'Đã thích bài viết của bạn - ',
                          children: [
                            TextSpan(
                              text: '$blogName',
                              style: AppTextTheme.titleTextStyle
                                  .copyWith(fontSize: 13),
                            )
                          ],
                        ),
                  style: AppTextTheme.regularTextStyle.copyWith(fontSize: 13),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  timeOccured,
                  style: AppTextTheme.regularTextStyle.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          if (type == NotificationType.likeBlog)
            const Expanded(
              child: SizedBox(width: 10),
            )
          else
            InkEffectWidget(
              child: Assets.icons.addUser.svg(
                height: 24,
                color: AppPalette.primaryColor,
              ),
              onTapEvent: () {},
            ),
        ],
      ),
    );
  }
}

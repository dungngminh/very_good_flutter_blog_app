import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/notification/notification.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: context.padding.top + 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Thông báo',
                style: AppTextTheme.darkW700TextStyle,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
                itemBuilder: (context, index) {
                  return NotificationTile(
                    username: 'Komkat',
                    onTileTapAction: () {},
                    timeOccured: '101 phút trước',
                    onAddUserTapAction: () {},
                    blogName: 'Meo meo',
                    // type: NotificationType.likeBlog,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

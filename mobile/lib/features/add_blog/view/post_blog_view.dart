import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart'
    show AppPalette, Assets, ContextExtension;
import 'package:very_good_blog_app/widgets/action_bar.dart';

class PostBlogView extends StatelessWidget {
  const PostBlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: context.padding.top + 8,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ActionBar(),
              Center(
                child: Container(
                  height: 170,
                  width: 150,
                  margin: const EdgeInsets.only(top: 48, bottom: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppPalette.whiteBackgroundColor,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.icons.plusBorder.svg(
                        color: AppPalette.primaryColor,
                        height: 32,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Thêm ảnh',
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

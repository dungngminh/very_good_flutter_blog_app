import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/widgets/blog_card.dart';

class ReadingListView extends StatelessWidget {
  const ReadingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Danh sách bài viết đã lưu',
                style: TextStyle(
                  color: Palette.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          
                        ],
                      ),
                      child: BlogCard(
                        dateAdded: '20 tháng 9, 2022',
                        author: 'Dungngminh',
                        title: 'How to make a beautiful widget',
                        imageUrl: 'https://i.kym-cdn.com/'
                            'photos/images/facebook/001/839/197/2ad.png',
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

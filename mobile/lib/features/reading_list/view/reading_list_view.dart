import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

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
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Palette.fieldColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: AspectRatio(
                                aspectRatio: 1.1,
                                child: Image.network(
                                  'https://i.kym-cdn.com/'
                                  'photos/images/facebook/001/839/197/2ad.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'How i hack Google, Microsoft,dadadadad,..',
                                    style: TextStyle(
                                      color: Palette.primaryTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Nguyen Minh Dung',
                                    style: TextStyle(
                                      color: Palette.descriptionTextColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '20 tháng 9, 2022',
                                    style: TextStyle(
                                      color: Palette.descriptionTextColor,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
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

import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  'Danh sách bài viết đã lưu',
                  style: AppTextTheme.darkW700TextStyle,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Danh sách bài viết đã lưu không có ',
                  ),
                ),
              )
              // _BookmarkList(),
            ],
          ),
        ),
      ),
    );
  }
}

// class _BookmarkList extends StatelessWidget {
//   const _BookmarkList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//       builder: (context) {
//         final context.
//         return Expanded(
//           child: ListView.separated(
//             padding: const EdgeInsets.only(
//               bottom: 36,
//               // left: 24,
//               // right: 24,
//             ),
//             itemCount: 5,
//             itemBuilder: (context, index) {
//               return const Slidable(
//                 endActionPane: ActionPane(
//                   motion: ScrollMotion(),
//                   children: [],
//                 ),
//                 child: BlogCard(
//                   needMargin: true,
//                   dateAdded: '20 tháng 9, 2022',
//                   author: 'Dungngminh',
//                   title: 'How to make a beautiful widget',
//                   imageUrl: 'https://i.kym-cdn.com/'
//                       'photos/images/facebook/001/839/197/2ad.png',
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) {
//               return const SizedBox(
//                 height: 16,
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

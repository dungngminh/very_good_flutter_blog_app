import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/models/blog_category.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

part 'blog.schema.dart';

@Model()
abstract class Blog {
  @PrimaryKey()
  String get id;

  String get title;

  String get content;

  String get imageUrl;

  @UseConverter(EnumTypeConverter<BlogCategory>(BlogCategory.values))
  BlogCategory get category;

  DateTime get createdAt;

  DateTime get updatedAt;

  User get creator;
  
  bool get isDeleted;
}

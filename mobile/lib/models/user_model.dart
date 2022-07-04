import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app/models/blog_model.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.username,
    this.firstName = '',
    this.lastName = '',
    this.followingCount = 0,
    this.followerCount = 0,
    this.blogCount = 0,
    this.avatarUrl = '',
    this.blogs,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final int followingCount;
  final int followerCount;
  @JsonKey(name: 'num_blog')
  final int blogCount;
  @JsonKey(name: 'avatar')
  final String avatarUrl;
  final List<BlogModel>? blogs;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      username,
      firstName,
      lastName,
      followingCount,
      followerCount,
      blogCount,
      avatarUrl,
      blogs,
    ];
  }

  // @override
  // bool get stringify => true; 
}

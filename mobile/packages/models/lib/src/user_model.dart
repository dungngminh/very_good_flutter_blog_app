import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
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
    this.blogs = const <BlogModel>[],
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
  final List<BlogModel> blogs;

  /// This method used for update user information
  Map<String, dynamic> toJson() => <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatarUrl,
        '_id': id,
        'username': username,
      };

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

  @override
  String toString() {
    return 'UserModel($id, $username)';
  }
}

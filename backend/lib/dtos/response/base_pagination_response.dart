import 'package:json_annotation/json_annotation.dart';

part 'base_pagination_response.g.dart';

@JsonSerializable()
class BasePaginationResponse {
  BasePaginationResponse({
    this.currentPage = 0,
    this.limit = 0,
    this.totalCount = 0,
  });

  factory BasePaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$BasePaginationResponseFromJson(json);
      
  final int currentPage;
  final int limit;
  final int totalCount;

  Map<String, dynamic> toJson() => _$BasePaginationResponseToJson(this);
}

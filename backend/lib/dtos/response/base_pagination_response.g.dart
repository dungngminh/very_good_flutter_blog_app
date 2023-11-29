// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasePaginationResponse _$BasePaginationResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'BasePaginationResponse',
      json,
      ($checkedConvert) {
        final val = BasePaginationResponse(
          currentPage: $checkedConvert('current_page', (v) => v as int? ?? 0),
          limit: $checkedConvert('limit', (v) => v as int? ?? 0),
          totalCount: $checkedConvert('total_count', (v) => v as int? ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {
        'currentPage': 'current_page',
        'totalCount': 'total_count'
      },
    );

Map<String, dynamic> _$BasePaginationResponseToJson(
        BasePaginationResponse instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'limit': instance.limit,
      'total_count': instance.totalCount,
    };

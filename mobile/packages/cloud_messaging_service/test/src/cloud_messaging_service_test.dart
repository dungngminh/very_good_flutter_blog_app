// ignore_for_file: prefer_const_constructors
import 'package:cloud_messaging_service/cloud_messaging_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CloudMessagingService', () {
    test('can be instantiated', () {
      expect(CloudMessagingService(), isNotNull);
    });
  });
}

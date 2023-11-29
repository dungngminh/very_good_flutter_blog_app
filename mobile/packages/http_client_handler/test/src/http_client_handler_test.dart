// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_client_handler/http_client_handler.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_adapter.dart';

class MockHttp extends Mock implements http.Client {}

Uri getUri(String path) {
  return Uri(
    scheme: 'http',
    host: '127.0.0.1',
    path: path,
  );
}

void main() {
  late HttpClientHandler httpClientHandler;
  late http.Client client;
  group('HttpClientHandler', () {
    setUp(
      () {
        client = MockHttp();
        httpClientHandler = HttpClientHandler(
          client: client,
          baseUrl: 'http://127.0.0.1',
        );
      },
    );

    group('contructor', () {
      test('can be instantiated', () {
        expect(httpClientHandler, isNotNull);
      });
    });

    group('methods', () {
      group('GET', () {
        test('should return response body when code 200', () async {
          when(
            () => client.get(getUri('posts')),
          ).thenAnswer(
            (_) async => http.Response(
              fixture('post_fixture.json'),
              HttpStatus.ok,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              },
            ),
          );

          final result = await httpClientHandler.get('posts');
          expect(result, jsonDecode(fixture('post_fixture.json')));
        });

        test('should throws Exception when requested', () {
          when(
            () => client.get(getUri('post')),
          ).thenAnswer(
            (_) async => http.Response(
              fixture('error_fixture.json'),
              HttpStatus.notFound,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              },
            ),
          );

          expect(
            () async => httpClientHandler.get('post'),
            throwsA(isA<NotFoundException>()),
          );
        });
      });

      // TODO(dungngminh): add test in post method
      group('POST', () {
        test('should return Map json from response body when code 201',
            () async {
          when(
            () => client.post(
              getUri('posts'),
              body: <String, dynamic>{
                'id': 2,
                'title': 'json-server',
                'author': 'typicode',
              },
            ),
          ).thenAnswer(
            (_) async => http.Response(
              fixture('post_created_fixture.json'),
              HttpStatus.created,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              },
            ),
          );
          final result = await httpClientHandler.post(
            'posts',
            body: <String, dynamic>{
              'id': 2,
              'title': 'json-server',
              'author': 'typicode',
            },
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          );
          expect(result, jsonDecode(fixture('post_created_fixture.json')));

          // expect(true, true);
        });

        // test('throws Exception when requested', () {
        //   expect(
        //     () async => httpClientHandler.get('post'),
        //     throwsA(isA<NotFoundException>()),
        //   );
        // });
      });
    });
  });
}

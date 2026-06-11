import 'package:crypto_tracker/src/core/error/exceptions.dart';
import 'package:crypto_tracker/src/core/network/api_client.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_global_market_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// A client whose every request is rejected with the given DioException.
  DioApiClient failingWith(DioExceptionType type, {int? status}) {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.reject(
          DioException(
            requestOptions: options,
            type: type,
            response: status == null
                ? null
                : Response(requestOptions: options, statusCode: status),
          ),
        ),
      ),
    );
    return DioApiClient(dio: dio);
  }

  final route = GlobalMarketParams();

  test('connectionError → NetworkException', () {
    final client = failingWith(DioExceptionType.connectionError);
    expect(
      () => client.getRequest(route),
      throwsA(isA<NetworkException>()),
    );
  });

  test('receiveTimeout → NetworkException', () {
    final client = failingWith(DioExceptionType.receiveTimeout);
    expect(
      () => client.getRequest(route),
      throwsA(isA<NetworkException>()),
    );
  });

  test('badResponse 404 → NotFoundException', () {
    final client = failingWith(DioExceptionType.badResponse, status: 404);
    expect(
      () => client.getRequest(route),
      throwsA(isA<NotFoundException>()),
    );
  });

  test('badResponse 500 → ServerException', () {
    final client = failingWith(DioExceptionType.badResponse, status: 500);
    expect(
      () => client.getRequest(route),
      throwsA(isA<ServerException>()),
    );
  });
}

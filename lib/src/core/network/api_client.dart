import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import 'api_router.dart';
import 'http_method.dart';
import 'network_config.dart';

abstract class ApiClient {
  Future<Response<dynamic>> getRequest(
    APIRouter route, {
    CancelToken? cancelToken,
  });

  Future<Response<dynamic>> postRequest(
    APIRouter route, {
    CancelToken? cancelToken,
  });

  Future<Response<dynamic>> putRequest(
    APIRouter route, {
    CancelToken? cancelToken,
  });

  Future<Response<dynamic>> deleteRequest(
    APIRouter route, {
    CancelToken? cancelToken,
  });
}

class DioApiClient implements ApiClient {
  DioApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: NetworkConfig.connectTimeout,
              receiveTimeout: NetworkConfig.receiveTimeout,
              sendTimeout: NetworkConfig.sendTimeout,
              responseType: ResponseType.json,
              headers: NetworkConfig.commonHeaders,
            ),
          );

  final Dio _dio;

  @override
  Future<Response<dynamic>> getRequest(
    APIRouter route, {
    CancelToken? cancelToken,
  }) => _request(HttpMethod.get, route, cancelToken);

  @override
  Future<Response<dynamic>> postRequest(
    APIRouter route, {
    CancelToken? cancelToken,
  }) => _request(HttpMethod.post, route, cancelToken);

  @override
  Future<Response<dynamic>> putRequest(
    APIRouter route, {
    CancelToken? cancelToken,
  }) => _request(HttpMethod.put, route, cancelToken);

  @override
  Future<Response<dynamic>> deleteRequest(
    APIRouter route, {
    CancelToken? cancelToken,
  }) => _request(HttpMethod.delete, route, cancelToken);

  Future<Response<dynamic>> _request(
    HttpMethod method,
    APIRouter route,
    CancelToken? cancelToken,
  ) async {
    // base URL resolved per route, so any endpoint can target a different
    // server later without changing the client.
    _dio.options.baseUrl = route.serverType.baseUrl;
    var attempt = 0;
    while (true) {
      try {
        return await _dio.request<dynamic>(
          route.path,
          data: route.body,
          queryParameters: route.queryParams,
          cancelToken: cancelToken,
          options: Options(method: method.value, headers: route.headers),
        );
      } on DioException catch (e) {
        final isRateLimit = e.response?.statusCode == 429;
        if (isRateLimit && attempt < NetworkConfig.maxRetries) {
          attempt++;
          await Future<void>.delayed(NetworkConfig.retryBackoff * attempt);
          continue;
        }
        throw _mapError(e);
      }
    }
  }

  Exception _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(e.message ?? 'Network timeout.');
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 429) {
          return RateLimitException();
        }
        if (status == 404) {
          return NotFoundException(e.message ?? 'Resource not found.');
        }
        return ServerException(
          e.message ?? 'Request failed.',
          statusCode: status,
          body: e.response?.data,
        );
    }
  }
}

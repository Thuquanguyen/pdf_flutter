import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'http_client.dart';

abstract class ApiProviderRepository {
  Future<Response<T>> getRequest<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool ignoreInvalidToken = false,
  });

  Future<Response<T>> postRequest<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool ignoreInvalidToken = false,
  });

  Future<Response<T>> putRequest<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool ignoreInvalidToken = false,
  });

  Future<Response<T>> deleteRequest<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool ignoreInvalidToken = false,
  });
}

class ApiProviderRepositoryImpl implements ApiProviderRepository {
  ApiProviderRepositoryImpl() {
    _dio = HttpClient.getRepository();
  }

  late final Dio _dio;

  @override
  Future<Response<T>> getRequest<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onReceiveProgress,
    bool ignoreInvalidToken = false,
  }) async {
    try {
      final Response<T> response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options, //buildOptions(options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (e) {
      return e.response as Response<T>;
    }
  }

  @override
  Future<Response<T>> postRequest<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onSendProgress,
    onReceiveProgress,
    bool ignoreInvalidToken = false,
  }) async {
    try {
      final Response<T> response = await _dio.post(
        path,
        data: FormData.fromMap(data!),
        queryParameters: queryParameters,
        options: options,
        //buildOptions(options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

      return response;
    } on DioError catch (e) {
      return e.response as Response<T>;
    }
  }

  @override
  Future<Response<T>> deleteRequest<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool ignoreInvalidToken = false,
  }) async {
    try {
      final Response<T> response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options, //buildOptions(options),
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      return e.response as Response<T>;
    }
  }

  @override
  Future<Response<T>> putRequest<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onSendProgress,
    onReceiveProgress,
    bool ignoreInvalidToken = false,
  }) async {
    try {
      final Response<T> response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        //buildOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (e) {
      return e.response as Response<T>;
    }
  }
}

dynamic getSE(DioError e) {
  if (e.error is SocketException) {
    final errorT = e.error as SocketException;
    if (errorT.osError?.errorCode == 101) {
      return {
        'code': '403',
        'message': 'Có lỗi xảy ra, vui lòng kiểm tra kết nối và thử lại!',
      };
    }
  } else if (e.type == DioErrorType.connectTimeout) {
    return {
      'code': '404',
      'message': 'Có lỗi xảy ra, vui lòng kiểm tra kết nối và thử lại!',
    };
  }
  return null;
}

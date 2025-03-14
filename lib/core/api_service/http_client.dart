import 'package:dio/dio.dart';

import 'intercepter_logging.dart';

class HttpClient {
  HttpClient._internal();

  static HttpClient shared = HttpClient._internal();

  Dio? _repository;

  static Dio getRepository() {
    shared._repository ??= generateRepository();
    return shared._repository!;
  }

  static Dio generateRepository({String? url}) => Dio(
        BaseOptions(
            baseUrl: url ?? '',
            connectTimeout: 45000,
            receiveTimeout: 30000,
            responseType: ResponseType.json,
            headers: {
              Headers.acceptHeader: 'application/json'
            }),
      )..interceptors.add(AppInterceptorLogging());
}

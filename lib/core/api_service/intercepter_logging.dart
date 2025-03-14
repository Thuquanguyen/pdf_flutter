import 'package:dio/dio.dart';

class AppInterceptorLogging extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('*** Request ***\nREQUEST[${options.method}] => ${options.uri}');
    if (options.method == 'POST' || options.method == 'PUT') {
      print('*** PARAMS ***\n' + options.data.toString());
    }
    if (options.method == 'GET') {
      print('*** PARAMS ***\n' + options.queryParameters.toString());
    }
    print('*** HEADERS ***\n' + options.headers.toString());
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '*** Response ***\nRESPONSE[${response.statusCode}] => ${response.realUri}\n${response.data.toString()}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        '*** Error ***\nERROR[${err.response?.data?['code'] ?? err.response?.statusCode}] => ${err.requestOptions.uri} WITH RESPONSE: ${err.response?.data ?? ''}');
    return super.onError(err, handler);
  }
}

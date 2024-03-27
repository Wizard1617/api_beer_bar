import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../interceptors/auth_interceptor.dart'; // Убедитесь, что путь к файлу верный

class CustomDio {
  Dio createDio() {
    Dio dio = Dio();
    dio.interceptors.addAll([
      AuthInterceptor(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
      ),
    ]);
    return dio;
  }
}

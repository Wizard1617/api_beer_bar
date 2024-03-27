import 'package:api_beer_bar/services/api_service.dart';
import 'package:api_beer_bar/services/custom_dio.dart';
import 'package:get_it/get_it.dart';


final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<CustomDio>(CustomDio());
  getIt.registerSingleton<ApiService>(ApiService(getIt<CustomDio>().createDio()));
}

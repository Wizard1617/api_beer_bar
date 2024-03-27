import 'package:api_beer_bar/Models/LoginRequest.dart';
import 'package:api_beer_bar/Models/RegisterRequest.dart';
import 'package:api_beer_bar/Page/beer_list_screen.dart';
import 'package:dio/dio.dart';
import '../Models/Beer.dart';

String api = 'http://192.168.1.68:5248/api';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<String?> login(String email, String password) async {
    final loginRequest = LoginRequest(email: email, password: password);
    try {
      final response = await dio.post(
        '$api/Users/login',
        data: loginRequest.toJson(),
      );
      if (response.statusCode == 200) {
        return response.data; // Возвращаем токен
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> register(String firstName, String lastName, String middleName, String email, String password) async {
    final registerRequest = RegisterRequest(
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      email: email,
      password: password,
    );
    try {
      dio.options.connectTimeout = Duration(seconds: 5);

      final response = await dio.post(
        '$api/Users/register',
        data: registerRequest.toJson(),
      );
      return response.statusCode == 201; // Возвращает true, если пользователь успешно создан
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Beer>> fetchBeers({String strength = 'Все'}) async {
    final response = await dio.get('$api/Beers');
    if (response.statusCode == 200) {
      List jsonResponse = response.data;
      List<Beer> beers = jsonResponse.map((beer) => Beer.fromJson(beer)).toList();
      // Фильтрация по крепкости
      if (strength != 'Все') {
        double lowerBound, upperBound;
        switch (strength) {
          case 'Легкое (до 4.0%)':
            lowerBound = 0.0;
            upperBound = 4.0;
            break;
          case 'Среднее (4.0% - 6.0%)':
            lowerBound = 4.0;
            upperBound = 6.0;
            break;
          case 'Крепкое (6.0% и выше)':
            lowerBound = 6.0;
            upperBound = double.infinity;
            break;
          default:
            lowerBound = 0.0;
            upperBound = double.infinity;
        }
        beers = beers.where((beer) => beer.degrees >= lowerBound && beer.degrees <= upperBound).toList();
      }
      return beers;
    } else {
      throw Exception('Failed to load beers from API');
    }
  }


  Future<bool> deleteBeer(int beerId) async {
    try {
      final response = await dio.delete('$api/Beers/$beerId');
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateBeer(Beer beer) async {
    try {
      final response = await dio.put('$api/Beers/${beer.beerId}', data: beer.toJson());
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }


  Future<bool> addBeer(String name, double volume, String picture, double degrees, String description) async {
    final response = await dio.post(
      '$api/Beers',
      data: {
        'name': name,
        'volume': volume,
        'picture': picture,
        'degrees': degrees,
        'descripion': description,
      },
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }



}

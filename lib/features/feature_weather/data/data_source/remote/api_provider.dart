
import 'package:dio/dio.dart';

import 'package:mini_project_bloc/core/utils/constants.dart';

import '../../../../../core/params/ForecastParams.dart';

class ApiProvider{
  final Dio _dio = Dio();
  var apiKey = Constants.apiKeys1;

  /// current weather api call
  Future<dynamic> callCurrentWeather(cityName) async {
    var response = await _dio.get(
        '${Constants.baseUrl}/data/2.5/weather',
        queryParameters: {
          'q' : cityName,
          'appid' : apiKey,
          'units' : 'metric'
        }
    );
    return response;
  }

  /// 7 days forecast api
  Future<dynamic> sendRequest7DaysForcast(ForecastParams params) async {

    var response = await _dio.get(
        "${Constants.baseUrl}/data/2.5/onecall",
        queryParameters: {
          'lat': params.lat,
          'lon': params.lon,
          'exclude': 'minutely,hourly',
          'appid': apiKey,
          'units': 'metric'
        });

    return response;
  }

  /// city name suggest api
  /// //searchBarMenu
  Future<dynamic> sendRequestCitySuggestion(String prefix) async {
    var response = await _dio.get(
        "http://geodb-free-service.wirefreethought.com/v1/geo/cities",
        //لیمیت میگه 7 تا از اون شهر ها که پیدا کردیم باشه 
        //افست هم میاد اینجا اگر 2بزاریم مثلا میاد  اگر دوتا حرف نداشته باشیم شروع به سرچ کردن نمیکنه  اینجا صفر هست برای این که از ابتدا شروع به سرچ کردن کند
        queryParameters: {'limit': 7, 'offset': 0, 'namePrefix': prefix});

    return response;
  }
}
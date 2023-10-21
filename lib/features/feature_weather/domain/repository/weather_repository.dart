
import 'package:mini_project_bloc/core/resources/data_state.dart';
import 'package:mini_project_bloc/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:mini_project_bloc/features/feature_weather/domain/entities/current_city_entity.dart';

import '../../../../core/params/ForecastParams.dart';
import '../entities/forecase_days_entity.dart';

abstract class WeatherRepository{

  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params);

  Future<List<Data>> fetchSuggestData(cityName);

}
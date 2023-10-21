

import 'package:mini_project_bloc/core/usecase/use_case.dart';
import 'package:mini_project_bloc/features/feature_weather/domain/repository/weather_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../entities/current_city_entity.dart';

class GetCurrentWeatherUseCase extends UseCase<DataState<CurrentCityEntity>, String>{
  final WeatherRepository weatherRepository;
  GetCurrentWeatherUseCase(this.weatherRepository);

  @override
  Future<DataState<CurrentCityEntity>> call(String param) {
      return weatherRepository.fetchCurrentWeatherData(param);
  }

}
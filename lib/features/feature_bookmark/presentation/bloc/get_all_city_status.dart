

import 'package:equatable/equatable.dart';
import '../../domain/entities/city_entity.dart';


//این کلاس کلا گرفتن همه اطلاعات از سمت دیتابیس هست 
abstract class GetAllCityStatus extends Equatable{}

// loading state
class GetAllCityLoading extends GetAllCityStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// loaded state
class GetAllCityCompleted extends GetAllCityStatus{
  final List<City> cities;
  GetAllCityCompleted(this.cities);

  @override
  // TODO: implement props
  List<Object?> get props => [cities];
}

// error state
class GetAllCityError extends GetAllCityStatus{
  final String? message;
  GetAllCityError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
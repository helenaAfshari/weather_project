import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';
import 'package:mini_project_bloc/features/feature_bookmark/presentation/bloc/delete_city_status.dart';
import 'package:mini_project_bloc/features/feature_bookmark/presentation/bloc/get_all_city_status.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/use_cases/delete_city_usecase.dart';
import '../../domain/use_cases/get_all_city_usecase.dart';
import '../../domain/use_cases/get_city_usecase.dart';
import '../../domain/use_cases/save_city_usecase.dart';
import 'get_city_status.dart';
import 'save_city_status.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  GetCityUseCase getCityUseCase;
  SaveCityUseCase saveCityUseCase;
  GetAllCityUseCase getAllCityUseCase;
  DeleteCityUseCase deleteCityUseCase;

  BookmarkBloc(
      this.getCityUseCase,
      this.saveCityUseCase,
      this.getAllCityUseCase,
      this.deleteCityUseCase
      ) : super(BookmarkState(
      getCityStatus: GetCityLoading(),
      saveCityStatus: SaveCityInitial(),
      getAllCityStatus: GetAllCityLoading(),
      deleteCityStatus: DeleteCityInitial(),
  )) {

    /// City Delete Event
    on<DeleteCityEvent>((event, emit) async {
      /// emit Loading state
      emit(state.copyWith(newDeleteCityStatus: DeleteCityLoading()));

      DataState dataState = await deleteCityUseCase(event.name);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newDeleteCityStatus: DeleteCityCompleted(dataState.data)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newDeleteCityStatus: DeleteCityError(dataState.error)));
      }
    });

    /// get All city
    on<GetAllCityEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(newGetAllCityStatus: GetAllCityLoading()));

      DataState dataState = await getAllCityUseCase(NoParams());

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newGetAllCityStatus: GetAllCityCompleted(dataState.data)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newGetAllCityStatus: GetAllCityError(dataState.error)));
      }
    });


    /// get city By name event
    /// /گرفتن یک شهر از دیتابیسمون هست
    on<GetCityByNameEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(newCityStatus: GetCityLoading()));

      DataState dataState = await getCityUseCase(event.cityName);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newCityStatus: GetCityCompleted(dataState.data)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newCityStatus: GetCityError(dataState.error)));
      }
    });


    /// Save City Event
    on<SaveCwEvent>((event, emit) async {

      /// emit Loading state
      /// //اینجا یک مدت زمان کوتاهی طول میکشه که برای اون زمان کوتاه هم باید لودینگ بزاریم
      /// //اینجا هم زمانی که روی بوک مارک میزنیم که ایا اطلاعات موفقیت امیز بود یا نبود ذخیره شد در بوک مارک یا نه از دیتابیس
      emit(state.copyWith(newSaveStatus: SaveCityLoading()));
       
       //اینجا هم میگیم شهر را برای یوزکیس اون شهررا ذخیره کن در داخل یوزکیسمون 
      DataState dataState = await saveCityUseCase(event.name);

      /// emit Complete state
      /// //و اگر همه چی موفقیت امیزبود بیا این قسمت  را اجرا کن
      if(dataState is DataSuccess){
        emit(state.copyWith(newSaveStatus: SaveCityCompleted(dataState.data)));
      }

      /// emit Error state
      /// //اینجا هم به هر دلیلی روی دکمه بوکمارک کلیک کن و به هر دلیلی  این  به ارور خورد و اینجا ارور میخوریم
      if(dataState is DataFailed){
        emit(state.copyWith(newSaveStatus: SaveCityError(dataState.error)));
      }
    });

    /// set to init again SaveCity (برای بار دوم و سوم و غیره باید وضعیت دوباره به حالت اول برگرده وگرنه بوکمارک پر خواهد ماند)
    //اینو نوشتیم برای این که اون ستاره که برای بوکمارک هست برای هرشهری بدونیم پررنگ هست یا خیر
    on<SaveCityInitialEvent>((event, emit) async {
      emit(state.copyWith(newSaveStatus: SaveCityInitial()));
    });

  }
}

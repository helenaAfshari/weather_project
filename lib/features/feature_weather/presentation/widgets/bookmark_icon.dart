
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_bloc/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:mini_project_bloc/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:mini_project_bloc/features/feature_bookmark/presentation/bloc/get_city_status.dart';
import 'package:mini_project_bloc/features/feature_bookmark/presentation/bloc/save_city_status.dart';


class BookMarkIcon extends StatelessWidget {
  final String name;

  const BookMarkIcon({super.key, required this.name});

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<BookmarkBloc,BookmarkState>(
        buildWhen: (previous, current){
          /// if state don't change => don't rebuild UI
          /// //اینجا هم مثلا ببینیم شهر تهران در بوکمارک وجوددارد در صفحهش مثلا تهران در دیتابیسش وجوددارد یا نه 
         //هر زمان که ریبیلد بشه این استاتوسش تغییر میکند 
          if(current.getCityStatus == previous.getCityStatus){
            return false;
          }
          return true;
        },
        builder: (context, state){
          /// initial save Bloc
          /// اینجا از SaveCityInitialEvent
          /// //استفاده کردیم که  روی یک شهر بوکمارک کنیم مثلا تهران سیو سیتی ما میره به حالت کامپلیتد 
         //و بعدش بریم  مثلا شهر لندن را سرچ کنیم  سیوسیتی ما در حالت کاملیتد میماند و این ایکون ما را تو پر میکنه 
         //و استاتوس سیو سیتی خودمون را به حالت اینیشیال ببریم دوباره 
         BlocProvider.of<BookmarkBloc>(context).add(SaveCityInitialEvent());

          /// show Loading for CityStatus
          if(state.getCityStatus is GetCityLoading){
            return const CircularProgressIndicator();
          }

          /// show completed for CityStatus
          if(state.getCityStatus is GetCityCompleted){
              //اینجا هم اگر کامپلیتد شد دریافتش میکنیم گت میکنیم 
            /// casting for Getting city
            final GetCityCompleted getCityCompleted = state.getCityStatus as GetCityCompleted;
            // و اینجا میگیم شهر را بده به ما 
            final City? city = getCityCompleted.city;


/// اینجا هم از کانسیومر هست که هم بیلدر دارد هم لیستنر 
            return BlocConsumer<BookmarkBloc, BookmarkState>(
              listenWhen: (previous, current){
                /// if state don't change => don't listen to changes
                if(current.saveCityStatus == previous.saveCityStatus){
                  return false;
                }
                return true;
              },
              buildWhen: (previous, current){
                /// if state don't change => don't rebuild UI
                if(current.saveCityStatus == previous.saveCityStatus){
                  return false;
                }
                return true;
              },
              listener: (context, cityState) {
                  //چون میخواییم از اسنک بار استفاده کنیم برای همین در لیستنر مینویسیم 
                /// show Error as SnackBar
                if (cityState.saveCityStatus is SaveCityError) {
                  /// cast for getting Error
                  final SaveCityError saveCityError = cityState.saveCityStatus as SaveCityError;

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(saveCityError.message!),
                    behavior: SnackBarBehavior.floating, // Add this line
                  ),);
                }

                /// show Success SnackBar
                if (cityState.saveCityStatus is SaveCityCompleted) {
                  /// cast for getting Data
                  final SaveCityCompleted saveCityCompleted = cityState.saveCityStatus as SaveCityCompleted;

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("${saveCityCompleted.city.name} Added to Bookmark"),
                    behavior: SnackBarBehavior.floating, // Add this line
                  ),);
                }
              },
              builder: (context, cityState) {

                /// show UI for initial SaveCity
                if(cityState.saveCityStatus is SaveCityInitial){
                  return IconButton(
                      onPressed: () {
                        /// call event for save Current City in Database
                        BlocProvider.of<BookmarkBloc>(context).add(SaveCwEvent(name));
                      },
                      icon: Icon(city == null ? Icons.star_border : Icons.star, color: Colors.white, size: height * 0.04,),);
                }

                /// show UI for Loading SaveCity
                if (cityState.saveCityStatus is SaveCityLoading) {
                  return const CircularProgressIndicator();
                }

                /// show UI for Completed or Error SaveCity
                return IconButton(
                    onPressed: () {
                      /// call event for save Current City in Database
                      BlocProvider.of<BookmarkBloc>(context).add(SaveCwEvent(name));
                    },
                    //این شرط برای توخالی و توپر بودن اون بوکمارک هست 
                    icon: const Icon(Icons.star, color: Colors.white, size: 35,),);

              },
            );
          }

          /// show Error for CityStatus
          if(state.getCityStatus is GetCityError){
            return IconButton(
                onPressed: (){
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text("please load a city!"),
                  //   behavior: SnackBarBehavior.floating, // Add this line
                  // ));
                },
                icon: const Icon(Icons.error,color: Colors.white,size: 35),);
          }

          /// default value
          return Container();
        },
    );
  }
}

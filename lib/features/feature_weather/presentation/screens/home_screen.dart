
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mini_project_bloc/core/params/ForecastParams.dart';
import 'package:mini_project_bloc/core/utils/date_converter.dart';
import 'package:mini_project_bloc/core/widgets/app_background.dart';
import 'package:mini_project_bloc/features/feature_weather/domain/use_cases/get_suggestion_city_usecase.dart';
import 'package:mini_project_bloc/locator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import '../../../../core/widgets/dot_loading_widget.dart';
import '../../../feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import '../../data/models/ForcastDaysModel.dart';
import '../../data/models/suggest_city_model.dart';
import '../../domain/entities/current_city_entity.dart';
import '../../domain/entities/forecase_days_entity.dart';
import '../bloc/cw_status.dart';
import '../bloc/fw_status.dart';
import '../bloc/home_bloc.dart';
import '../widgets/bookmark_icon.dart';
import '../widgets/day_weather_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//از این میکسین استفاده کردیم برای این که اگر رفت در داخل بوکمارک خواست برگرده دوباره به همین کلاس لودینگ را نمایش نده از اول 
//صفحه ما فریز میماند
class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin{
  TextEditingController textEditingController = TextEditingController();

  GetSuggestionCityUseCase getSuggestionCityUseCase = GetSuggestionCityUseCase(locator());

  String cityName = "Tehran";
  final PageController _pageController = PageController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }


  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.02,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Row(
                children: [
                  /// search box
                  Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          //کار این سابمیتد این هست که یک زمانی بخواییم زمانی که کیبورد گوشی باز میشه روی اکی کلیک کنیم از کیبورد هم بخونه
                          onSubmitted: (String prefix) {
                            textEditingController.text = prefix;
                            BlocProvider.of<HomeBloc>(context)
                                .add(LoadCwEvent(prefix));
                          },
                          controller: textEditingController,
                          style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            hintText: "Enter a City...",
                            hintStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),),
                          //این میاد هر تغییری که روی تکس فیلد خودمون انجام بدیم میاد یک پریفیکس میده که دریافت کردیم
                          //
                        suggestionsCallback: (String prefix){
                          //یعنی هرتغییری که به ما بده این کال بک  اعمال میکنیم و میفرسته برای 
                          //useCase
                          //میگیم برو api را کال کن 
                          return getSuggestionCityUseCase(prefix);
                        },
                        //در اینجا این دیتا همون مدل 
                        //sugesterCity ما هست
                        itemBuilder: (context, Data model){
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            //نام شهر هست 
                            title: Text(model.name!),
                            //اینجا هم اومدیم رجیون و کانتری را  پایین تایتل دریافت کردیم 
                            subtitle: Text("${model.region!}, ${model.country!}"),
                          );
                        },

                        onSuggestionSelected: (Data model){
                          //اینجا مودل را نوشتیم که نام را بگیریم زمانی که میزنیم تهران داخل تکس فیلد بنویسه تهران رو 
                          textEditingController.text = model.name!;
                          //اینجا هم میاییم اب و هوا شهر جدید را میگیریم 
                          //api خودمون را کال میکنیم
                          //اینجا نام شهرمون را بهش ارسال میکنیم
                          //وداخل بلاک بیلدر دوباره ریبیلد میشه و شهرمون را میاره 
                          //چون در homeBloc هست 
                          BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(model.name!));
                        }
                    ),
                  ),

                  const SizedBox(width: 10,),
                  // اینجا میاد ریبیلد میکنه
                  BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current){
                        if(previous.cwStatus == current.cwStatus){
                          return false;
                        }
                        return true;
                      },
                      builder: (context, state){
                        /// show Loading State for Cw
                        if (state.cwStatus is CwLoading) {
                          return const CircularProgressIndicator();
                        }

                        /// show Error State for Cw
                        if (state.cwStatus is CwError) {
                          return IconButton(
                            onPressed: (){
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //   content: Text("please load a city!"),
                              //   behavior: SnackBarBehavior.floating, // Add this line
                              // ));
                            },
                            icon: const Icon(Icons.error,color: Colors.white,size: 35),);
                        }
                         //اینجا کلا از بوکمارک استفاده کردیم که در حالت لودینگ رفت در اون حالت باشد کل صفحه بوکمارکمون هم درحالت لودینگ بره 
                        if(state.cwStatus is CwCompleted){
                          //اینجا اطلاعات که گرفتیم
                          final CwCompleted cwComplete = state.cwStatus as CwCompleted;
                           //getCityByName
                           //کارش این هست که بره ببینه ایا اون  شهری که براش ارسال کردیم در  بوکمارک ما هست یاخیر از دیتابیس
                         // اون شهر تو دیتابیس ما وجوددارد  یا خیر
                          BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwComplete.currentCityEntity.name!));
                          // که کلاس بوکمارک هستاینجا هم میگیم که نام شهری که میخواییم را ارسال میکنیم براش و یک ایکون بوکمارک هم نمایش داده میشه
                          return BookMarkIcon(name: cwComplete.currentCityEntity.name!);
                        }

                        return Container();

                      }
                  ),
                ],
              ),
            ),

            /// main UI
            BlocBuilder<HomeBloc,HomeState>(
                buildWhen: (previous, current){
                  /// rebuild just when CwStatus Changed
                  if(previous.cwStatus == current.cwStatus){
                    return false;
                  }
                  return true;
                },
              builder: (context, state){

                if(state.cwStatus is CwLoading){
                  return const Expanded(child: DotLoadingWidget());
                }

                if(state.cwStatus is CwCompleted){

                  /// cast
                  final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                  final CurrentCityEntity currentCityEntity = cwCompleted.currentCityEntity;

                  /// create params for api call
                  /// //get lat and lon
                  //طول و عرض جغرافیاییی را بهمون میده
                  // اینجا این وابسته به api بالایی هست که میگیره مثلا تهران رو و طول و عرض جغرافیایی رو میده و نمایش میده 
                  //برای همین داخل همین  completed نوشتیم
                  final ForecastParams forecastParams = ForecastParams(currentCityEntity.coord!.lat!, currentCityEntity.coord!.lon!);

                  // میاییم api دوم را هم کال میکنیم
                  /// start load Fw event
                  BlocProvider.of<HomeBloc>(context).add(LoadFwEvent(forecastParams));


                  /// change Times to Hour --5:55 AM/PM----
                  /// //timeZone
                  /// //فاصله زمانی اون شهر  مدنظرمون با تایم یو تی سی باید سان رایز رو به اضافه فاصله زمانی اون زونمون کنیم
                  /// //که ساعت غروب و طلوع افتاب دقیق اون شهر بدست بیاد
                  final sunrise = DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunrise,currentCityEntity.timezone);
                  final sunset =  DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunset,currentCityEntity.timezone);

                  return Expanded(
                      child: ListView(
                        children: [

                          Padding(
                              padding: EdgeInsets.only(top: height * 0.02),
                              child: SizedBox(
                                width: width,
                                height: 400,
                                child: PageView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  allowImplicitScrolling: true,
                                  controller: _pageController,
                                  itemCount: 2,
                                  itemBuilder: (context, position) {
                                    if (position == 0) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 50),
                                            child: Text(
                                              currentCityEntity.name!,
                                              style: const TextStyle(fontSize: 30,color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Text(
                                              currentCityEntity.weather![0].description!,
                                              style: const TextStyle(fontSize: 20,color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: AppBackground.setIconForMain(currentCityEntity.weather![0].description!),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Text(
                                              "${currentCityEntity.main!.temp!.round()}\u00B0",
                                              style: const TextStyle(fontSize: 50,color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              /// max temp
                                              Column(
                                                children: [
                                                  const Text(
                                                    "max",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,),
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Text("${currentCityEntity.main!.tempMax!.round()}\u00B0",
                                                    style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,),)
                                                ],
                                              ),

                                              /// divider
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10,),
                                                child: Container(
                                                  color: Colors.grey,
                                                  width: 2,
                                                  height: 40,
                                                ),
                                              ),

                                              /// min temp
                                              Column(
                                                children: [
                                                  const Text(
                                                    "min",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,),
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Text("${currentCityEntity.main!.tempMin!.round()}\u00B0",
                                                    style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,),)
                                                ],
                                              ),
                                            ],
                                          )

                                        ],
                                      );
                                    } else {
                                      return Container(
                                        color: Colors.amber,
                                      );
                                    }
                                  },),
                              ),
                          ),

                          const SizedBox(height: 10,),
                          /// pageView Indicator
                          Center(
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              // PageController
                              count: 2,
                              effect: const ExpandingDotsEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                spacing: 5,
                                activeDotColor: Colors.white,),
                              // your preferred effect
                              onDotClicked: (index) =>
                                  _pageController.animateToPage(index,
                                    duration: const Duration(microseconds: 500),
                                    curve: Curves.bounceOut,),),
                          ),

                          /// divider
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              color: Colors.white24,
                              height: 2,
                              width: double.infinity,
                            ),
                          ),

                          /// forecast weather 7 days
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: SizedBox(
                              width: double.infinity,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Center(
                                  child: BlocBuilder<HomeBloc, HomeState>(
                                    builder: (BuildContext context, state) {

                                      /// show Loading State for Fw
                                      if (state.fwStatus is FwLoading) {
                                        return const DotLoadingWidget();
                                      }

                                      /// show Completed State for Fw
                                      if (state.fwStatus is FwCompleted) {
                                        /// casting
                                        final FwCompleted fwCompleted = state.fwStatus as FwCompleted;
                                        final ForecastDaysEntity forecastDaysEntity = fwCompleted.forecastDaysEntity;
                                        final List<Daily> mainDaily = forecastDaysEntity.daily!;

                                        return ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 8,
                                          itemBuilder: (BuildContext context,
                                              int index,) {
                                            return DaysWeatherView(
                                              daily: mainDaily[index],);
                                          },);
                                      }

                                      /// show Error State for Fw
                                      if (state.fwStatus is FwError) {
                                        final FwError fwError = state.fwStatus as FwError;
                                        return Center(
                                          child: Text(fwError.message!),
                                        );
                                      }

                                      /// show Default State for Fw
                                      return Container();

                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// divider
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              color: Colors.white24,
                              height: 2,
                              width: double.infinity,
                            ),
                          ),

                          SizedBox(height: 30,),

                          /// last Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text("wind speed",
                                    style: TextStyle(
                                      fontSize: height * 0.017, color: Colors.amber,),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "${currentCityEntity.wind!.speed!} m/s",
                                      style: TextStyle(
                                        fontSize: height * 0.016,
                                        color: Colors.white,),),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  color: Colors.white24,
                                  height: 30,
                                  width: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: [
                                    Text("sunrise",
                                      style: TextStyle(
                                        fontSize: height * 0.017,
                                        color: Colors.amber,),),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 10.0),
                                      child: Text(sunrise,
                                        style: TextStyle(
                                          fontSize: height * 0.016,
                                          color: Colors.white,),),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  color: Colors.white24,
                                  height: 30,
                                  width: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(children: [
                                  Text("sunset",
                                    style: TextStyle(
                                      fontSize: height * 0.017, color: Colors.amber,),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(sunset,
                                      style: TextStyle(
                                        fontSize: height * 0.016,
                                        color: Colors.white,),),
                                  ),
                                ],),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  color: Colors.white24,
                                  height: 30,
                                  width: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(children: [
                                  Text("humidity",
                                    style: TextStyle(
                                      fontSize: height * 0.017, color: Colors.amber,),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      //humity
                                      //رطوبت هوا هست
                                      "${currentCityEntity.main!.humidity!}%",
                                      style: TextStyle(
                                        fontSize: height * 0.016,
                                        color: Colors.white,),),
                                  ),
                                ],),
                              ),
                            ],),

                          SizedBox(height: 30,),

                        ],
                      )
                  );
                }

                if(state.cwStatus is CwError){
                  return const Center(child: Text('error',style: TextStyle(color: Colors.white),),);
                }

                return Container();
              },
            ),

          ],
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

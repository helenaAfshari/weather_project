part of 'bookmark_bloc.dart';

@immutable
abstract class BookmarkEvent {}

//این برای این هست که کل لیست  شهرهایی که ذخیره شدن در داخل دیتابیس نام شهر هارا دریافت میکنیم 
class GetAllCityEvent extends BookmarkEvent {}

class GetCityByNameEvent extends BookmarkEvent {
  final String cityName;
  GetCityByNameEvent(this.cityName);
}

//این برای سیو کردن شهر هست
class SaveCwEvent extends BookmarkEvent {
  final String name;
  SaveCwEvent(this.name);
}

//این هم استاتوس مارا به حالت  اینیشیال میبره 
class SaveCityInitialEvent extends BookmarkEvent {}


//اینجا هم زمانی که بخواییم یک شهررا حذف کنیم از داخل دیتابیسمون
class DeleteCityEvent extends BookmarkEvent {
  final String name;
  DeleteCityEvent(this.name);
}
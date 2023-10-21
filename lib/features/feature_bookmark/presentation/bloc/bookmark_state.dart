part of 'bookmark_bloc.dart';

class BookmarkState extends Equatable{
  final GetCityStatus getCityStatus;
  final SaveCityStatus saveCityStatus;
  final GetAllCityStatus getAllCityStatus;
  final DeleteCityStatus deleteCityStatus;

  const BookmarkState({
    required this.getCityStatus,
    required this.saveCityStatus,
    required this.getAllCityStatus,
    required this.deleteCityStatus,
  });

  BookmarkState copyWith({
    GetCityStatus? newCityStatus,
    SaveCityStatus? newSaveStatus,
    GetAllCityStatus? newGetAllCityStatus,
    DeleteCityStatus? newDeleteCityStatus,
}){
    return BookmarkState(
      //اینجا هم میگیم اگر نال بود سیوسیتی استاتوس قبلی را بزار
        getCityStatus: newCityStatus ?? getCityStatus,
        saveCityStatus: newSaveStatus ?? saveCityStatus,
        //اینجا میگیم getAllCityStatuse
        //باشد newGetAllCity یعنی جدید را بریز داخلش 
        //در غیر اینصورت  همون قدیمی را بریز داخلش به اسم getAllCityStatus
        //در کل میگیم این گت اول سیتی استاتوس  اگر این نیو یا جدید چیزی داشت در داخل خودش بیا همین نیو جدید را ارسال کن اگر نداشت چیزی در داخل خودش بیا همون قبلی رو ارسال کن
        getAllCityStatus: newGetAllCityStatus ?? getAllCityStatus,
        deleteCityStatus: newDeleteCityStatus ?? deleteCityStatus,
    );
  }

//داخل این پراپس قرار دادیم برای این که برای مقایسه به همشون نیاز داریم برای مقایسه بوکمارک استیت
  @override
  // TODO: implement props
  List<Object?> get props => [
    getCityStatus,
    saveCityStatus,
    getAllCityStatus,
    deleteCityStatus
  ];
}
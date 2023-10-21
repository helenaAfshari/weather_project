
import 'package:floor/floor.dart';
import 'package:mini_project_bloc/features/feature_bookmark/domain/entities/city_entity.dart';

//این کلاس dao
//ارتباط بین انتیتی و دیتابیس ما هست
//به دیتابیس کویری میزنم و مثلا چه دیتایی ازش بگیرم  و داخل  مثلا متغیر ذخیره میکند  و میفرستیم سمت  اسکرین یا ui
@dao
abstract class CityDao {
  //لیستی از city برمیگرداند
  //همه ردیف هارا میاره برای ما
  @Query('SELECT * FROM City')
  Future<List<City>> getAllCity();

// اینجا هم میاد تمام city
//شهر مارا میدهد کجا نامش که برابر نام این اسم هست فقط نامش را میده به ما
  @Query('SELECT * FROM City WHERE name = :name')
  Future<City?> findCityByName(String name);

// این گزینه اینسرت شی از شهر خودمون را ارسال میکنیم براش 
//و از نوع void
//برمیگرداند فقط شهر را میدهد به ما
  @insert
  Future<void> insertCity(City city);
  
  //اینجا هم نام را ارسال میکنیم میره هرجا نامی که مساوی با  با نام شهر انتیتی ما بود میاد اون ردیف را برای ما حذف میکند
  @Query('DELETE FROM City WHERE name = :name')
  Future<void> deleteCityByName(String name);
}
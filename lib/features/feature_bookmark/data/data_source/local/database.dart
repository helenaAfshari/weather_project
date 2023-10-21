import 'dart:async';
import 'package:floor/floor.dart';

import 'package:mini_project_bloc/features/feature_bookmark/data/data_source/local/city_dao.dart';
import 'package:mini_project_bloc/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'database.g.dart'; // the generated code will be there

//کلاس دیتابیسمون هست 
//ورژن دیتابیسمون یک هست 
//و انتیتی هایی که این دیتابیسمون ازش داره استفاده میکنه اینجا سیتی یا شهر هست فقط
//اینجا هم کلاس دیتابیسمون هست حتما نوشته میشود دیتابیس
@Database(version: 1, entities: [City])
abstract class AppDatabase extends FloorDatabase {
  CityDao get cityDao;
}
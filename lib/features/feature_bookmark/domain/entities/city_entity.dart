
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

//چون این کلاس انتیتی هست حتما باید بزاریم
@entity
//اینجا  اومدیم از equtable 
//استفاده کردیم برای این که زمانی که میخواییم تست بنویسیم برای کلاسمون خیلی کارمون را راحت تر میکنه در غیر اینصورت هم میتونیم  ننویسیم
//ولی برای تست نویسی حتما نیاز هست به اکوتیبل

class City extends Equatable {

  @PrimaryKey(autoGenerate: true)
  int? id;
  //نام شهر هست
  final String name;
  //اینجا چون ایدی اتوجنریت هست خودش جنریت میکنه ولی نام را میدم جون اتو جنریت نباید باشه
  City({required this.name});

  @override
  List<Object?> get props => [name];
}
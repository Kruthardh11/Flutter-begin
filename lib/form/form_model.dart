import 'package:hive/hive.dart';

part 'form_model.g.dart';

@HiveType(typeId: 0)
class FormModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String city;

  @HiveField(3)
  String age;

  @HiveField(4)
  String password;

  @HiveField(5)
  String gender;

  @HiveField(6)
  List favSport;

  FormModel(
      {required this.name,
      required this.age,
      required this.city,
      required this.email,
      required this.gender,
      required this.favSport,
      required this.password});
}

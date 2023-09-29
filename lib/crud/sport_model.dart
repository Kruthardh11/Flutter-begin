import 'package:hive/hive.dart';

part 'sport_model.g.dart';

@HiveType(typeId: 0)
class SportModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String player;

  @HiveField(2)
  String team;

  SportModel({required this.name, required this.player, required this.team});
}

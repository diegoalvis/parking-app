import 'package:json_annotation/json_annotation.dart';

part 'schedules.g.dart';

@JsonSerializable(nullable: true)
class Schedules {
  int id;
  String type;
  int mo;
  int tu;
  int we;
  int th;
  int fr;
  int sa;
  int su;
  int initTime;
  int endTime;

  Schedules({this.id, this.type, this.mo, this.tu, this.we, this.th, this.fr, this.sa, this.su, this.initTime, this.endTime});

  factory Schedules.fromJson(Map<String, dynamic> json) => _$SchedulesFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulesToJson(this);
}

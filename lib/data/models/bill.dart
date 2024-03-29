import 'package:json_annotation/json_annotation.dart';

part 'bill.g.dart';

@JsonSerializable(nullable: true)
class ZoneBill{
  String idZone;
  String code;
  String name;
  int cell;

  ZoneBill({this.idZone, this.code, this.cell, this.name});

  factory ZoneBill.fromJson(Map<String, dynamic> json) => _$ZoneBillFromJson(json);
  Map<String, dynamic> toJson() => _$ZoneBillToJson(this);
}

@JsonSerializable(nullable: true)
class Bill{
  DateTime createdAt;
  String vehiclePlate;
  String type;
  int value;
  ZoneBill zone;
  int time;


  Bill({this.createdAt, this.vehiclePlate, this.type, this.value, this.zone, this.time});

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
  Map<String, dynamic> toJson() => _$BillToJson(this);
}

@JsonSerializable(nullable: true)
class Debt{
  DateTime createdAt;
  String vehiclePlate;
  int value;
  ZoneBill zone;

  Debt({this.createdAt, this.vehiclePlate, this.value, this.zone});

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);
  Map<String, dynamic> toJson() => _$DebtToJson(this);
}
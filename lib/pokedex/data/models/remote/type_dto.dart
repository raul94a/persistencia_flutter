import 'dart:convert';

import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';

class TypeDto {
  final int id;
  final String name;
  final DamageRelations damageRelations;

  TypeDto({
    required this.id,
    required this.name,
    required this.damageRelations,
  });

  TypeDto copyWith({
    int? id,
    String? name,
    DamageRelations? damageRelations,
  }) =>
      TypeDto(
        id: id ?? this.id,
        name: name ?? this.name,
        damageRelations: damageRelations ?? this.damageRelations,
      );

  factory TypeDto.fromRawJson(String str) => TypeDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TypeDto.fromJson(Map<String, dynamic> json) => TypeDto(
        id: json["id"],
        name: json["name"],
        damageRelations: DamageRelations.fromJson(json["damage_relations"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "damage_relations": damageRelations.toJson(),
      };
}

class DamageRelations {
  final List<NameInfo> noDamageTo;
  final List<NameInfo> halfDamageTo;
  final List<NameInfo> doubleDamageTo;
  final List<NameInfo> noDamageFrom;
  final List<NameInfo> halfDamageFrom;
  final List<NameInfo> doubleDamageFrom;

  DamageRelations({
    required this.noDamageTo,
    required this.halfDamageTo,
    required this.doubleDamageTo,
    required this.noDamageFrom,
    required this.halfDamageFrom,
    required this.doubleDamageFrom,
  });

  DamageRelations copyWith({
    List<NameInfo>? noDamageTo,
    List<NameInfo>? halfDamageTo,
    List<NameInfo>? doubleDamageTo,
    List<NameInfo>? noDamageFrom,
    List<NameInfo>? halfDamageFrom,
    List<NameInfo>? doubleDamageFrom,
  }) =>
      DamageRelations(
        noDamageTo: noDamageTo ?? this.noDamageTo,
        halfDamageTo: halfDamageTo ?? this.halfDamageTo,
        doubleDamageTo: doubleDamageTo ?? this.doubleDamageTo,
        noDamageFrom: noDamageFrom ?? this.noDamageFrom,
        halfDamageFrom: halfDamageFrom ?? this.halfDamageFrom,
        doubleDamageFrom: doubleDamageFrom ?? this.doubleDamageFrom,
      );

  factory DamageRelations.fromRawJson(String str) =>
      DamageRelations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DamageRelations.fromJson(Map<String, dynamic> json) =>
      DamageRelations(
        noDamageTo: List<NameInfo>.from(
            json["no_damage_to"].map((x) => NameInfo.fromJson(x))),
        halfDamageTo: List<NameInfo>.from(
            json["half_damage_to"].map((x) => NameInfo.fromJson(x))),
        doubleDamageTo: List<NameInfo>.from(
            json["double_damage_to"].map((x) => NameInfo.fromJson(x))),
        noDamageFrom: List<NameInfo>.from(
            json["no_damage_from"].map((x) => NameInfo.fromJson(x))),
        halfDamageFrom: List<NameInfo>.from(
            json["half_damage_from"].map((x) => NameInfo.fromJson(x))),
        doubleDamageFrom: List<NameInfo>.from(
            json["double_damage_from"].map((x) => NameInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "no_damage_to": List<dynamic>.from(noDamageTo.map((x) => x.toJson())),
        "half_damage_to":
            List<dynamic>.from(halfDamageTo.map((x) => x.toJson())),
        "double_damage_to":
            List<dynamic>.from(doubleDamageTo.map((x) => x.toJson())),
        "no_damage_from":
            List<dynamic>.from(noDamageFrom.map((x) => x.toJson())),
        "half_damage_from":
            List<dynamic>.from(halfDamageFrom.map((x) => x.toJson())),
        "double_damage_from":
            List<dynamic>.from(doubleDamageFrom.map((x) => x.toJson())),
      };
}

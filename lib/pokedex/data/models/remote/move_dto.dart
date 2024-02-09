
import 'dart:convert';

import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';

class MoveDto {
  final int id;
  final String name;
  final int? accuracy;

  final int? pp;

  final int? power;

  final NameInfo type;

  MoveDto({
    required this.id,
    required this.name,
    required this.accuracy,
    required this.pp,
    required this.power,
    required this.type,
  });

  MoveDto copyWith({
    int? id,
    String? name,
    int? accuracy,
    dynamic effectChance,
    int? pp,
    int? priority,
    int? power,
   
    NameInfo? contestType,
   
    NameInfo? damageClass,

    List<dynamic>? effectChanges,
    NameInfo? generation,
  
    List<dynamic>? pastValues,
    List<dynamic>? statChanges,
  
    NameInfo? target,
    NameInfo? type,
    List<NameInfo>? learnedByPokemon,

  }) =>
      MoveDto(
        id: id ?? this.id,
        name: name ?? this.name,
        accuracy: accuracy ?? this.accuracy,
        pp: pp ?? this.pp,
        power: power ?? this.power,
        type: type ?? this.type,
      );

  factory MoveDto.fromRawJson(String str) => MoveDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MoveDto.fromJson(Map<String, dynamic> json) => MoveDto(
        id: json["id"],
        name: json["name"],
        accuracy: json["accuracy"],
        pp: json["pp"],
        power: json["power"],
        type: NameInfo.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "accuracy": accuracy,
        "pp": pp,
        "power": power,
        "type": type.toJson()
      };
}



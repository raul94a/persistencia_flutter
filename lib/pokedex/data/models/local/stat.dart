import 'dart:convert';

import 'package:persistencia_flutter/core/extensions/string_extensions.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';

class BaseStat {
  final int baseStat;
  final String name;
  BaseStat({
    required this.baseStat,
    required this.name,
  });

  bool isLowBaseStat() => baseStat < 50;
  double get fraction => baseStat / 255;
  String maybeGetShorterName() {
    if (name == 'special-attack') {
      return 'Sp. Atk';
    }
    if (name == 'special-defense') {
      return 'Sp. Def';
    }
    return name.capitalizeFirst();
  }

  BaseStat copyWith({
    int? baseStat,
    String? name,
  }) {
    return BaseStat(
      baseStat: baseStat ?? this.baseStat,
      name: name ?? this.name,
    );
  }

  @override
  int get hashCode => baseStat.hashCode ^ name.hashCode;
}

class StatEntity {
  final int id;
  final int speed;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  StatEntity({
    required this.id,
    required this.speed,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
  });

  factory StatEntity.fromDto(List<StatDto> stats, int id) {
    var statEntity = StatEntity(
        id: id,
        speed: 0,
        hp: 0,
        attack: 0,
        defense: 0,
        specialAttack: 0,
        specialDefense: 0);
    for (final dto in stats) {
      switch (dto.stat.name) {
        case "hp":
          statEntity = statEntity.copyWith(hp: dto.baseStat);
          break;
        case "attack":
          statEntity = statEntity.copyWith(attack: dto.baseStat);
          break;
        case "defense":
          statEntity = statEntity.copyWith(defense: dto.baseStat);
          break;
        case "special-attack":
          statEntity = statEntity.copyWith(specialAttack: dto.baseStat);
          break;
        case "special-defense":
          statEntity = statEntity.copyWith(specialDefense: dto.baseStat);
          break;
        case "speed":
          statEntity = statEntity.copyWith(speed: dto.baseStat);
          break;
      }
    }
    return statEntity;
  }

  List<BaseStat> toBaseStats() {
    final map = toMap();
    map.remove('id');
    final keys = map.keys;
    return keys
        .map((e) => BaseStat(baseStat: map[e], name: maybeGetShorterName(e)))
        .toList();
  }

  String maybeGetShorterName(String name) {
    if (name == 'special_attack') {
      return 'Sp. Atk';
    }
    if (name == 'special_defense') {
      return 'Sp. Def';
    }
    return name.capitalizeFirst();
  }

  StatEntity copyWith({
    int? id,
    int? speed,
    int? hp,
    int? attack,
    int? defense,
    int? specialAttack,
    int? specialDefense,
  }) {
    return StatEntity(
      id: id ?? this.id,
      speed: speed ?? this.speed,
      hp: hp ?? this.hp,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      specialAttack: specialAttack ?? this.specialAttack,
      specialDefense: specialDefense ?? this.specialDefense,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'speed': speed,
      'hp': hp,
      'attack': attack,
      'defense': defense,
      'special_attack': specialAttack,
      'special_defense': specialDefense,
    };
  }

  factory StatEntity.fromMap(Map<String, dynamic> map) {
    return StatEntity(
      id: map['id']?.toInt() ?? 0,
      speed: map['speed']?.toInt() ?? 0,
      hp: map['hp']?.toInt() ?? 0,
      attack: map['attack']?.toInt() ?? 0,
      defense: map['defense']?.toInt() ?? 0,
      specialAttack: map['special_attack']?.toInt() ?? 0,
      specialDefense: map['special_defense']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatEntity.fromJson(String source) =>
      StatEntity.fromMap(json.decode(source));
}

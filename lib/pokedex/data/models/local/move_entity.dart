import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/move_dto.dart';

class MoveEntity {
  final int id;
  final String name;
  final int? accuracy;
  final int? pp;
  final int? power;
  final String type;
  MoveEntity({
    required this.id,
    required this.name,
    this.accuracy,
    this.pp,
    this.power,
    required this.type,
  });

  MoveEntity copyWith({
    int? id,
    String? name,
    int? accuracy,
    int? pp,
    int? power,
    String? type,
  }) {
    return MoveEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      accuracy: accuracy ?? this.accuracy,
      pp: pp ?? this.pp,
      power: power ?? this.power,
      type: type ?? this.type,
    );
  }

  factory MoveEntity.fromDto(MoveDto dto) => MoveEntity(
      id: dto.id,
      name: dto.name,
      type: dto.type.name,
      power: dto.power,
      accuracy: dto.accuracy,
      pp: dto.pp);
      
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'accuracy': accuracy,
      'pp': pp,
      'power': power,
      'type': type,
    };
  }

  factory MoveEntity.fromMap(Map<String, dynamic> map) {
    return MoveEntity(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      accuracy: map['accuracy'],
      pp: map['pp']?.toInt(),
      power: map['power']?.toInt(),
      type: map['type'] ?? '',
    );
  }

  @override
  String toString() {
    return 'MoveEntity(id: $id, name: $name, accuracy: $accuracy, pp: $pp, power: $power, type: $type)';
  }
}

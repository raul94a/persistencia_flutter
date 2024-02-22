import 'dart:convert';

import 'package:persistencia_flutter/pokedex/data/models/remote/type_dto.dart';

class TypeEntity {
  final String name;
  final int slot;
  final DamageRelationEntity? damageRelation;

  TypeEntity({this.damageRelation, required this.name, this.slot = 0});

  factory TypeEntity.fromTypeDto(TypeDto dto) {
    return TypeEntity(
        name: dto.name,
        damageRelation: DamageRelationEntity.fromDto(dto.damageRelations));
  }

  TypeEntity copyWith({
    int? slot,
    String? name,
    DamageRelationEntity? damageRelation,
  }) {
    return TypeEntity(
      slot: slot ?? this.slot,
      name: name ?? this.name,
      damageRelation: damageRelation ?? this.damageRelation,
    );
  }
}

class DamageRelationEntity {
  final List<TypeEntity> doubleDamageFrom;
  final List<TypeEntity> doubleDamageTo;
  final List<TypeEntity> halfDamageTo;
  final List<TypeEntity> halfDamageFrom;
  final List<TypeEntity> noDamageFrom;
  final List<TypeEntity> noDamageTo;
  DamageRelationEntity({
    required this.doubleDamageFrom,
    required this.doubleDamageTo,
    required this.halfDamageTo,
    required this.halfDamageFrom,
    required this.noDamageFrom,
    required this.noDamageTo,
  });

  factory DamageRelationEntity.fromDto(DamageRelations dto) {
    return DamageRelationEntity(
        doubleDamageFrom:
            dto.doubleDamageFrom.map((e) => TypeEntity(name: e.name)).toList(),
        doubleDamageTo:
            dto.doubleDamageTo.map((e) => TypeEntity(name: e.name)).toList(),
        halfDamageTo:
            dto.halfDamageTo.map((e) => TypeEntity(name: e.name)).toList(),
        halfDamageFrom:
            dto.halfDamageFrom.map((e) => TypeEntity(name: e.name)).toList(),
        noDamageFrom:
            dto.noDamageFrom.map((e) => TypeEntity(name: e.name)).toList(),
        noDamageTo:
            dto.noDamageTo.map((e) => TypeEntity(name: e.name)).toList());
  }
}

class DamageCoefficients {
  double coefficient = 1;
  String type = 'normal';
  DamageCoefficients(this.coefficient, this.type);
  @override
  String toString() =>
      'DamageCoefficients(coefficient: $coefficient, type: $type)';
}

class TypeDoubleDamageEntity {
  final String type;
  final String affectedType;
  TypeDoubleDamageEntity({
    required this.type,
    required this.affectedType,
  });
  static const coefficient = 2.0;

  TypeDoubleDamageEntity copyWith({
    String? type,
    String? affectedType,
  }) {
    return TypeDoubleDamageEntity(
      type: type ?? this.type,
      affectedType: affectedType ?? this.affectedType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'affected_type': affectedType,
      'coefficient': coefficient,
    };
  }

  factory TypeDoubleDamageEntity.fromMap(Map<String, dynamic> map) {
    return TypeDoubleDamageEntity(
      type: map['type'] ?? '',
      affectedType: map['affected_type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeDoubleDamageEntity.fromJson(String source) =>
      TypeDoubleDamageEntity.fromMap(json.decode(source));
}

class TypeHalfDamageEntity {
  final String type;
  final String affectedType;
  TypeHalfDamageEntity({
    required this.type,
    required this.affectedType,
  });
  static const coefficient = 0.5;

  TypeHalfDamageEntity copyWith({
    String? type,
    String? affectedType,
  }) {
    return TypeHalfDamageEntity(
      type: type ?? this.type,
      affectedType: affectedType ?? this.affectedType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'affected_type': affectedType,
      'coefficient': coefficient,
    };
  }

  factory TypeHalfDamageEntity.fromMap(Map<String, dynamic> map) {
    return TypeHalfDamageEntity(
      type: map['type'] ?? '',
      affectedType: map['affected_type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeHalfDamageEntity.fromJson(String source) =>
      TypeHalfDamageEntity.fromMap(json.decode(source));
}

class TypeNoDamageEntity {
  final String type;
  final String affectedType;
  TypeNoDamageEntity({
    required this.type,
    required this.affectedType,
  });
  static const coefficient = 0.0;

  TypeNoDamageEntity copyWith({
    String? type,
    String? affectedType,
  }) {
    return TypeNoDamageEntity(
      type: type ?? this.type,
      affectedType: affectedType ?? this.affectedType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'affected_type': affectedType,
      'coefficient': coefficient,
    };
  }

  factory TypeNoDamageEntity.fromMap(Map<String, dynamic> map) {
    return TypeNoDamageEntity(
      type: map['type'] ?? '',
      affectedType: map['affected_type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeNoDamageEntity.fromJson(String source) =>
      TypeNoDamageEntity.fromMap(json.decode(source));
}

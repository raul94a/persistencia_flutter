import 'package:persistencia_flutter/pokedex/data/models/remote/type_dto.dart';

class TypeEntity {
  final String name;
  final int slot;
  final DamageRelationEntity? damageRelation;

  TypeEntity({
    this.damageRelation,
    required this.name,
    this.slot = 0
  });

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

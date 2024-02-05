import 'dart:convert';

class Type {
  final String url;
  final String name;
  final DamageRelation? damageRelation;

  Type({
    this.damageRelation,
    required this.url,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'name': name,
    };
  }

  factory Type.fromMap(Map<String, dynamic> map) {
    return Type(
      url: map['url'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Type.fromJson(String source) => Type.fromMap(json.decode(source));

  Type copyWith({
    String? url,
    String? name,
    DamageRelation? damageRelation,
  }) {
    return Type(
      url: url ?? this.url,
      name: name ?? this.name,
      damageRelation: damageRelation ?? this.damageRelation,
    );
  }
}

class DamageRelation {
  final List<Type> doubleDamageFrom;
  final List<Type> doubleDamageTo;
  final List<Type> halfDamageTo;
  final List<Type> halfDamageFrom;
  final List<Type> noDamageFrom;
  final List<Type> noDamageTo;
  DamageRelation({
    required this.doubleDamageFrom,
    required this.doubleDamageTo,
    required this.halfDamageTo,
    required this.halfDamageFrom,
    required this.noDamageFrom,
    required this.noDamageTo,
  });

  DamageRelation copyWith({
    List<Type>? doubleDamageFrom,
    List<Type>? doubleDamageTo,
    List<Type>? halfDamageTo,
    List<Type>? halfDamageFrom,
    List<Type>? noDamageFrom,
    List<Type>? noDamageTo,
  }) {
    return DamageRelation(
      doubleDamageFrom: doubleDamageFrom ?? this.doubleDamageFrom,
      doubleDamageTo: doubleDamageTo ?? this.doubleDamageTo,
      halfDamageTo: halfDamageTo ?? this.halfDamageTo,
      halfDamageFrom: halfDamageFrom ?? this.halfDamageFrom,
      noDamageFrom: noDamageFrom ?? this.noDamageFrom,
      noDamageTo: noDamageTo ?? this.noDamageTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'double_damage_from': doubleDamageFrom.map((x) => x.toMap()).toList(),
      'double_damage_to': doubleDamageTo.map((x) => x.toMap()).toList(),
      'half_damage_to': halfDamageTo.map((x) => x.toMap()).toList(),
      'half_damage_from': halfDamageFrom.map((x) => x.toMap()).toList(),
      'no_damage_from': noDamageFrom.map((x) => x.toMap()).toList(),
      'no_damage_to': noDamageTo.map((x) => x.toMap()).toList(),
    };
  }

  factory DamageRelation.fromMap(Map<String, dynamic> map) {
    return DamageRelation(
      doubleDamageFrom: List<Type>.from(
          map['double_damage_from']?.map((x) => Type.fromMap(x))),
      doubleDamageTo:
          List<Type>.from(map['double_damage_to']?.map((x) => Type.fromMap(x))),
      halfDamageTo:
          List<Type>.from(map['half_damage_to']?.map((x) => Type.fromMap(x))),
      halfDamageFrom:
          List<Type>.from(map['half_damage_from']?.map((x) => Type.fromMap(x))),
      noDamageFrom:
          List<Type>.from(map['no_damage_from']?.map((x) => Type.fromMap(x))),
      noDamageTo:
          List<Type>.from(map['no_damage_to']?.map((x) => Type.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DamageRelation.fromJson(String source) =>
      DamageRelation.fromMap(json.decode(source));
}

class DamageCoefficients {
  double coefficient = 1;
  String type = 'normal';
  DamageCoefficients(this.coefficient, this.type);
  @override
  String toString() =>
      'DamageCoefficients(coefficient: $coefficient, type: $type)';
}

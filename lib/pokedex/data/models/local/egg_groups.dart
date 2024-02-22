import 'dart:convert';

class EggGroup {
  final String name;
  EggGroup({
    required this.name,
  });

  EggGroup copyWith({
    String? name,
  }) {
    return EggGroup(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory EggGroup.fromMap(Map<String, dynamic> map) {
    return EggGroup(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EggGroup.fromJson(String source) =>
      EggGroup.fromMap(json.decode(source));

  @override
  String toString() => 'EggGroup(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EggGroup && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class SpeciesEggGroups {
  final int specie;
  final String eggGroup;
  SpeciesEggGroups({
    required this.specie,
    required this.eggGroup,
  });

  SpeciesEggGroups copyWith({
    int? specie,
    String? eggGroup,
  }) {
    return SpeciesEggGroups(
      specie: specie ?? this.specie,
      eggGroup: eggGroup ?? this.eggGroup,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'specie': specie,
      'egg_group': eggGroup,
    };
  }

  factory SpeciesEggGroups.fromMap(Map<String, dynamic> map) {
    return SpeciesEggGroups(
      specie: map['specie']?.toInt() ?? 0,
      eggGroup: map['egg_group'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SpeciesEggGroups.fromJson(String source) => SpeciesEggGroups.fromMap(json.decode(source));

  @override
  String toString() => 'SpeciesEggGroups(specie: $specie, eggGroup: $eggGroup)';


}

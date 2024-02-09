
import 'package:persistencia_flutter/core/extensions/string_extensions.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';

class StatEntity {
  final int baseStat;
  final String name;
  StatEntity({
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

  StatEntity copyWith({
    int? baseStat,
    String? name,
  }) {
    return StatEntity(
      baseStat: baseStat ?? this.baseStat,
      name: name ?? this.name,
    );
  }

  factory StatEntity.fromDto(StatDto dto) =>
      StatEntity(baseStat: dto.baseStat, name: dto.stat.name);

  @override
  int get hashCode => baseStat.hashCode ^ name.hashCode;
}

import 'dart:convert';
import 'package:persistencia_flutter/core/extensions/string_extensions.dart';

class Stat {
  final int baseStat;
  final String name;
  Stat({
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

  Stat copyWith({
    int? baseStat,
    String? name,
  }) {
    return Stat(
      baseStat: baseStat ?? this.baseStat,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'base_stat': baseStat,
      'name': name,
    };
  }

  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(
      baseStat: map['base_stat']?.toInt() ?? 0,
      name: map['stat']['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Stat.fromJson(String source) => Stat.fromMap(json.decode(source));

  @override
  String toString() => 'Stat(baseStat: $baseStat, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Stat && other.baseStat == baseStat && other.name == name;
  }

  @override
  int get hashCode => baseStat.hashCode ^ name.hashCode;
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistencia_flutter/pokedex/data/species.dart';
import 'package:persistencia_flutter/pokedex/data/stat.dart';
import 'package:persistencia_flutter/pokedex/data/type.dart';
import 'package:persistencia_flutter/styles/pokemon_types_color.dart';

class Pokemon {
  final int id;
  final String name;
  final List<Type> types;
  final String imageUrl;
  final List<Stat> stats;
  final List<String> abilities;
  final num weight;
  final num height;
  final Species? species;
  const Pokemon({
    required this.abilities,
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.stats,
    required this.height,
    required this.weight,
    this.species,
  });

  List<DamageCoefficients> getDamageCoefficients() {
    List<DamageCoefficients> coefficients = [];
    final firstType = types.first;
    final damageRelation = firstType.damageRelation;
    // Si la relación de daños es null es porque no
    // se ha obtenido de internet (fallo request, no internet, etc)
    if (damageRelation == null) return [];
    coefficients.addAll(damageRelation.doubleDamageFrom
        .map((e) => DamageCoefficients(2, e.name))
        .toList());
    coefficients.addAll(damageRelation.halfDamageFrom
        .map((e) => DamageCoefficients(.5, e.name))
        .toList());
    coefficients.addAll(damageRelation.noDamageFrom
        .map((e) => DamageCoefficients(0, e.name))
        .toList());

    if (types.length == 2 && types.last.damageRelation != null) {
      final damageRelation = types.last.damageRelation!;
      final damageFromGrouped = <DamageCoefficients>[];
      damageFromGrouped.addAll(damageRelation.doubleDamageFrom
          .map((e) => DamageCoefficients(2, e.name)));
      damageFromGrouped.addAll(damageRelation.halfDamageFrom
          .map((e) => DamageCoefficients(.5, e.name)));
      damageFromGrouped.addAll(damageRelation.noDamageFrom
          .map((e) => DamageCoefficients(0, e.name)));

      for (final damage in damageFromGrouped) {
        final typeCoefficientIndex =
            coefficients.indexWhere((element) => element.type == damage.type);

        if (typeCoefficientIndex != -1) {
          final coefficient = coefficients[typeCoefficientIndex];
          coefficient.coefficient *= damage.coefficient;
        } else {
          coefficients.add(damage);
        }
      }
    }

    coefficients.removeWhere((element) => element.coefficient == 1.0);

    return coefficients..sort((a, b) => a.coefficient.compareTo(b.coefficient));
  }

  List<Evolution> getEvolutionChainCleaned() {
    print('Calling getEvolutionChain with species: $species');
    if (species == null || species?.evolutionChain == null) {
      return [];
    }
    final evolutionChain = species!.evolutionChain!;
    final evolutions = <Evolution>[];
    Evolution? currentEvolution = evolutionChain.evolution;
    evolutions.add(currentEvolution);
    while (currentEvolution != null) {
      currentEvolution = currentEvolution.evolution;
      if (currentEvolution != null) {
        evolutions.add(currentEvolution);
      }
    }
    final evolvesFrom = species!.evolvesFrom;
    evolutions.removeWhere(
        (element) => element.name == name || element.name == evolvesFrom);
    return evolutions;
  }

  List<Evolution> getFullEvolutionChain() {
    print('Calling getEvolutionChain with species: $species');
    if (species == null || species?.evolutionChain == null) {
      return [];
    }
    final evolutionChain = species!.evolutionChain!;
    final evolutions = <Evolution>[];
    Evolution? currentEvolution = evolutionChain.evolution;
    evolutions.add(currentEvolution);
    while (currentEvolution != null) {
      currentEvolution = currentEvolution.evolution;
      if (currentEvolution != null) {
        evolutions.add(currentEvolution);
      }
    }

    return evolutions;
  }

  // Este puede ser un poco más confuso, pero únicamente
  // generamos los datos adecuados para cada caso
  Evolution getEvolution(String name) {
    final evolutionChain = species!.evolutionChain;
    final chain = getFullEvolutionChain();
    if (evolutionChain!.name == name) {
      // si no hacemos esto, saldría el nombre de la primera ev.
      return chain
          .firstWhere((element) => element.name == this.name)
          .copyWith(name: name);
    }
    // Eliminamos la primera ev. Necesitamos los de la segunda.
    final currentEvolutionDetails = chain
        .firstWhere((element) => element.name == this.name)
        .evolutionDetails;
    return chain
        .firstWhere((element) => element.name == name)
        .copyWith(evolutionDetails: currentEvolutionDetails);
  }

  (int, double) statAggregationRecord() {
    var sum = stats.fold(
        0, (previousValue, element) => previousValue + element.baseStat);
    var fraction = sum / 700;
    return (sum, fraction);
  }

  Color containerColor() {
    return (pokemonTypesColors[types.first.name]!.containerColor);
  }

  Color onContainerColor() {
    return (pokemonTypesColors[types.first.name]!.onContainerColor);
  }

 

  Pokemon copyWith(
      {int? id,
      String? name,
      List<Type>? types,
      String? imageUrl,
      List<Stat>? stats,
      List<String>? abilities,
      num? weight,
      num? height,
      Species? species}) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      types: types ?? this.types,
      species: species ?? this.species,
      imageUrl: imageUrl ?? this.imageUrl,
      stats: stats ?? this.stats,
      abilities: abilities ?? this.abilities,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      abilities: (map['abilities'] as List<dynamic>)
          .map((e) => e['ability']['name'] as String)
          .toList(),
      height: map['height'],
      weight: map['weight'],
      stats:
          (map['stats'] as List<dynamic>).map((e) => Stat.fromMap(e)).toList(),
      name: map['name'] ?? '',
      types: (map['types'] as List<dynamic>)
          .map((e) => Type.fromMap(e['type']))
          .toList(),
      imageUrl: map['sprites']['other']['dream_world']['front_default'] ?? '',
    );
  }

  factory Pokemon.fromJson(String source) =>
      Pokemon.fromMap(json.decode(source));

  @override
  String toString() =>
      'Pokemon(name: $name, types: $types, imageUrl: $imageUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pokemon &&
        other.name == name &&
        listEquals(other.types, types) &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => name.hashCode ^ types.hashCode ^ imageUrl.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'types': types,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());
}

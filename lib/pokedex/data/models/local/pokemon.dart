import 'package:flutter/material.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/move_entity.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/species.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/stat.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/type.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';

import 'package:persistencia_flutter/styles/pokemon_types_color.dart';

class PokemonEntity {
  final int id;
  final String name;
  final List<TypeEntity> types;
  final String imageUrl;
  final List<StatEntity> stats;
  final List<String> abilities;
  final num weight;
  final num height;
  final List<MoveEntity> moves;
  final List<Move> movesReference;
  final SpeciesEntity? species;
  const PokemonEntity({
    required this.abilities,
    required this.id,
    required this.movesReference,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.stats,
    required this.height,
    required this.weight,
    this.species,
    required this.moves,
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

  List<EvolutionEntity> getEvolutionChainCleaned() {
    print('Calling getEvolutionChain with species: $species');
    if (species == null || species?.evolutionChain == null) {
      return [];
    }
    final evolutionChain = species!.evolutionChain!;
    final evolutions = <EvolutionEntity>[];
    EvolutionEntity? currentEvolution = evolutionChain.evolution;
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

  List<EvolutionEntity> getFullEvolutionChain() {
    print('Calling getEvolutionChain with species: $species');
    if (species == null || species?.evolutionChain == null) {
      return [];
    }
    final evolutionChain = species!.evolutionChain!;
    final evolutions = <EvolutionEntity>[];
    EvolutionEntity? currentEvolution = evolutionChain.evolution;
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
  EvolutionEntity getEvolution(String name) {
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

  PokemonEntity copyWith(
      {int? id,
      String? name,
      List<TypeEntity>? types,
      String? imageUrl,
      List<StatEntity>? stats,
      List<String>? abilities,
      num? weight,
      num? height,
      List<MoveEntity>? moves,
      SpeciesEntity? species}) {
    return PokemonEntity(
        id: id ?? this.id,
        movesReference: movesReference,
        name: name ?? this.name,
        types: types ?? this.types,
        species: species ?? this.species,
        imageUrl: imageUrl ?? this.imageUrl,
        stats: stats ?? this.stats,
        abilities: abilities ?? this.abilities,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        moves: moves ?? this.moves);
  }

  factory PokemonEntity.fromDto(PokemonDto dto) {
    return PokemonEntity(
      movesReference: dto.moves,
        abilities: dto.abilities.map((e) => e.ability.name).toList(),
        id: dto.id,
        name: dto.name,
        types: dto.types
            .map((e) => TypeEntity(name: e.type.name, slot: e.slot))
            .toList(),
        imageUrl: dto.sprites.other.dreamWorld?.frontDefault ??
            dto.sprites.frontDefault,
        stats: dto.stats.map(StatEntity.fromDto).toList(),
        height: dto.height,
        moves: [],
        weight: dto.weight);
  }

  String get pokemonSpeciesUrl =>
      'https://pokeapi.co/api/v2/pokemon-species/$id';
}

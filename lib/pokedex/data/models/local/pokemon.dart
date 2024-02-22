import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  final StatEntity stats;
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
    evolutions.removeWhere((element) =>
        element.name == name ||
        element.name == evolvesFrom ||
        element.name == evolutionChain.name);
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
    var sum = stats
        .toBaseStats()
        .fold(0, (previousValue, element) => previousValue + element.baseStat);
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
      StatEntity? stats,
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
        stats: StatEntity.fromDto(dto.stats, dto.id),
        height: dto.height,
        moves: [],
        weight: dto.weight);
  }

  String get pokemonSpeciesUrl =>
      'https://pokeapi.co/api/v2/pokemon-species/$id';
}

// (N,M)

class PokemonAbilities {
  final int pokemon;
  final String ability;
  PokemonAbilities({
    required this.pokemon,
    required this.ability,
  });

  PokemonAbilities copyWith({
    int? pokemon,
    String? ability,
  }) {
    return PokemonAbilities(
      pokemon: pokemon ?? this.pokemon,
      ability: ability ?? this.ability,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pokemon': pokemon,
      'ability': ability,
    };
  }

  factory PokemonAbilities.fromMap(Map<String, dynamic> map) {
    return PokemonAbilities(
      pokemon: map['pokemon']?.toInt() ?? 0,
      ability: map['ability'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonAbilities.fromJson(String source) =>
      PokemonAbilities.fromMap(json.decode(source));

  @override
  String toString() => 'PokemonAbilities(pokemon: $pokemon, ability: $ability)';
}

class PokemonMoves {
  final int pokemon;
  final String move;
  PokemonMoves({
    required this.pokemon,
    required this.move,
  });

  PokemonMoves copyWith({
    int? pokemon,
    String? move,
  }) {
    return PokemonMoves(
      pokemon: pokemon ?? this.pokemon,
      move: move ?? this.move,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pokemon': pokemon,
      'move': move,
    };
  }

  factory PokemonMoves.fromMap(Map<String, dynamic> map) {
    return PokemonMoves(
      pokemon: map['pokemon']?.toInt() ?? 0,
      move: map['move'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonMoves.fromJson(String source) =>
      PokemonMoves.fromMap(json.decode(source));

  @override
  String toString() => 'PokemonMoves(pokemon: $pokemon, move: $move)';
}

class PokemonTypes {
  final int pokemon;
  final String ability;
  final int slot;
  PokemonTypes({
    required this.pokemon,
    required this.ability,
    required this.slot,
  });


  PokemonTypes copyWith({
    int? pokemon,
    String? ability,
    int? slot,
  }) {
    return PokemonTypes(
      pokemon: pokemon ?? this.pokemon,
      ability: ability ?? this.ability,
      slot: slot ?? this.slot,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pokemon': pokemon,
      'ability': ability,
      'slot': slot,
    };
  }

  factory PokemonTypes.fromMap(Map<String, dynamic> map) {
    return PokemonTypes(
      pokemon: map['pokemon']?.toInt() ?? 0,
      ability: map['ability'] ?? '',
      slot: map['slot']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonTypes.fromJson(String source) => PokemonTypes.fromMap(json.decode(source));

  @override
  String toString() => 'PokemonTypes(pokemon: $pokemon, ability: $ability, slot: $slot)';
}

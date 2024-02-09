import 'package:flutter/material.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/move_entity.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/pokemon.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/species.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/type.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/species_dto.dart';
import 'package:persistencia_flutter/pokedex/data/source/remote/pokemon_api.dart';

class PokemonRepository {
  final PokemonApi pokemonApi;
  final Map<String, TypeEntity> _typeCache = {};
  final Map<String, MoveEntity> _movesCache = {};

  PokemonRepository({required this.pokemonApi});

  Future<void> _initCache() async {
    final types = await pokemonApi.fetchTypes();
    for (final type in types) {
      final typeEntity = TypeEntity.fromTypeDto(type);
      _typeCache.addAll({typeEntity.name: typeEntity});
    }
  }

  Future<void> _loadMovementsFromPokemonDto(List<PokemonDto> pokemons) async {
    for (final pokemon in pokemons) {
      final moves = pokemon.moves;
      for (final move in moves) {
        if (_movesCache[move.move.name] == null) {
          debugPrint('Cargando movimiento ${move.move.name}');
          final moveDto = await pokemonApi.getMove(move.move.url);
          final entity = MoveEntity.fromDto(moveDto);
          _movesCache.putIfAbsent(entity.name, () => entity);
        }
      }
    }
  }

  Future<List<PokemonEntity>> loadPokemons(int offset, int limit) async {
    if (offset == 0) {
      await _initCache();
    }
    final data =
        await pokemonApi.getPokemonPagination(offset: offset, limit: limit);
    _loadMovementsFromPokemonDto(data);
    return data.map((pokemonDto) {
      final pokemonEntity = PokemonEntity.fromDto(pokemonDto);
      final types = pokemonEntity.types;
      final newTypes = <TypeEntity>[];
      for (final type in types) {
        final newType = _typeCache[type.name]!;
        newTypes.add(newType);
      }
      return pokemonEntity.copyWith(types: newTypes);
    }).toList();
  }

  Future<PokemonEntity> loadPokemonSpecies(PokemonEntity pokemon) async {
    final specieDto = await pokemonApi.getSpecies(pokemon.pokemonSpeciesUrl);

    var specieEntity = SpeciesEntity.fromDto(specieDto, null);

    EvolutionChainDto? evChainDto;
    if (specieDto.evolutionChain != null) {
      evChainDto =
          await pokemonApi.getEvolutionChain(specieDto.evolutionChain!.url);
      final evChainEntity = EvolutionChainEntity.fromDto(evChainDto);
      specieEntity = specieEntity.copyWith(evolutionChain: evChainEntity);
    }

    return pokemon.copyWith(species: specieEntity);
  }

  PokemonEntity loadPokemonMovements(PokemonEntity pokemon) {
    final movements = <MoveEntity>[];

    for (final moveReference in pokemon.movesReference) {
      if (_movesCache.containsKey(moveReference.move.name)) {
        movements.add(_movesCache[moveReference.move.name]!);
      }
    }
    return pokemon.copyWith(moves: [...movements]);
  }
}

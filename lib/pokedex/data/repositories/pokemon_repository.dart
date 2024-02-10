import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
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

  Stream<MoveEntity?> _loadMovementsFromPokemonDto(
      List<PokemonDto> pokemons, Map<String, MoveEntity> movesCache) async* {
    for (final pokemon in pokemons) {
      final moves = pokemon.moves;
      for (final move in moves) {
        if (movesCache[move.move.name] == null) {
          final moveDto = await pokemonApi.getMove(move.move.url);
          final entity = MoveEntity.fromDto(moveDto);
          movesCache.putIfAbsent(entity.name, () => entity);
          yield entity;
        }
      }
    }
    yield null;
  }

  Future<List<PokemonEntity>> loadPokemons(int offset, int limit) async {
    if (offset == 0) {
      await _initCache();
    }
    final data =
        await pokemonApi.getPokemonPagination(offset: offset, limit: limit);

    final receivePort = ReceivePort();
    receivePort.listen((message) {
      if (message == null) {
        receivePort.close();
        debugPrint('Cerrando isolate');
        return;
      }
      final moveEntity = message as MoveEntity;
      // debugPrint('Añadiendo movimiento ${moveEntity.name} al caché');
      _movesCache.putIfAbsent(moveEntity.name, () => moveEntity);
    });

    final sendPort = receivePort.sendPort;
    final message = FetchMoveMessage(
        pokemon: data, sendPort: sendPort, movesCache: _movesCache);

    message.startIsolateWith(_loadMovementsFromPokemonDto);

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

class FetchMoveMessage {
  final List<PokemonDto> pokemon;
  final SendPort sendPort;
  final Map<String, MoveEntity> movesCache;

  const FetchMoveMessage(
      {required this.pokemon,
      required this.sendPort,
      required this.movesCache});

  void startIsolateWith(
      Stream<MoveEntity?> Function(List<PokemonDto>, Map<String, MoveEntity>)
          fetchMovesHandler) {
    Isolate.spawn((message) async {
      final isolateId = Service.getIsolateId(Isolate.current);
      debugPrint('Iniciando $isolateId');
      final stream = fetchMovesHandler(message.pokemon, message.movesCache);
      await for (final data in stream) {
        message.sendPort.send(data);
      }
    }, this);
  }
}

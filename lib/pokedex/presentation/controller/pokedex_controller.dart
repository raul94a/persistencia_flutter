// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/pokemon.dart';
import 'package:persistencia_flutter/pokedex/data/repositories/pokemon_repository.dart';
import 'package:persistencia_flutter/pokedex/data/source/remote/pokemon_api.dart';

final pokedexProvider = StateNotifierProvider<PokedexNotifier, PokedexState>(
    (ref) => PokedexNotifier(PokedexState(pokemons: [])));

class PokedexState {
  final List<PokemonEntity> pokemons;
  final bool loading;
  final bool loadingMovements;

  const PokedexState(
      {required this.pokemons,
      this.loading = false,
      this.loadingMovements = false});

  PokedexState copyWith(
      {List<PokemonEntity>? pokemons, bool? loading, bool? loadingMovements}) {
    return PokedexState(
      loading: loading ?? this.loading,
      loadingMovements: loadingMovements ?? this.loadingMovements,
      pokemons: pokemons ?? this.pokemons,
    );
  }

  String getImageByName(String name) {
    try {
      return pokemons.firstWhere((element) => element.name == name).imageUrl;
    } catch (e) {
      rethrow;
    }
  }
}

class PokedexNotifier extends StateNotifier<PokedexState> {
  final PokemonRepository repository =
      PokemonRepository(pokemonApi: PokemonApi());
  PokedexNotifier(super._state);

  Future<void> loadPokemons(int offset, int limit) async {
    state = state.copyWith(loading: true);
    try {
      final newPokemons = await repository.loadPokemons(offset, limit);
      final currentPokemons = state.pokemons;
      currentPokemons.addAll(newPokemons);
      state = state.copyWith(pokemons: [...currentPokemons]);
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> loadPokemonSpecies(int pokemonID) async {
    final index =
        state.pokemons.indexWhere((element) => element.id == pokemonID);
    final pokemonList = [...state.pokemons];
    var pokemon = pokemonList[index];

    pokemon = await repository.loadPokemonSpecies(pokemon);
    pokemonList[index] = pokemon;
    state = state.copyWith(pokemons: [...pokemonList]);
  }

  void loadPokemonMovements(PokemonEntity pokemon) {
    state = state.copyWith(loadingMovements: true);
    final pokemonList = [...state.pokemons];
    final pokemonIndex =
        pokemonList.indexWhere((element) => element.id == pokemon.id);

    final movements = repository.loadPokemonMovements(pokemon).moves;
    final updatedPokemon = pokemonList[pokemonIndex].copyWith(moves: movements);

    pokemonList[pokemonIndex] = updatedPokemon;
    state = state.copyWith(pokemons: [...pokemonList], loadingMovements: false);
  }

  Future<String> getImageFromPokemon(String name) async {
    final pokemon = await repository.getSinglePokemonFromRemote(name);
    return pokemon.imageUrl;
  }
}

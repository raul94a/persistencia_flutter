// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:persistencia_flutter/pokedex/data/pokemon.dart';
import 'package:persistencia_flutter/pokedex/data/species.dart';
import 'package:persistencia_flutter/pokedex/data/type.dart';

final pokedexProvider = StateNotifierProvider<PokedexNotifier, PokedexState>(
    (ref) => PokedexNotifier(PokedexState(pokemons: [])));

class PokedexState {
  final List<Pokemon> pokemons;
  final bool loading;

  const PokedexState({
    required this.pokemons,
    this.loading = false,
  });

  PokedexState copyWith({List<Pokemon>? pokemons, bool? loading}) {
    return PokedexState(
      loading: loading ?? this.loading,
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
  PokedexNotifier(super._state);

  Future<void> loadPokemons(int offset, int limit) async {
    state = state.copyWith(loading: true);
    try {
      final currentPokemons = state.pokemons;
      final url =
          'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit';
      final response = await get(Uri.parse(url));
      final jsonMap = jsonDecode(response.body);
      final results = jsonMap['results'] as List<dynamic>
        ..cast<Map<String, dynamic>>();
      final fetchedPokemon = <Pokemon>[];
      for (final result in results) {
        final url = result['url'];
        final pokemonResponse = await get(Uri.parse(url));
        final pokemonMap = jsonDecode(pokemonResponse.body);
        final pokemon = Pokemon.fromMap(pokemonMap);
        fetchedPokemon.add(pokemon);
      }
      currentPokemons.addAll(fetchedPokemon);
      state = state.copyWith(pokemons: [...currentPokemons]);
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<Pokemon> getPokemon(String url) async {
    final response = await get(Uri.parse(url));
    final pokemon = Pokemon.fromJson(response.body);
    return pokemon;
  }

  Future<void> loadPokemonDamageRelations(int pokemonID) async {
    final index =
        state.pokemons.indexWhere((element) => element.id == pokemonID);
    if (index == -1) {
      return;
    }
    var pokemon = state.pokemons[index];
    final types = pokemon.types;
    for (var i = 0; i < types.length; i++) {
      var type = types[i];
      if (type.damageRelation != null) {
        continue;
      }
      final response = await get(Uri.parse(type.url));
      final jsonMap = jsonDecode(response.body)['damage_relations'];
      final damageRelation = DamageRelation.fromMap(jsonMap);
      type = type.copyWith(damageRelation: damageRelation);
      types[i] = type;
    }
    pokemon = pokemon.copyWith(types: [...types]);
    state.pokemons[index] = pokemon;
    state = state.copyWith(pokemons: [...state.pokemons]);
  }

  Future<void> loadPokemonSpecies(int pokemonID) async {
    final index =
        state.pokemons.indexWhere((element) => element.id == pokemonID);
    var pokemon = state.pokemons[index];
    final url = 'https://pokeapi.co/api/v2/pokemon-species/$pokemonID';

    final response = await get(Uri.parse(url));
    final jsonMap = jsonDecode(response.body);
    final evolutionChainUrl = jsonMap['evolution_chain']?['url'];
    Map<String,dynamic>? evolutionChain;
    if (evolutionChainUrl != null) {
      final evolutionChainResponse = await get(Uri.parse(evolutionChainUrl));
      evolutionChain = jsonDecode(evolutionChainResponse.body);
    }

    jsonMap['evolution_chain'] = evolutionChain;
    final species = Species.fromMap(jsonMap);
    pokemon = pokemon.copyWith(species: species);
    state.pokemons[index] = pokemon;
    state = state.copyWith(pokemons: [...state.pokemons]);
  }
}


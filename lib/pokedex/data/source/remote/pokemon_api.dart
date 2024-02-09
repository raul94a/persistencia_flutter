import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:persistencia_flutter/pokedex/data/models/remote/move_dto.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/results_dto.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/species_dto.dart';
import 'package:persistencia_flutter/pokedex/data/models/remote/type_dto.dart';

class PokemonApi {
  Future<MoveDto> getMove(String url) async {
    final response = await http.get(Uri.parse(url));
    return MoveDto.fromRawJson(response.body);
  }

  Future<EvolutionChainDto> getEvolutionChain(String url) async {
    final response = await http.get(Uri.parse(url));
    return EvolutionChainDto.fromRawJson(response.body);
  }

  Future<PokemonSpeciesDto> getSpecies(String url) async {
    final response = await http.get(Uri.parse(url));
    return PokemonSpeciesDto.fromRawJson(response.body);
  }

  Future<List<PokemonDto>> getPokemonPagination(
      {required int offset, required int limit}) async {
    final url = 'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit';

    final response = await http.get(Uri.parse(url));
    final results = ResultsDto.fromJson(response.body);
    final pokemonDtos = <PokemonDto>[];
    for (final result in results.results) {
      final pokemonMap = await fetchSingle(result.url);
      final pokemonDto = PokemonDto.fromJson(pokemonMap);
      pokemonDtos.add(pokemonDto);
    }
    return pokemonDtos;
  }

  Future<List<TypeDto>> fetchTypes() async {
    const url = 'https://pokeapi.co/api/v2/type/';
    final response = await http.get(Uri.parse(url));
    final results = ResultsDto.fromJson(response.body);
    final types = <TypeDto>[];
    for (final result in results.results) {
      final typeResponse = await http.get(Uri.parse(result.url));
      final type = TypeDto.fromRawJson(typeResponse.body);
      types.add(type);
    }
    return types;
  }

  Future<Map<String, dynamic>> fetchSingle(String url) async {
    final response = await http.get(Uri.parse(url));

    return jsonDecode(response.body);
  }
}

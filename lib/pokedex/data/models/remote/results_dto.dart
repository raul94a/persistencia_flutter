import 'dart:convert';

import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';

class ResultsDto {
  final List<NameInfo> results;
  ResultsDto({
    required this.results,
  });

  ResultsDto copyWith({
    List<NameInfo>? results,
  }) {
    return ResultsDto(
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'results': results.map((x) => x.toJson()).toList(),
    };
  }

  factory ResultsDto.fromMap(Map<String, dynamic> map) {
    return ResultsDto(
      results: List<NameInfo>.from(map['results']?.map((x) => NameInfo.fromJson(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultsDto.fromJson(String source) => ResultsDto.fromMap(json.decode(source));

  @override
  String toString() => 'ResultsDto(results: $results)';


}

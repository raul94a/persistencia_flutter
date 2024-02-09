import 'dart:convert';

import 'package:persistencia_flutter/pokedex/data/models/remote/pokemon_dto.dart';

class PokemonSpeciesDto {
  final int id;
  final String name;
  final int order;
  final int genderRate;
  final int captureRate;
  final NameInfo growthRate;
  final List<NameInfo> eggGroups;
  final NameInfo color;
  final NameInfo shape;
  final NameInfo? evolvesFromSpecies;
  final EvolutionChainUrl? evolutionChain;
  final NameInfo habitat;

  PokemonSpeciesDto({
    required this.id,
    required this.name,
    required this.order,
    required this.genderRate,
    required this.captureRate,
    required this.growthRate,
    required this.eggGroups,
    required this.color,
    required this.shape,
    required this.evolvesFromSpecies,
    required this.evolutionChain,
    required this.habitat,
  });

  PokemonSpeciesDto copyWith({
    int? id,
    String? name,
    int? order,
    int? genderRate,
    int? captureRate,
    int? baseHappiness,
    bool? isBaby,
    bool? isLegendary,
    bool? isMythical,
    int? hatchCounter,
    bool? hasGenderDifferences,
    bool? formsSwitchable,
    NameInfo? growthRate,
    List<NameInfo>? eggGroups,
    NameInfo? color,
    NameInfo? shape,
    NameInfo? evolvesFromSpecies,
    EvolutionChainUrl? evolutionChain,
    dynamic habitat,
    NameInfo? generation,
  }) =>
      PokemonSpeciesDto(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        genderRate: genderRate ?? this.genderRate,
        captureRate: captureRate ?? this.captureRate,
        growthRate: growthRate ?? this.growthRate,
        eggGroups: eggGroups ?? this.eggGroups,
        color: color ?? this.color,
        shape: shape ?? this.shape,
        evolvesFromSpecies: evolvesFromSpecies ?? this.evolvesFromSpecies,
        evolutionChain: evolutionChain ?? this.evolutionChain,
        habitat: habitat ?? this.habitat,
      );

  factory PokemonSpeciesDto.fromRawJson(String str) =>
      PokemonSpeciesDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PokemonSpeciesDto.fromJson(Map<String, dynamic> json) =>
      PokemonSpeciesDto(
        id: json["id"],
        name: json["name"],
        order: json["order"],
        genderRate: json["gender_rate"],
        captureRate: json["capture_rate"],
        growthRate: NameInfo.fromJson(json["growth_rate"]),
        eggGroups: List<NameInfo>.from(
            json["egg_groups"].map((x) => NameInfo.fromJson(x))),
        color: NameInfo.fromJson(json["color"]),
        shape: NameInfo.fromJson(json["shape"]),
        evolvesFromSpecies: json['evolves_from_species'] == null
            ? null
            : NameInfo.fromJson(json["evolves_from_species"]),
        evolutionChain: json['evolution_chain'] == null
            ? null
            : EvolutionChainUrl.fromJson(json["evolution_chain"]),
        habitat: NameInfo.fromJson(json["habitat"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "order": order,
        "gender_rate": genderRate,
        "capture_rate": captureRate,
        "growth_rate": growthRate.toJson(),
        "egg_groups": List<dynamic>.from(eggGroups.map((x) => x.toJson())),
        "color": color.toJson(),
        "shape": shape.toJson(),
        "evolves_from_species": evolvesFromSpecies?.toJson(),
        "evolution_chain": evolutionChain?.toJson(),
        "habitat": habitat,
      };
}

class EvolutionChainUrl {
  final String url;

  EvolutionChainUrl({
    required this.url,
  });

  EvolutionChainUrl copyWith({
    String? url,
  }) =>
      EvolutionChainUrl(
        url: url ?? this.url,
      );

  factory EvolutionChainUrl.fromRawJson(String str) =>
      EvolutionChainUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EvolutionChainUrl.fromJson(Map<String, dynamic> json) =>
      EvolutionChainUrl(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class EvolutionChainDto {
  final int id;
  final dynamic babyTriggerItem;
  final EvolutionDto chain;

  EvolutionChainDto({
    required this.id,
    required this.babyTriggerItem,
    required this.chain,
  });

  EvolutionChainDto copyWith({
    int? id,
    dynamic babyTriggerItem,
    EvolutionDto? chain,
  }) =>
      EvolutionChainDto(
        id: id ?? this.id,
        babyTriggerItem: babyTriggerItem ?? this.babyTriggerItem,
        chain: chain ?? this.chain,
      );

  factory EvolutionChainDto.fromRawJson(String str) =>
      EvolutionChainDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EvolutionChainDto.fromJson(Map<String, dynamic> json) =>
      EvolutionChainDto(
        id: json["id"],
        babyTriggerItem: json["baby_trigger_item"],
        chain: EvolutionDto.fromJson(json["chain"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "baby_trigger_item": babyTriggerItem,
        "chain": chain.toJson(),
      };
}

class EvolutionDto {
  final bool isBaby;
  final NameInfo species;
  final List<EvolutionDetail> evolutionDetails;
  final List<EvolutionDto> evolvesTo;

  EvolutionDto({
    required this.isBaby,
    required this.species,
    required this.evolutionDetails,
    required this.evolvesTo,
  });

  EvolutionDto copyWith({
    bool? isBaby,
    NameInfo? species,
    List<EvolutionDetail>? evolutionDetails,
    List<EvolutionDto>? evolvesTo,
  }) =>
      EvolutionDto(
        isBaby: isBaby ?? this.isBaby,
        species: species ?? this.species,
        evolutionDetails: evolutionDetails ?? this.evolutionDetails,
        evolvesTo: evolvesTo ?? this.evolvesTo,
      );

  factory EvolutionDto.fromRawJson(String str) =>
      EvolutionDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EvolutionDto.fromJson(Map<String, dynamic> json) => EvolutionDto(
        isBaby: json["is_baby"],
        species: NameInfo.fromJson(json["species"]),
        evolutionDetails: List<EvolutionDetail>.from(
            json["evolution_details"].map((x) => EvolutionDetail.fromJson(x))),
        evolvesTo: List<EvolutionDto>.from(
            json["evolves_to"].map((x) => EvolutionDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_baby": isBaby,
        "species": species.toJson(),
        "evolution_details":
            List<dynamic>.from(evolutionDetails.map((x) => x.toJson())),
        "evolves_to": List<dynamic>.from(evolvesTo.map((x) => x.toJson())),
      };
}

class EvolutionDetail {
  final String? item;
  final NameInfo? trigger;
  final String? gender;
  final String? heldItem;
  final String? knownMove;
  final String? knownMoveType;
  final String? location;
  final int? minLevel;
  final int? minHappiness;
  final int? minBeauty;
  final String? minAffection;
  final bool? needsOverworldRain;
  final String? partySpecies;
  final String? partyType;
  final String? relativePhysicalStats;
  final String timeOfDay;
  final String? tradeSpecies;
  final bool? turnUpsideDown;

  EvolutionDetail({
    required this.item,
    required this.trigger,
    required this.gender,
    required this.heldItem,
    required this.knownMove,
    required this.knownMoveType,
    required this.location,
    required this.minLevel,
    required this.minHappiness,
    required this.minBeauty,
    required this.minAffection,
    required this.needsOverworldRain,
    required this.partySpecies,
    required this.partyType,
    required this.relativePhysicalStats,
    required this.timeOfDay,
    required this.tradeSpecies,
    required this.turnUpsideDown,
  });

  EvolutionDetail copyWith({
    dynamic item,
    NameInfo? trigger,


    
    dynamic gender,
    dynamic heldItem,
    dynamic knownMove,
    dynamic knownMoveType,
    dynamic location,
    int? minLevel,
    int? minHappiness,
    dynamic minBeauty,
    dynamic minAffection,
    bool? needsOverworldRain,
    dynamic partySpecies,
    dynamic partyType,
    dynamic relativePhysicalStats,
    String? timeOfDay,
    dynamic tradeSpecies,
    bool? turnUpsideDown,
  }) =>
      EvolutionDetail(
        item: item ?? this.item,
        trigger: trigger ?? this.trigger,
        gender: gender ?? this.gender,
        heldItem: heldItem ?? this.heldItem,
        knownMove: knownMove ?? this.knownMove,
        knownMoveType: knownMoveType ?? this.knownMoveType,
        location: location ?? this.location,
        minLevel: minLevel ?? this.minLevel,
        minHappiness: minHappiness ?? this.minHappiness,
        minBeauty: minBeauty ?? this.minBeauty,
        minAffection: minAffection ?? this.minAffection,
        needsOverworldRain: needsOverworldRain ?? this.needsOverworldRain,
        partySpecies: partySpecies ?? this.partySpecies,
        partyType: partyType ?? this.partyType,
        relativePhysicalStats:
            relativePhysicalStats ?? this.relativePhysicalStats,
        timeOfDay: timeOfDay ?? this.timeOfDay,
        tradeSpecies: tradeSpecies ?? this.tradeSpecies,
        turnUpsideDown: turnUpsideDown ?? this.turnUpsideDown,
      );

  factory EvolutionDetail.fromRawJson(String str) =>
      EvolutionDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EvolutionDetail.fromJson(Map<String, dynamic> json) =>
      EvolutionDetail(
        item:
            json['item'] == null ? null : NameInfo.fromJson(json["item"]).name,
        trigger: NameInfo.fromJson(json["trigger"]),
        gender: json["gender"],
        heldItem: json["held_item"],
        knownMove: json["known_move"],
        knownMoveType: json["known_move_type"],
        location: json["location"],
        minLevel: json["min_level"],
        minHappiness: json["min_happiness"],
        minBeauty: json["min_beauty"],
        minAffection: json["min_affection"],
        needsOverworldRain: json["needs_overworld_rain"],
        partySpecies: json["party_species"],
        partyType: json["party_type"],
        relativePhysicalStats: json["relative_physical_stats"],
        timeOfDay: json["time_of_day"],
        tradeSpecies: json["trade_species"],
        turnUpsideDown: json["turn_upside_down"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "trigger": trigger?.toJson(),
        "gender": gender,
        "held_item": heldItem,
        "known_move": knownMove,
        "known_move_type": knownMoveType,
        "location": location,
        "min_level": minLevel,
        "min_happiness": minHappiness,
        "min_beauty": minBeauty,
        "min_affection": minAffection,
        "needs_overworld_rain": needsOverworldRain,
        "party_species": partySpecies,
        "party_type": partyType,
        "relative_physical_stats": relativePhysicalStats,
        "time_of_day": timeOfDay,
        "trade_species": tradeSpecies,
        "turn_upside_down": turnUpsideDown,
      };
}


import 'package:persistencia_flutter/pokedex/data/models/remote/species_dto.dart';

class SpeciesEntity {
  final String growthRate;
  final String habitat;
  final String? evolvesFrom;
  final List<String> eggGroups;
  final EvolutionChainEntity? evolutionChain;
  SpeciesEntity({
    required this.growthRate,
    required this.habitat,
    this.evolvesFrom,
    required this.eggGroups,
    this.evolutionChain,
  });

  SpeciesEntity copyWith({
    String? growthRate,
    String? habitat,
    String? evolvesFrom,
    List<String>? eggGroups,
    EvolutionChainEntity? evolutionChain,
  }) {
    return SpeciesEntity(
      growthRate: growthRate ?? this.growthRate,
      habitat: habitat ?? this.habitat,
      evolvesFrom: evolvesFrom ?? this.evolvesFrom,
      eggGroups: eggGroups ?? this.eggGroups,
      evolutionChain: evolutionChain ?? this.evolutionChain,
    );
  }

  factory SpeciesEntity.fromDto(PokemonSpeciesDto dto, EvolutionChainDto? evChainDto) {
    return SpeciesEntity(
        growthRate: dto.growthRate.name,
        evolvesFrom: dto.evolvesFromSpecies?.name,
        evolutionChain: evChainDto == null
            ? null
            : EvolutionChainEntity.fromDto(evChainDto),
        habitat: dto.habitat.name,
        eggGroups: dto.eggGroups.map((e) => e.name).toList());
  }

  @override
  String toString() {
    return 'Species(growthRate: $growthRate, habitat: $habitat, evolvesFrom: $evolvesFrom, eggGroups: $eggGroups, evolutionChain: $evolutionChain)';
  }
}

class EvolutionChainEntity {
  final int id;
  final String name;
  final EvolutionEntity evolution;
  EvolutionChainEntity({
    required this.id,
    required this.name,
    required this.evolution,
  });

  EvolutionChainEntity copyWith({
    int? id,
    String? name,
    EvolutionEntity? evolution,
  }) {
    return EvolutionChainEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      evolution: evolution ?? this.evolution,
    );
  }

  factory EvolutionChainEntity.fromDto(EvolutionChainDto dto) {
    return EvolutionChainEntity(
        id: dto.id,
        name: dto.chain.species.name,
        evolution: EvolutionEntity.fromDto(dto.chain));
  }

  @override
  String toString() =>
      'EvolutionChain(id: $id, name: $name, evolution: $evolution)';
}

class EvolutionEntity {
  final String name;
  final EvolutionDetailsEntity? evolutionDetails;
  final String imageUrl;
  final EvolutionEntity? evolution;
  EvolutionEntity({
    required this.imageUrl,
    required this.name,
    this.evolutionDetails,
    this.evolution,
  });

  EvolutionEntity copyWith({
    String? name,
    String? imageUrl,
    EvolutionDetailsEntity? evolutionDetails,
    EvolutionEntity? evolution,
  }) {
    return EvolutionEntity(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      evolutionDetails: evolutionDetails ?? this.evolutionDetails,
      evolution: evolution ?? this.evolution,
    );
  }

  factory EvolutionEntity.fromDto(EvolutionDto dto) {
    return EvolutionEntity(
        imageUrl: '',
        name: dto.species.name,
        evolution: dto.evolvesTo.isEmpty
            ? null
            : EvolutionEntity.fromDto(dto.evolvesTo.first),
        evolutionDetails: dto.evolutionDetails.isEmpty
            ? null
            : EvolutionDetailsEntity.fromDto(dto.evolutionDetails.first));
  }

  @override
  String toString() =>
      'Evolution(name: $name, evolutionDetails: $evolutionDetails, evolution: $evolution)';
}

class EvolutionDetailsEntity {
  final int? minLevel;
  final String? item;
  final String trigger;
  EvolutionDetailsEntity({
    this.minLevel,
    this.item,
    required this.trigger,
  });

  EvolutionDetailsEntity copyWith({
    int? minLevel,
    String? item,
    String? trigger,
  }) {
    return EvolutionDetailsEntity(
      minLevel: minLevel ?? this.minLevel,
      item: item ?? this.item,
      trigger: trigger ?? this.trigger,
    );
  }

  factory EvolutionDetailsEntity.fromDto(EvolutionDetail dto) {
    return EvolutionDetailsEntity(
        trigger: dto.trigger?.name ?? '',
        minLevel: dto.minLevel,
        item: dto.item);
  }

  @override
  String toString() =>
      'EvolutionDetails(minLevel: $minLevel, item: $item, trigger: $trigger)';
}

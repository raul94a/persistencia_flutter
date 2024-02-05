import 'dart:convert';

class Species {
  final String growthRate;
  final String habitat;
  final String? evolvesFrom;
  final List<String> eggGroups;
  final EvolutionChain? evolutionChain;
  Species({
    required this.growthRate,
    required this.habitat,
    this.evolvesFrom,
    required this.eggGroups,
    this.evolutionChain,
  });

  Species copyWith({
    String? growthRate,
    String? habitat,
    String? evolvesFrom,
    List<String>? eggGroups,
    EvolutionChain? evolutionChain,
  }) {
    return Species(
      growthRate: growthRate ?? this.growthRate,
      habitat: habitat ?? this.habitat,
      evolvesFrom: evolvesFrom ?? this.evolvesFrom,
      eggGroups: eggGroups ?? this.eggGroups,
      evolutionChain: evolutionChain ?? this.evolutionChain,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'growth_rate': growthRate,
      'habitat': habitat,
      'evolves_from_species': evolvesFrom,
      'egg_groups': eggGroups,
      'evolution_chain': evolutionChain?.toMap(),
    };
  }

  factory Species.fromMap(Map<String, dynamic> map) {
    return Species(
      growthRate: map['growth_rate']['name'] ?? '',
      habitat: map['habitat']['name'] ?? '',
      evolvesFrom: map['evolves_from_species']?['name'],
      eggGroups: (map['egg_groups'] as List<dynamic>)
          .map((e) => e['name'] as String)
          .toList(),
      evolutionChain: map['evolution_chain'] != null
          ? EvolutionChain.fromMap(map['evolution_chain'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Species.fromJson(String source) =>
      Species.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Species(growthRate: $growthRate, habitat: $habitat, evolvesFrom: $evolvesFrom, eggGroups: $eggGroups, evolutionChain: $evolutionChain)';
  }
}

class EvolutionChain {
  final int id;
  final String name;
  final Evolution evolution;
  EvolutionChain({
    required this.id,
    required this.name,
    required this.evolution,
  });

  EvolutionChain copyWith({
    int? id,
    String? name,
    Evolution? evolution,
  }) {
    return EvolutionChain(
      id: id ?? this.id,
      name: name ?? this.name,
      evolution: evolution ?? this.evolution,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'evolution': evolution.toMap(),
    };
  }

  factory EvolutionChain.fromMap(Map<String, dynamic> map) {
    final chain = map['chain'];
    final evolvesTo =
        ((chain['evolves_to'] as List<dynamic>).cast<Map<String, dynamic>>())
            .first;
    return EvolutionChain(
        id: map['id']?.toInt() ?? 0,
        name: chain['species']['name'] ?? '',
        evolution: (Evolution.fromMap(evolvesTo)));
  }

  String toJson() => json.encode(toMap());

  factory EvolutionChain.fromJson(String source) =>
      EvolutionChain.fromMap(json.decode(source));

  @override
  String toString() =>
      'EvolutionChain(id: $id, name: $name, evolution: $evolution)';
}

class Evolution {
  final String name;
  final EvolutionDetails? evolutionDetails;
  final String imageUrl;
  final Evolution? evolution;
  Evolution({
    required this.imageUrl,
    required this.name,
    this.evolutionDetails,
    this.evolution,
  });

  Evolution copyWith({
    String? name,
    String? imageUrl,
    EvolutionDetails? evolutionDetails,
    Evolution? evolution,
  }) {
    return Evolution(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      evolutionDetails: evolutionDetails ?? this.evolutionDetails,
      evolution: evolution ?? this.evolution,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'evolution_details': evolutionDetails?.toMap(),
      'evolves_to': evolution?.toMap(),
    };
  }

  factory Evolution.fromMap(Map<String, dynamic> map) {
    final evolutionDetails = map['evolution_details'].first;
    final evolvesTo =
        (map['evolves_to'] as List<dynamic>).cast<Map<String, dynamic>>();
    return Evolution(
      imageUrl: '',
      name: map['species']['name'] ?? '',
      evolutionDetails: map['evolution_details'] != null
          ? EvolutionDetails.fromMap(evolutionDetails)
          : null,
      evolution:
          evolvesTo.isNotEmpty ? (Evolution.fromMap(evolvesTo.first)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Evolution.fromJson(String source) =>
      Evolution.fromMap(json.decode(source));

  @override
  String toString() =>
      'Evolution(name: $name, evolutionDetails: $evolutionDetails, evolution: $evolution)';
}

class EvolutionDetails {
  final int? minLevel;
  final String? item;
  final String trigger;
  EvolutionDetails({
    this.minLevel,
    this.item,
    required this.trigger,
  });

  EvolutionDetails copyWith({
    int? minLevel,
    String? item,
    String? trigger,
  }) {
    return EvolutionDetails(
      minLevel: minLevel  ?? this.minLevel,
      item: item ?? this.item,
      trigger: trigger ?? this.trigger,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'min_level': minLevel,
      'item': item,
      'trigger': trigger,
    };
  }

  factory EvolutionDetails.fromMap(Map<String, dynamic> map) {
    return EvolutionDetails(
      minLevel: map['min_level']?.toInt(),
      item: map['item']?['name'],
      trigger: map['trigger']['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EvolutionDetails.fromJson(String source) =>
      EvolutionDetails.fromMap(json.decode(source));

  @override
  String toString() =>
      'EvolutionDetails(minLevel: $minLevel, item: $item, trigger: $trigger)';
}

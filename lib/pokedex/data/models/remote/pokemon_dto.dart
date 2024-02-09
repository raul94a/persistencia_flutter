import 'dart:convert';

class PokemonDto {
  final int id;
  final String name;
  final int baseExperience;
  final int height;
  final bool isDefault;
  final int order;
  final int weight;
  final List<Ability> abilities;
  final List<NameInfo> forms;
  final String locationAreaEncounters;
  final List<Move> moves;
  final NameInfo species;
  final Sprites sprites;
  final List<StatDto> stats;
  final List<Type> types;

  PokemonDto({
    required this.id,
    required this.name,
    required this.baseExperience,
    required this.height,
    required this.isDefault,
    required this.order,
    required this.weight,
    required this.abilities,
    required this.forms,
    required this.locationAreaEncounters,
    required this.moves,
    required this.species,
    required this.sprites,
    required this.stats,
    required this.types,
  });

  PokemonDto copyWith({
    int? id,
    String? name,
    int? baseExperience,
    int? height,
    bool? isDefault,
    int? order,
    int? weight,
    List<Ability>? abilities,
    List<NameInfo>? forms,
    String? locationAreaEncounters,
    List<Move>? moves,
    NameInfo? species,
    Sprites? sprites,
    List<StatDto>? stats,
    List<Type>? types,
  }) =>
      PokemonDto(
        id: id ?? this.id,
        name: name ?? this.name,
        baseExperience: baseExperience ?? this.baseExperience,
        height: height ?? this.height,
        isDefault: isDefault ?? this.isDefault,
        order: order ?? this.order,
        weight: weight ?? this.weight,
        abilities: abilities ?? this.abilities,
        forms: forms ?? this.forms,
        locationAreaEncounters:
            locationAreaEncounters ?? this.locationAreaEncounters,
        moves: moves ?? this.moves,
        species: species ?? this.species,
        sprites: sprites ?? this.sprites,
        stats: stats ?? this.stats,
        types: types ?? this.types,
      );

  factory PokemonDto.fromRawJson(String str) =>
      PokemonDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PokemonDto.fromJson(Map<String, dynamic> json) => PokemonDto(
        id: json["id"],
        name: json["name"],
        baseExperience: json["base_experience"],
        height: json["height"],
        isDefault: json["is_default"],
        order: json["order"],
        weight: json["weight"],
        abilities: List<Ability>.from(
            json["abilities"].map((x) => Ability.fromJson(x))),
        forms:
            List<NameInfo>.from(json["forms"].map((x) => NameInfo.fromJson(x))),
        locationAreaEncounters: json["location_area_encounters"],
        moves: List<Move>.from(json["moves"].map((x) => Move.fromJson(x))),
        species: NameInfo.fromJson(json["species"]),
        sprites: Sprites.fromJson(json["sprites"]),
        stats:
            List<StatDto>.from(json["stats"].map((x) => StatDto.fromJson(x))),
        types: List<Type>.from(json["types"].map((x) => Type.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "base_experience": baseExperience,
        "height": height,
        "is_default": isDefault,
        "order": order,
        "weight": weight,
        "abilities": List<dynamic>.from(abilities.map((x) => x.toJson())),
        "forms": List<dynamic>.from(forms.map((x) => x.toJson())),
        "location_area_encounters": locationAreaEncounters,
        "moves": List<dynamic>.from(moves.map((x) => x.toJson())),
        "species": species.toJson(),
        "sprites": sprites.toJson(),
        "stats": List<dynamic>.from(stats.map((x) => x.toJson())),
        "types": List<dynamic>.from(types.map((x) => x.toJson())),
      };
}

class Ability {
  final bool isHidden;
  final int slot;
  final NameInfo ability;

  Ability({
    required this.isHidden,
    required this.slot,
    required this.ability,
  });

  Ability copyWith({
    bool? isHidden,
    int? slot,
    NameInfo? ability,
  }) =>
      Ability(
        isHidden: isHidden ?? this.isHidden,
        slot: slot ?? this.slot,
        ability: ability ?? this.ability,
      );

  factory Ability.fromRawJson(String str) => Ability.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ability.fromJson(Map<String, dynamic> json) => Ability(
        isHidden: json["is_hidden"],
        slot: json["slot"],
        ability: NameInfo.fromJson(json["ability"]),
      );

  Map<String, dynamic> toJson() => {
        "is_hidden": isHidden,
        "slot": slot,
        "ability": ability.toJson(),
      };
}

class NameInfo {
  final String name;
  final String url;

  NameInfo({
    required this.name,
    required this.url,
  });

  NameInfo copyWith({
    String? name,
    String? url,
  }) =>
      NameInfo(
        name: name ?? this.name,
        url: url ?? this.url,
      );

  factory NameInfo.fromRawJson(String str) =>
      NameInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NameInfo.fromJson(Map<String, dynamic> json) => NameInfo(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

class Move {
  final NameInfo move;

  Move({
    required this.move,
  });

  Move copyWith({
    NameInfo? move,
  }) =>
      Move(
        move: move ?? this.move,
      );

  factory Move.fromRawJson(String str) => Move.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Move.fromJson(Map<String, dynamic> json) => Move(
        move: NameInfo.fromJson(json["move"]),
      );

  Map<String, dynamic> toJson() => {
        "move": move.toJson(),
      };
}

class Type {
  final int slot;
  final NameInfo type;

  Type({
    required this.slot,
    required this.type,
  });

  Type copyWith({
    int? slot,
    NameInfo? type,
  }) =>
      Type(
        slot: slot ?? this.slot,
        type: type ?? this.type,
      );

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        slot: json["slot"],
        type: NameInfo.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "slot": slot,
        "type": type.toJson(),
      };
}

class Other {
  final DreamWorld? dreamWorld;

  Other({
    required this.dreamWorld,
  });

  Other copyWith({
    DreamWorld? dreamWorld,
  }) =>
      Other(
        dreamWorld: dreamWorld ?? this.dreamWorld,
      );

  factory Other.fromRawJson(String str) => Other.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Other.fromJson(Map<String, dynamic> json) => Other(
        dreamWorld: DreamWorld.fromJson(json["dream_world"]),
      );

  Map<String, dynamic> toJson() => {
        "dream_world": dreamWorld?.toJson(),
      };
}

class Sprites {
  final String backDefault;
  final String? backFemale;
  final String backShiny;
  final String? backShinyFemale;
  final String frontDefault;
  final String? frontFemale;
  final String frontShiny;
  final String? frontShinyFemale;
  final Other other;
  final Sprites? animated;

  Sprites({
    required this.backDefault,
    required this.backFemale,
    required this.backShiny,
    required this.backShinyFemale,
    required this.frontDefault,
    required this.frontFemale,
    required this.frontShiny,
    required this.frontShinyFemale,
    required this.other,
    required this.animated,
  });

  Sprites copyWith({
    String? backDefault,
    dynamic backFemale,
    String? backShiny,
    dynamic backShinyFemale,
    String? frontDefault,
    dynamic frontFemale,
    String? frontShiny,
    dynamic frontShinyFemale,
    Other? other,
    Sprites? animated,
  }) =>
      Sprites(
        backDefault: backDefault ?? this.backDefault,
        backFemale: backFemale ?? this.backFemale,
        backShiny: backShiny ?? this.backShiny,
        backShinyFemale: backShinyFemale ?? this.backShinyFemale,
        frontDefault: frontDefault ?? this.frontDefault,
        frontFemale: frontFemale ?? this.frontFemale,
        frontShiny: frontShiny ?? this.frontShiny,
        frontShinyFemale: frontShinyFemale ?? this.frontShinyFemale,
        other: other ?? this.other,
        animated: animated ?? this.animated,
      );

  factory Sprites.fromRawJson(String str) => Sprites.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sprites.fromJson(Map<String, dynamic> json) => Sprites(
        backDefault: json["back_default"],
        backFemale: json["back_female"],
        backShiny: json["back_shiny"],
        backShinyFemale: json["back_shiny_female"],
        frontDefault: json["front_default"],
        frontFemale: json["front_female"],
        frontShiny: json["front_shiny"],
        frontShinyFemale: json["front_shiny_female"],
        other: Other.fromJson(json["other"]),
        animated: json['animated'] == null ? null :  Sprites?.fromJson(json["animated"]),
      );

  Map<String, dynamic> toJson() => {
        "back_default": backDefault,
        "back_female": backFemale,
        "back_shiny": backShiny,
        "back_shiny_female": backShinyFemale,
        "front_default": frontDefault,
        "front_female": frontFemale,
        "front_shiny": frontShiny,
        "front_shiny_female": frontShinyFemale,
        "other": other.toJson(),
        "animated": animated?.toJson(),
      };
}

class OfficialArtwork {
  final String frontDefault;
  final String frontShiny;

  OfficialArtwork({
    required this.frontDefault,
    required this.frontShiny,
  });

  OfficialArtwork copyWith({
    String? frontDefault,
    String? frontShiny,
  }) =>
      OfficialArtwork(
        frontDefault: frontDefault ?? this.frontDefault,
        frontShiny: frontShiny ?? this.frontShiny,
      );

  factory OfficialArtwork.fromRawJson(String str) =>
      OfficialArtwork.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) =>
      OfficialArtwork(
        frontDefault: json["front_default"],
        frontShiny: json["front_shiny"],
      );

  Map<String, dynamic> toJson() => {
        "front_default": frontDefault,
        "front_shiny": frontShiny,
      };
}

class DreamWorld {
  final String frontDefault;
  final dynamic frontFemale;

  DreamWorld({
    required this.frontDefault,
    required this.frontFemale,
  });

  DreamWorld copyWith({
    String? frontDefault,
    dynamic frontFemale,
  }) =>
      DreamWorld(
        frontDefault: frontDefault ?? this.frontDefault,
        frontFemale: frontFemale ?? this.frontFemale,
      );

  factory DreamWorld.fromRawJson(String str) =>
      DreamWorld.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DreamWorld.fromJson(Map<String, dynamic> json) => DreamWorld(
        frontDefault: json["front_default"],
        frontFemale: json["front_female"],
      );

  Map<String, dynamic> toJson() => {
        "front_default": frontDefault,
        "front_female": frontFemale,
      };
}

class StatDto {
  final int baseStat;
  final int effort;
  final NameInfo stat;

  StatDto({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  StatDto copyWith({
    int? baseStat,
    int? effort,
    NameInfo? stat,
  }) =>
      StatDto(
        baseStat: baseStat ?? this.baseStat,
        effort: effort ?? this.effort,
        stat: stat ?? this.stat,
      );

  factory StatDto.fromRawJson(String str) => StatDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatDto.fromJson(Map<String, dynamic> json) => StatDto(
        baseStat: json["base_stat"],
        effort: json["effort"],
        stat: NameInfo.fromJson(json["stat"]),
      );

  Map<String, dynamic> toJson() => {
        "base_stat": baseStat,
        "effort": effort,
        "stat": stat.toJson(),
      };
}

import 'package:flutter/material.dart';

enum PokemonTypes {
  normal("normal"),
  fighting("fighting"),
  flying('flying'),
  poison('poison'),
  ground('ground'),
  rock('rock'),
  bug('bug'),
  ghost('ghost'),
  steel('steel'),
  fire('fire'),
  water('water'),
  grass('grass'),
  electric('electric'),
  psychic('psychic'),
  ice('ice'),
  dragon('dragon'),
  dark('dark'),
  fairy('fairy'),
  unknown('unknown'),
  shadow('shadow');

  final String typeName;
  const PokemonTypes(this.typeName);
}

class PokemonColors {
  const PokemonColors(this.containerColor, this.onContainerColor);
  final Color containerColor;
  final Color onContainerColor;
}

final pokemonTypesColors = {
  PokemonTypes.fire.typeName:
      const PokemonColors(Colors.redAccent, Color.fromARGB(255, 240, 174, 174)),
  PokemonTypes.water.typeName: const PokemonColors(
      Colors.blueAccent, Color.fromARGB(255, 173, 200, 248)),
  PokemonTypes.grass.typeName: const PokemonColors(
      Color.fromARGB(255, 128, 203, 130), Color.fromARGB(255, 178, 248, 214)),
  PokemonTypes.normal.typeName: const PokemonColors(
      Color.fromARGB(255, 169, 167, 167), Color.fromARGB(255, 240, 239, 239)),
  PokemonTypes.poison.typeName: const PokemonColors(
      Colors.purpleAccent, Color.fromARGB(255, 239, 146, 255)),
  PokemonTypes.electric.typeName: const PokemonColors(
      Color.fromARGB(255, 220, 208, 33), Color.fromARGB(255, 252, 252, 131)),
  PokemonTypes.fighting.typeName: const PokemonColors(
      Color.fromARGB(255, 149, 100, 82), Color.fromARGB(255, 193, 134, 113)),
  PokemonTypes.bug.typeName: const PokemonColors(
      Color.fromARGB(255, 198, 198, 12), Color.fromARGB(255, 220, 220, 137)),
  PokemonTypes.dark.typeName: const PokemonColors(
      Color.fromARGB(255, 37, 37, 37), Color.fromARGB(255, 103, 102, 102)),
  PokemonTypes.dragon.typeName: const PokemonColors(
      Color.fromARGB(255, 64, 89, 255), Color.fromARGB(255, 114, 209, 253)),
  PokemonTypes.fairy.typeName: const PokemonColors(
      Color.fromARGB(255, 246, 111, 156), Color.fromARGB(255, 241, 181, 201)),
  PokemonTypes.flying.typeName: const PokemonColors(
      Color.fromARGB(255, 187, 187, 187), Color.fromARGB(255, 214, 210, 210)),
  PokemonTypes.ghost.typeName: const PokemonColors(
      Colors.deepPurpleAccent, Color.fromARGB(255, 160, 131, 239)),
  PokemonTypes.ground.typeName: const PokemonColors(
    Color.fromARGB(255, 168, 87, 58),
    Color.fromARGB(255, 225, 146, 117),
  ),
  PokemonTypes.ice.typeName: const PokemonColors(
      Color.fromARGB(255, 151, 217, 247), Color.fromARGB(255, 198, 233, 249)),
  PokemonTypes.psychic.typeName: const PokemonColors(
      Colors.pinkAccent, Color.fromARGB(255, 239, 141, 174)),
  PokemonTypes.rock.typeName: const PokemonColors(
      Color.fromARGB(255, 125, 64, 42), Color.fromARGB(255, 171, 150, 142)),
  PokemonTypes.steel.typeName:
      const PokemonColors(Colors.blueGrey, Color.fromARGB(255, 197, 199, 200)),
  PokemonTypes.shadow.typeName:
      const PokemonColors(Colors.purple, Color.fromARGB(255, 147, 91, 157)),
  PokemonTypes.unknown.typeName:
      const PokemonColors(Colors.white, Colors.white),
};

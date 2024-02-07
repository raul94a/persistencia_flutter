import 'package:flutter/material.dart';
import 'package:persistencia_flutter/core/extensions/string_extensions.dart';
import 'package:persistencia_flutter/pokedex/data/pokemon.dart';

class PokemonInformationContainer extends StatelessWidget {
  const PokemonInformationContainer({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  pokemon.name.capitalizeFirst(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  '${pokemon.id}',
                  style: const TextStyle(color: Colors.white, fontSize: 21),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          _TypesRow(pokemon: pokemon)
        ],
      ),
    );
  }
}
class _TypesRow extends StatelessWidget {
  const _TypesRow({
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: pokemon.types
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 0, bottom: 0),
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                      color: pokemon.onContainerColor(),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    e.name.capitalizeFirst(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

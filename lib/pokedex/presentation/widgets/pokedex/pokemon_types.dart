import 'package:flutter/material.dart';
import 'package:persistencia_flutter/core/extensions/string_extensions.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/pokemon.dart';

class PokemonTypesColumn extends StatelessWidget {
  const PokemonTypesColumn({super.key, required this.pokemon});

  final PokemonEntity pokemon;
  @override
  Widget build(BuildContext context) {
    final color = pokemon.onContainerColor();

    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          final type = pokemon.types[index].name.capitalizeFirst();
          return Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: color,
            ),
            child: Text(
              type,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          );
        },
        separatorBuilder: (ctx, index) => const SizedBox(
              height: 13.0,
            ),
        itemCount: pokemon.types.length);
  }
}

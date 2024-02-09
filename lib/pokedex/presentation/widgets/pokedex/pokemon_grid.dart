// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistencia_flutter/core/extensions/string_extensions.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/pokemon.dart';

import 'package:persistencia_flutter/pokedex/presentation/controller/pokedex_controller.dart';
import 'package:persistencia_flutter/pokedex/presentation/pokemon_screen.dart';
import 'package:persistencia_flutter/pokedex/presentation/widgets/pokedex/pokemon_avatar.dart';
import 'package:persistencia_flutter/pokedex/presentation/widgets/pokedex/pokemon_types.dart';

class PokemonGrid extends ConsumerWidget {
  const PokemonGrid({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemons =
        ref.watch(pokedexProvider.select((value) => value.pokemons));

    return GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(5.0),
        itemCount: pokemons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10),
        itemBuilder: (ctx, i) {
          final item = pokemons[i];
          return PokemonGridContainer(pokemon: item);
        });
  }
}

class PokemonGridContainer extends StatelessWidget {
  const PokemonGridContainer({
    super.key,
    required this.pokemon,
  });

  final PokemonEntity pokemon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('pokedex-pkmn-${pokemon.id}'),
      onTap: () {
        //Navigation
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => PokemonScreen(pokemon: pokemon)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: pokemon.containerColor(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pokemon.name.capitalizeFirst(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 13,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PokemonTypesColumn(
                        pokemon: pokemon,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: PokemonAvatar(
                          pokemon: pokemon,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

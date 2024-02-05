import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistencia_flutter/pokedex/data/pokemon.dart';
import 'package:persistencia_flutter/pokedex/presentation/controller/pokedex_controller.dart';
import 'package:persistencia_flutter/pokedex/presentation/pokedex_screen.dart';
import 'package:persistencia_flutter/pokedex/presentation/widgets/single_pokemon/pokemon_avatar.dart';
import 'package:persistencia_flutter/pokedex/presentation/widgets/single_pokemon/pokemon_information_container.dart';
import 'package:persistencia_flutter/pokedex/presentation/widgets/single_pokemon/pokemon_tabview.dart';

class PokemonScreen extends ConsumerStatefulWidget {
  const PokemonScreen({super.key, required this.pokemon});
  final Pokemon pokemon;

  @override
  ConsumerState<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends ConsumerState<PokemonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(pokedexProvider.notifier)
          .loadPokemonDamageRelations(widget.pokemon.id)
          .then((value) {
        ref
            .read(pokedexProvider.notifier)
            .loadPokemonSpecies(widget.pokemon.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final containerHeight = MediaQuery.of(context).size.height / 2;
    final width = MediaQuery.of(context).size.width;
    const pokemonDimensions = 220.0;
    final pokemonVerticalPosition = (containerHeight - pokemonDimensions) + 20;
    final pokemonHorizontalPosition = (width - pokemonDimensions) / 2;
    return Container(
      color: widget.pokemon.containerColor(),
      child: Stack(
        children: [
          Positioned(
              top: containerHeight - 125 * 1.2,
              left: (width) - 125 * 1.2,
              child: PokeballPicture(
                scale: 1.6,
                color: widget.pokemon.onContainerColor(),
              )),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _appBar(context),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PokemonInformationContainer(pokemon: widget.pokemon),
                PokemonTabView(
                    containerHeight: containerHeight, pokemon: widget.pokemon),
              ],
            ),
          ),
         Positioned(
              top: pokemonVerticalPosition,
              left: pokemonHorizontalPosition,
              child: PokemonAvatar(
                pokemon: widget.pokemon,
                imageDimensions: pokemonDimensions,
              )),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_outline,
              color: Colors.white,
            ))
      ],
    );
  }
}

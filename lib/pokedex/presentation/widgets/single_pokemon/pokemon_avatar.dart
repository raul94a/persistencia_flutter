import 'package:flutter/material.dart';
import 'package:persistencia_flutter/pokedex/data/pokemon.dart';
import 'package:svg_flutter/svg.dart';


class PokemonAvatar extends StatelessWidget {
  const PokemonAvatar({
    super.key,
    required this.pokemon,
    required this.imageDimensions,
  });

  final Pokemon pokemon;
  final double imageDimensions;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageDimensions,
      height: imageDimensions,
      child: Hero(
          tag: 'pokemon-${pokemon.id}',
          child: SvgPicture.network(
            pokemon.imageUrl,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          )),
    );
  }
}

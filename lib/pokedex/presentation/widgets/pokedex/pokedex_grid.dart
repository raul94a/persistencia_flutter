// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistencia_flutter/core/extensions/string_extensions.dart';
import 'package:persistencia_flutter/pokedex/data/pokemon.dart';
import 'package:persistencia_flutter/pokedex/presentation/controller/pokedex_controller.dart';
import 'package:persistencia_flutter/pokedex/presentation/pokemon_screen.dart';
import 'package:svg_flutter/svg.dart';


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

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('pokedex-pkmn-${pokemon.id}'),
      onTap: () {
        //Navigation
       Navigator.of(context).push(
             MaterialPageRoute(builder: (ctx) => PokemonScreen(pokemon: pokemon)));
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

class PokemonTypesColumn extends StatelessWidget {
  const PokemonTypesColumn({super.key, required this.pokemon});

  final Pokemon pokemon;
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

class PokemonAvatar extends StatelessWidget {
  const PokemonAvatar({
    super.key,
    required this.pokemon,
  });
  final Pokemon pokemon;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
          right: 0,
          top: 0,
          child: SvgPicture.asset(
            'assets/pokeball.svg',
            fit: BoxFit.contain,
            width: 80,
            height: 80,
            color: pokemon.onContainerColor(),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 2,
          child: PokemonPicture(
            svg: pokemon.imageUrl,
            id: pokemon.id,
          ),
        )
      ],
    );
  }
}

class PokemonPicture extends StatefulWidget {
  const PokemonPicture({
    super.key,
    required this.svg,
    required this.id,
  });

  final String svg;
  final int id;

  @override
  State<PokemonPicture> createState() => _PokemonPictureState();
}

class _PokemonPictureState extends State<PokemonPicture>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 3000));
  late final Animation _animation = Tween<double>(begin: 60.0, end: 70.0)
      .chain(CurveTween(curve: Curves.easeInExpo))
      .animate(_controller);
  @override
  void initState() {
    super.initState();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2;
    return Hero(
      flightShuttleBuilder: (flightContext, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        final Widget toHero = toHeroContext.widget;
        return ScaleTransition(
          scale: animation.drive(
            Tween<double>(begin: 0.0, end: 1.0).chain(
              CurveTween(
                curve: Interval(0.0, 1.0, curve: PeakQuadraticCurve()),
              ),
            ),
          ),
          child: flightDirection == HeroFlightDirection.push
              ? RotationTransition(turns: animation, child: toHero)
              : FadeTransition(
                  opacity: animation.drive(
                    Tween<double>(begin: 0.0, end: 1.0).chain(
                      CurveTween(
                        curve:
                            Interval(0.0, 1.0, curve: ValleyQuadraticCurve()),
                      ),
                    ),
                  ),
                  child: toHero,
                ),
        );
      },
      tag: 'pokemon-${widget.id}',
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, value) {
            return SizedBox(
              width: _animation.value,
              height: _animation.value,
              child: SvgPicture.network(
                widget.svg,
                fit: BoxFit.contain,
              ),
            );
          }),
    );
  }
}

class PeakQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return -15 * pow(t, 2) + 15 * t + 1;
  }
}

class ValleyQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    return 4 * pow(t - 0.5, 2).toDouble();
  }
}

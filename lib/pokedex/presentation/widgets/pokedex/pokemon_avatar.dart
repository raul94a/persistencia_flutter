import 'dart:math';

import 'package:flutter/material.dart';
import 'package:persistencia_flutter/pokedex/data/models/local/pokemon.dart';

import 'package:svg_flutter/svg.dart';

class PokemonAvatar extends StatelessWidget {
  const PokemonAvatar({
    super.key,
    required this.pokemon,
  });
  final PokemonEntity pokemon;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
          right: 0,
          top: 0,
          child: SvgPicture.asset('assets/pokeball.svg',
              fit: BoxFit.fill,
              width: 80,
              height: 80,
              // ignore: deprecated_member_use
              color: pokemon.onContainerColor()),
        ),
        Positioned(
          right: 0,
          bottom: 1,
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
                fit: BoxFit.fill,
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

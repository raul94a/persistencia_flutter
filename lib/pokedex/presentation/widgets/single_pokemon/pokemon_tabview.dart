import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistencia_flutter/core/extensions/string_extensions.dart';
import 'package:persistencia_flutter/pokedex/data/pokemon.dart';
import 'package:persistencia_flutter/pokedex/data/species.dart';
import 'package:persistencia_flutter/pokedex/data/type.dart';
import 'package:persistencia_flutter/pokedex/presentation/controller/pokedex_controller.dart';
import 'package:persistencia_flutter/styles/pokemon_types_color.dart';
import 'package:svg_flutter/svg_flutter.dart';

class PokemonTabView extends StatelessWidget {
  const PokemonTabView({
    super.key,
    required this.containerHeight,
    required this.pokemon,
  });

  final double containerHeight;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.0), topRight: Radius.circular(28.0))),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
                padding: const EdgeInsets.all(3.0),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                labelColor: Colors.black,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                indicatorColor: pokemon.containerColor(),
                tabs: const [
                  Tab(
                    text: 'About',
                  ),
                  Tab(
                    text: 'Stats',
                  ),
                  Tab(
                    text: 'Evolution',
                  ),
                  Tab(
                    text: 'Moves',
                  ),
                ]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TabBarView(children: [
                  AboutTab(
                    pokemon: pokemon,
                  ),
                  StatsTab(pokemon: pokemon),
                  EvolutionTab(pokemonID: pokemon.id),
                  const SizedBox.expand()
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EvolutionTab extends ConsumerWidget {
  const EvolutionTab({super.key, required this.pokemonID});
  final int pokemonID;
  @override
  Widget build(BuildContext context, ref) {
    final pokemon = ref.watch(pokedexProvider.select((value) =>
        value.pokemons.firstWhere((element) => element.id == pokemonID)));
    final evolutionChain = pokemon.getEvolutionChainCleaned();
    String? evolveFromImageUrl;
    if (pokemon.species?.evolvesFrom != null) {
      evolveFromImageUrl = getPokemonImage(ref, pokemon.species!.evolvesFrom!);
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          // evolves from

          if (pokemon.species?.evolvesFrom != null &&
              evolveFromImageUrl != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Evolves from',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                _EvolutionChainPokemon(
                    image: getPokemonImage(ref, pokemon.species!.evolvesFrom!),
                    evolution:
                        pokemon.getEvolution(pokemon.species!.evolvesFrom!)),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          // evolves to
          if (evolutionChain.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Evolves to',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15.0,
                        ),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: evolutionChain.length,
                    itemBuilder: (ctx, i) {
                      final evolution = evolutionChain[i];
                      final image = getPokemonImage(ref, evolution.name);
                      return _EvolutionChainPokemon(
                          image: image, evolution: evolution);
                    }),
              ],
            )
        ],
      ),
    );
  }

  String? getPokemonImage(WidgetRef ref, String name) {
    final provider = ref.read(pokedexProvider);
    try {
      return provider.getImageByName(name);
    } catch (e) {
      return null;
    }
  }
}

class _EvolutionChainPokemon extends StatelessWidget {
  const _EvolutionChainPokemon({
    super.key,
    required this.image,
    required this.evolution,
  });

  final String? image;
  final Evolution evolution;

  @override
  Widget build(BuildContext context) {
    if (image == null) return const SizedBox.shrink();
    return Row(
      children: [
        SizedBox(width: 160, height: 160, child: SvgPicture.network(image!)),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evolution.name.capitalizeFirst(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10.0),
            Text(
              getEvolutionMode(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  String getEvolutionMode() {
    if (evolution.evolutionDetails?.minLevel != null) {
      return 'Level: ${evolution.evolutionDetails?.minLevel}';
    }
    if (evolution.evolutionDetails?.item != null) {
      return 'Item ${evolution.evolutionDetails?.item}';
    }
    return '';
  }
}

class StatsTab extends ConsumerWidget {
  const StatsTab({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchedPokemon = ref.watch(pokedexProvider.select((value) =>
        value.pokemons.firstWhere((element) => element.id == pokemon.id)));
    final damageCoefficients = watchedPokemon.getDamageCoefficients();
    return ListView(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        ...watchedPokemon.stats
            .map((e) => StatRow(
                  statName: e.maybeGetShorterName(),
                  statFraction: e.fraction,
                  baseStat: e.baseStat,
                ))
            .toList(),
        StatRow(
            statName: 'Total',
            baseStat: watchedPokemon.statAggregationRecord().$1,
            statFraction: watchedPokemon.statAggregationRecord().$2),
        const SizedBox(
          height: 30.0,
        ),
        const Text(
          'Type defenses',
          style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 37, 37, 37),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'The effectiveness of each type on ${pokemon.name.capitalizeFirst()}.',
          style: const TextStyle(
            color: Color.fromARGB(255, 110, 110, 110),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        GridView.builder(
            shrinkWrap: true,
            primary: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 5 / 3),
            itemCount: damageCoefficients.length,
            itemBuilder: (ctx, index) {
              final damageCoefficient = damageCoefficients[index];
              return _TypeGridContainer(damageCoefficient: damageCoefficient);
            })
      ],
    );
  }
}

class _TypeGridContainer extends StatelessWidget {
  const _TypeGridContainer({
    super.key,
    required this.damageCoefficient,
  });

  final DamageCoefficients damageCoefficient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          height: 100,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color:
                  pokemonTypesColors[damageCoefficient.type]!.onContainerColor,
              borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                damageCoefficient.type.capitalizeFirst(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(1),
                width: 66,
                height: 40,
                decoration: BoxDecoration(
                    color: pokemonTypesColors[damageCoefficient.type]!
                        .containerColor,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Center(
                    child: Text(
                  'x ${damageCoefficient.coefficient}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                )),
              )
            ],
          )),
    );
  }
}

class StatRow extends StatelessWidget {
  const StatRow(
      {super.key,
      required this.statName,
      required this.baseStat,
      required this.statFraction});
  final String statName;
  final int baseStat;
  final double statFraction;
  static const barHeight = 6.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          SizedBox(
              width: 80,
              child: Text(
                statName,
                style: const TextStyle(
                    color: Color.fromARGB(255, 110, 109, 109), fontSize: 15),
              )),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
              width: 50,
              child: Text(
                baseStat.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          const SizedBox(
            width: 40,
          ),
          Expanded(
              child: Container(
            height: barHeight,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 238, 238),
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: statFraction,
              child: Container(
                height: barHeight,
                decoration: BoxDecoration(
                    color:
                        baseStat < 50 ? Colors.redAccent : Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class AboutTab extends ConsumerWidget {
  const AboutTab({
    super.key,
    required this.pokemon,
  });
  final Pokemon pokemon;
  @override
  Widget build(BuildContext context, ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Basic Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        _AboutRow(
          title: 'Height',
          value: '${pokemon.height / 10} m',
        ),
        _AboutRow(
          title: 'Weight',
          value: '${pokemon.weight} lb',
        ),
        _AboutRow(
          title: 'Abilities',
          value: pokemon.abilities.join(', '),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Breeding',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Consumer(builder: (context, ref, _) {
          final pokemons = ref.watch(pokedexProvider).pokemons;
          final watchedPokemon =
              pokemons.firstWhere((element) => element.id == pokemon.id);
          final eggGroups = watchedPokemon.species?.eggGroups;
          return Column(
            children: [
              _AboutRow(
                  title: 'Habitat',
                  value: watchedPokemon.species?.habitat ?? ''),
              _AboutRow(
                  title: 'Growth rate',
                  value: watchedPokemon.species?.growthRate ?? ''),
              _AboutRow(
                  title: 'Egg groups', value: eggGroups?.join(', ') ?? ''),
            ],
          );
        })
      ],
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({super.key, required this.title, required this.value});

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child: Text(
                title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 110, 109, 109), fontSize: 15),
              )),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Text(value,
                maxLines: 2,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
    );
  }
}

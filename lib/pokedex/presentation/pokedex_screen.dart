// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistencia_flutter/core/constants/constants.dart';
import 'package:persistencia_flutter/pokedex/presentation/controller/pokedex_controller.dart';
import 'package:persistencia_flutter/pokedex/presentation/widgets/pokedex/pokemon_grid.dart';
import 'package:persistencia_flutter/pokedex/presentation/widgets/pokedex/pokedex_title.dart';
import 'package:svg_flutter/svg_flutter.dart';

class PokedexScreen extends ConsumerStatefulWidget {
  const PokedexScreen({super.key});

  @override
  ConsumerState<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends ConsumerState<PokedexScreen> {
  final key = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  int offset = 0;
  bool canFetch = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(pokedexProvider.notifier)
          .loadPokemons(offset, limitPokemonPerRequest)
          .then((value) {
        offset += limitPokemonPerRequest;
      });
    });
    scrollingListener();
  }

  void scrollingListener() {
    scrollController.addListener(() async {
      if (offset == maxPokemon) {
        return;
      }
      const sensibility = 0.5;
      final position = scrollController.position.pixels;
      final maxExtent = scrollController.position.maxScrollExtent;
      // debugPrint('Position: $position');
      // debugPrint('MaxExtent: $maxExtent');
      final reachedTriggerPoint = (position > maxExtent * sensibility);
      bool isReadyToFetch = (canFetch && reachedTriggerPoint);
      if (isReadyToFetch) {
        canFetch = false;
        try {
          await ref
              .read(pokedexProvider.notifier)
              .loadPokemons(offset, limitPokemonPerRequest);

          offset += limitPokemonPerRequest;
          if (offset + limitPokemonPerRequest > maxPokemon) {
            int newLimit = maxPokemon - offset;
            int newOffset = offset;
            offset = maxPokemon;

            await ref
                .read(pokedexProvider.notifier)
                .loadPokemons(newOffset, newLimit);
            return;
          }
        } catch (e) {
          debugPrint('$e');
        } finally {
          canFetch = true;
        }
      }
    });
  }

  @override
  void dispose() {
    key.currentState?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          const Positioned(right: -40, top: 25, child: PokeballPicture()),
          Scaffold(
              backgroundColor: Colors.transparent,
              drawer: const Drawer(),
              key: key,
              appBar: PokemonAppBar(scaffoldKey: key),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer(builder: (context, ref, child) {
                    final loading = ref.watch(
                        pokedexProvider.select((value) => value.loading));
                    return PokedexTitle(
                      showLoadingSpinner: loading,
                    );
                  }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: PokemonGrid(scrollController: scrollController),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class PokemonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PokemonAppBar({
    super.key,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: scaffoldKey.currentState?.openDrawer,
            icon: const Icon(
              Icons.menu_sharp,
              color: Colors.black,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}

class PokeballPicture extends StatelessWidget {
  const PokeballPicture({super.key, this.scale = 1.7, this.width, this.color});
  final double scale;
  final Color? color;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SvgPicture.asset(
        'assets/pokeball.svg',
        width: width ?? 125,
        height: width ?? 125,
        color: color ?? const Color.fromARGB(255, 219, 218, 218),
      ),
    );
  }
}

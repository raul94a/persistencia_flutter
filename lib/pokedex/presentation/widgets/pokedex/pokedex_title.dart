import 'package:flutter/material.dart';

class PokedexTitle extends StatelessWidget {
  const PokedexTitle({
    super.key,
    this.showLoadingSpinner = false,
  });
  final bool showLoadingSpinner;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(left: 20.0),
      child: Row(
        children: [
          const Text(
            'Pokedex',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          Visibility(
              visible: showLoadingSpinner,
              child: const SizedBox(
                  width: 25, height: 25, child: CircularProgressIndicator()))
        ],
      ),
    );
  }
}

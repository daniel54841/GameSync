import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../games_sort_provider.dart';

class GamesSortDropdown extends ConsumerWidget {
  const GamesSortDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortType = ref.watch(gamesSortTypeProvider);

    return DropdownButton<GamesSortType>(
      value: sortType,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      onChanged: (value) {
        if (value != null) {
          ref.read(gamesSortTypeProvider.notifier).state = value;
        }
      },
      items:  [
        DropdownMenuItem(
          value: GamesSortType.hoursDesc,
          child: Text("Más jugados primero",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),),
        ),
        DropdownMenuItem(
          value: GamesSortType.hoursAsc,
          child: Text("Menos jugados primero"),
        ),
      ],
    );
  }
}

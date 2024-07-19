import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/event.dart';
import '../../utils/exports/logics.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<EventBloc>().add(ToggleFavoriteEvent(event.id));
      },
      icon: Icon(
        event.isLiked ? Icons.favorite : Icons.favorite_border_rounded,
        color: Colors.redAccent,
      ),
    );
  }
}

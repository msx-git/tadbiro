import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tadbiro/ui/screen/my_events/widgets/edit_event_screen.dart';
import 'package:tadbiro/utils/extensions/sizedbox_extension.dart';

import '../../../../data/models/event.dart';
import '../../../../utils/exports/logics.dart';

class MyEventItem extends StatelessWidget {
  const MyEventItem({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                      imageUrl: event.bannerImageUrl, fit: BoxFit.cover),
                ),
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat("HH:mm, d-MMMM, yyyy").format(event.date),
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${event.placeInfo.split('. ')[0].replaceFirst("Street: ", '')}\n"
                        "${event.placeInfo.split('. ')[2].replaceFirst("Locality: ", '')}",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: PopupMenuButton(
            offset: const Offset(-30, 30),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditEventScreen(event: event),
                    ),
                  ),
                  child: const Text('Tahrirlash'),
                ),
                PopupMenuItem(
                  onTap: () {
                    context
                        .read<EventBloc>()
                        .add(DeleteEventEvent(id: event.id));
                  },
                  child: const Text("O'chirish"),
                ),
              ];
            },
          ),
        )
      ],
    );
  }
}

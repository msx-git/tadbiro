import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiro/ui/screen/my_events/widgets/my_event_item.dart';
import 'package:tadbiro/utils/exports/navigation.dart';

import '../../../logic/blocs/event/event_bloc.dart';
import '../home/widgets/event_item.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mening tadbirlarim'),
        actions: [
          IconButton(
            onPressed: () =>
                navigationService.navigateTo(AppRoute.notifications),
            icon: const Icon(Icons.notifications_none_rounded),
          )
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Tashkil qilganlarim'),
                Tab(text: 'Yaqinda'),
                Tab(text: 'Ishtirok etganrlarim'),
                Tab(text: 'Bekor qilganlarim'),
              ],
              isScrollable: true,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  /// ONLY MY EVENTS
                  BlocBuilder<EventBloc, EventStates>(
                    builder: (context, state) {
                      if (state is InitialEventsState) {
                        return const Center(
                          child: Text('Tadbirlarni hali yuklanmadi.'),
                        );
                      }
                      if (state is LoadingEventsState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is ErrorEventsState) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      }
                      final myEvents = (state as LoadedEventsState)
                          .events
                          .where((event) => event.organizerId == userId)
                          .toList();
                      return ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: myEvents.length,
                        itemBuilder: (context, index) {
                          final event = myEvents[index];
                          return MyEventItem(event: event);
                        },
                      );
                    },
                  ),

                  /// UPCOMING EVENTS OF OTHERS
                  BlocBuilder<EventBloc, EventStates>(
                    builder: (context, state) {
                      if (state is InitialEventsState) {
                        return const Center(
                          child: Text('Tadbirlarni hali yuklanmadi.'),
                        );
                      }
                      if (state is LoadingEventsState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is ErrorEventsState) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      }
                      final myEvents = (state as LoadedEventsState)
                          .events
                          .where((event) => event.organizerId != userId)
                          .toList();
                      myEvents.sort((a, b) => a.date.compareTo(b.date));
                      if (myEvents.isEmpty) {
                        return const Center(
                          child: Text("Tadbirlar mavjud emas."),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: myEvents.length,
                        itemBuilder: (context, index) {
                          final event = myEvents[index];
                          return EventItem(event: event);
                        },
                      );
                    },
                  ),
                  const Center(
                    child: Text('Ishtirok etganrlarim'),
                  ),
                  const Center(
                    child: Text('Bekor qilganlarim'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationService.navigateTo(AppRoute.addEvent),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 'https://marketplace.canva.com/EAFs0xT8XBA/1/0/1131w/canva-black-gold-luxury-elegant-celebration-company-anniversary-poster-30Gv5fdXLiE.jpg',

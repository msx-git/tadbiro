import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiro/ui/screen/home/widgets/event_item.dart';
import 'package:tadbiro/ui/widgets/app_drawer.dart';
import 'package:tadbiro/utils/exports/navigation.dart';

import '../../../logic/blocs/event/event_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bosh Sahifa'),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     context.read<AuthBloc>().add(LogoutEvent());
          //   },
          //   icon: const Icon(Icons.logout),
          // ),
          IconButton(
            onPressed: () =>
                navigationService.navigateTo(AppRoute.notifications),
            icon: const Icon(Icons.notifications_none_rounded),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: SearchBar(
                leading: const Icon(CupertinoIcons.search),
                hintText: "Tadbirlarni izlash...",
                trailing: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Barcha tadbirlar"),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<EventBloc, EventStates>(
              bloc: context.read<EventBloc>()..add(GetEventsEvent()),
              builder: (context, state) {
                if (state is InitialEventsState) {
                  return const Center(child: Text("Tadbirlar yuklanmadi."));
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
                final events = (state as LoadedEventsState).events;
                if (events.isEmpty) {
                  return const Center(
                    child: Text("Tadbirlar mavjud emas."),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    // debugPrint("list builder");
                    final event = events[index];
                    return EventItem(event: event);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

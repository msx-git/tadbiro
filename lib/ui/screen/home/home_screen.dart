import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadbiro/ui/screen/home/widgets/event_item.dart';
import 'package:tadbiro/ui/screen/home/widgets/week_event_item.dart';
import 'package:tadbiro/ui/widgets/app_drawer.dart';
import 'package:tadbiro/utils/exports/navigation.dart';

import '../../../data/models/user.dart';
import '../../../utils/exports/logics.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final userData = prefs.getString("userData");
      if (userData == null) {
        throw ("Error getting userData");
      }
      final currentUser = User.fromJson2(jsonDecode(userData));
      return currentUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("Couldn't get user."),
            );
          }
          final user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Bosh Sahifa'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  },
                  icon: const Icon(Icons.logout),
                ),
                IconButton(
                  onPressed: () =>
                      navigationService.navigateTo(AppRoute.notifications),
                  icon: const Icon(Icons.notifications_none_rounded),
                )
              ],
            ),
            drawer: AppDrawer(user: user!),
            body: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Yaqin 7 kun ichida",
                        style: GoogleFonts.caveat(
                            fontSize: 28, fontWeight: FontWeight.w700)),
                  ),
                ),

                /// WITHIN 7 DAYS EVENTS
                SliverToBoxAdapter(
                  child: BlocBuilder<EventBloc, EventStates>(
                    bloc: context.read<EventBloc>()..add(GetEventsEvent()),
                    builder: (context, state) {
                      if (state is InitialEventsState) {
                        return const Center(
                            child: Text("Tadbirlar yuklanmadi."));
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
                      final events = (state as LoadedEventsState)
                          .events
                          .where(
                            (event) => event.date.isBefore(
                              DateTime.now().add(const Duration(days: 7)),
                            ),
                          )
                          .toList();
                      events.sort((a, b) => a.date.compareTo(b.date));
                      if (events.isEmpty) {
                        return const Center(
                          child: Text("Tadbirlar mavjud emas."),
                        );
                      }
                      return SizedBox(
                        height: 250,
                        child: PageView.builder(
                          padEnds: false,
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return WeekEventItem(event: event);
                          },
                        ),
                      );
                    },
                  ),
                ),

                /// ALL EVENTS
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Barcha tadbirlar",
                      style: GoogleFonts.caveat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<EventBloc, EventStates>(
                    bloc: context.read<EventBloc>()..add(GetEventsEvent()),
                    builder: (context, state) {
                      if (state is InitialEventsState) {
                        return const Center(
                            child: Text("Tadbirlar yuklanmadi."));
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
                      events.sort((a, b) => a.date.compareTo(b.date));
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
                          final event = events[index];
                          return GestureDetector(
                            onTap: () => navigationService
                                .navigateTo(AppRoute.eventDetails,arguments: [event, user]),
                            child: EventItem(event: event),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

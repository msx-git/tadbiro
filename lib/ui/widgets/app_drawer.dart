import 'package:flutter/material.dart';
import 'package:tadbiro/utils/exports/navigation.dart';

import '../../data/models/user.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SafeArea(
            child: ListTile(
              leading: const CircleAvatar(),
              title: Text("${user.firstName} ${user.lastName}"),
              subtitle: Text(user.email),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text("Mening tadbirlarim"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => navigationService.navigateTo(AppRoute.myEvents,
                arguments: user.id),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil ma'lumotlari"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => navigationService.navigateTo(AppRoute.profile),
          ),
          ListTile(
            leading: const Icon(Icons.translate_rounded),
            title: const Text("Tilni o'zgartirish"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => navigationService.navigateTo(AppRoute.languages),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text("Kunduzgi/tungi holat"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => navigationService.navigateTo(AppRoute.modes),
          ),
        ],
      ),
    );
  }
}

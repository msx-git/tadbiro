import 'package:flutter/material.dart';
import 'package:tadbiro/utils/exports/navigation.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SafeArea(
            child: ListTile(
              leading: CircleAvatar(),
              title: Text("Ism Familya"),
              subtitle: Text("e-pochta@gmail.com"),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text("Mening tadbirlarim"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => navigationService.navigateTo(AppRoute.myEvents),
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
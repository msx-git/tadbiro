import 'package:flutter/material.dart';
import 'package:tadbiro/utils/exports/navigation.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyEventsScreen')),
      body: const Center(child: Text('MyEventsScreen')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationService.navigateTo(AppRoute.addEvent),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 'https://marketplace.canva.com/EAFs0xT8XBA/1/0/1131w/canva-black-gold-luxury-elegant-celebration-company-anniversary-poster-30Gv5fdXLiE.jpg',

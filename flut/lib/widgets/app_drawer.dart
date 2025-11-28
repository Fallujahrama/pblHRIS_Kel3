import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => context.go('/home'),
          ),

          ListTile(
            leading: const Icon(Icons.group),
            title: const Text("Superior"),
            onTap: () => context.go('/superior'),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Letters"),
            onTap: () => context.go('/letters'),
          ),
        ],
      ),
    );
  }
}

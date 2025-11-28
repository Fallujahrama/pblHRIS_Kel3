import 'package:flutter/material.dart';
import '../../../widgets/app_drawer.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selamat Datang"),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mail_outline,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 30),
              const Text(
                'Letter App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Aplikasi Pembuatan Surat',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () => context.push('/letters'),
                icon: const Icon(Icons.description),
                label: const Text('Lihat Template Surat'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/superior_api.dart';
import '../models/superior.dart';
import '../widgets/superior_tile.dart';
import '../../../widgets/app_drawer.dart';

class SuperiorScreen extends StatefulWidget {
  const SuperiorScreen({super.key});

  @override
  State<SuperiorScreen> createState() => _SuperiorScreenState();
}

class _SuperiorScreenState extends State<SuperiorScreen> {
  late Future<List<Superior>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = SuperiorApi.getSuperiors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Data Superior")),

      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada data"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return SuperiorTile(item: data[index]);
            },
          );
        },
      ),
    );
  }
}

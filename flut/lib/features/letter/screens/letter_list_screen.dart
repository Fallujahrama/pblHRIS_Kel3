import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/letter_controller.dart';
import '../models/letter_format.dart';

class LettersListScreen extends StatefulWidget {
  const LettersListScreen({super.key});

  @override
  State<LettersListScreen> createState() => _LettersListScreenState();
}

class _LettersListScreenState extends State<LettersListScreen> {
  final controller = LetterController();
  List<LetterFormat> formats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() => isLoading = true);
    formats = await controller.fetchLetterFormats();
    setState(() => isLoading = false);
    print('Loaded ${formats.length} formats'); // Debug
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text("Template Surat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : formats.isEmpty
              ? const Center(child: Text("Tidak ada template surat"))
              : ListView.builder(
                  itemCount: formats.length,
                  itemBuilder: (_, i) {
                    final item = formats[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.description),
                        ),
                        title: Text(item.name),
                        subtitle: Text(
                          item.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          context.push('/letter/create', extra: item);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

// File: lib/widgets/items_list.dart
import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/item_service.dart';

class ItemsList extends StatefulWidget {
  final ItemService itemService;
  // We are injecting the item service class here, to isolate the widget.
  // Cleaner and easier to test.
  const ItemsList({super.key, required this.itemService});

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  late Future<List<Item>> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = widget.itemService.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                title: Text(item.title),
                key: Key('item_${item.id}'),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

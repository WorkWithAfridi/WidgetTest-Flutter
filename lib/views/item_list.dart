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
  late List<Item> items = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchItemList();
  }

  Future fetchItemList() async {
    try {
      items = await widget.itemService.fetchItems();
    } catch (e) {
      items = [];
      errorMessage = "Failed to fetch data";
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        key: GlobalObjectKey("LOADING_INDICATOR"),
      ));
    } else if (errorMessage != null) {
      return Center(child: Text(errorMessage ?? ""));
    } else {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Text(items[index].title);
        },
      );
    }
  }
}

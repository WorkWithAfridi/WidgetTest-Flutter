import '../models/item.dart';

abstract class ItemService {
  Future<List<Item>> fetchItems();
}

class DemoItemServices implements ItemService {
  @override
  Future<List<Item>> fetchItems() async {
    return [];
  }
}

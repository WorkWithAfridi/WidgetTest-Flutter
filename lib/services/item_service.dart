import 'package:widget_test/models/item.dart';

abstract class ItemService {
  Future<List<Item>> fetchItems();
}

class DemoItemService implements ItemService {
  @override
  Future<List<Item>> fetchItems() async {
    return [];
  }
}

// File: test/widgets/items_list_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:widget_test/models/item.dart';
import 'package:widget_test/services/item_service.dart';
import 'package:widget_test/views/item_list.dart';

import 'items_list_test.mocks.dart';

// Generate ItemService mock by using Mokito and build runner.
// MockItemService can simply be generate by adding them in the annotated list in the annotated GenerateMocks from Mokito
// and then by running dart run build_runner build
@GenerateMocks([ItemService])
void main() {
  late MockItemService mockItemService;
  List<Item> mockItems = [];

  // We create a mock ItemService and a list of 100 items.
  setUp(() async {
    mockItemService = MockItemService();
    mockItems = List.generate(100, (index) => Item(id: index, title: 'Item $index'));
    // Ensure this is not accidentally inside a condition that isn't always true

    when(mockItemService.fetchItems()).thenAnswer((_) async {
      return mockItems;
    });
  });
  // The setUp func makes sure all of our services are up and running, before we
  // pump the widget.
  // And since we've already mocked the ItemServide class, we can now manupulate the
  // returned data any way we like. Which is being done in the when()... block

  test('Test Mock Service', () async {
    expect(await mockItemService.fetchItems(), equals(mockItems));
  }); // This tests if the mock service is working

  testWidgets('ItemsList displays items and allows scrolling', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: ItemsList(
            itemService: mockItemService,
          ),
        ),
      ),
    ); // This pumps the MaterialApp along with our list widget, thats to be tested.
    // .pumpWidget, initializes the widget and prepares it to be tested/ run.

    // Complete the futures and animations
    await tester.pumpAndSettle();

    // Initial item checks
    expect(find.text('Item 0'), findsOneWidget);
    // This checks the rendered UI and crosschecks if the rendered items contain any widget with
    // the text "Item 0".

    expect(find.text('Item 99'), findsNothing);
    // This checks the rendered UI and crosschecks if the rendered items does not contain any widget with
    // the text "Item 99".

    // Perform a scroll to reveal the last item
    await tester.drag(find.byType(ListView), const Offset(0, -5000));

    // Runs the required functions and animations
    await tester.pumpAndSettle();

    // Verify that the last item is now in view
    expect(find.text('Item 99'), findsOneWidget);
    // This again checks the rendered UI and crosschecks if the rendered items contain any widget with
    // the text "Item 99".
  });
}

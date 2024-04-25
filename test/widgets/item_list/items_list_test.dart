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
  late MockItemService? mockItemService;
  late List<Item>? mockItems;

  group("Test - Basic loading and scrolling behavior", () {
    // We create a mock ItemService and a list of 100 items.
    // The setUp func makes sure all of our services are up and running, before we
    // pump the widget.
    // And since we've already mocked the ItemServide class, we can now manupulate the
    // returned data any way we like. Which is being done in the when()... block

    // setUp gets called before each test
    setUp(() async {
      mockItemService = MockItemService();
      mockItems = List.generate(100, (index) => Item(id: index, title: 'Item $index'));

      when(mockItemService!.fetchItems()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return mockItems!;
      });
    });

    // This tests if the mock service is working
    test('Test - Mock Service', () async {
      expect(await mockItemService?.fetchItems(), equals(mockItems));
    });

    testWidgets("Test - Loading indicator", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemsList(itemService: mockItemService!),
          ),
        ),
      );
      await tester.pump(); // Trigger a frame to show the loading state

      // Checks if the ui rendered a loading indicator or not.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // To pump out the remaining frames
      await tester.pumpAndSettle();
    });

    // This pumps the MaterialApp along with our list widget, thats being tested.
    // .pumpWidget, initializes the widget and prepares it to be tested/ run.
    testWidgets('Test - Scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Scaffold(
            body: ItemsList(
              itemService: mockItemService!,
            ),
          ),
        ),
      );

      // Complete the futures and animations by repeatly calling pump
      await tester.pumpAndSettle();

      // Initial item checks
      // This checks the rendered UI and crosschecks if the rendered items contain any widget with
      // the text "Item 0".
      expect(find.text('Item 0'), findsOneWidget);

      // This checks the rendered UI and whether or not the rendered items contain item 99 or not
      expect(find.text('Item 99'), findsNothing);

      // Perform a scroll to reveal the last item,
      await tester.drag(find.byType(ListView), const Offset(0, -5000));

      // Runs the required functions and animations
      await tester.pumpAndSettle();

      // Verify that the last item is now in view
      // This func again checks the rendered UI and crosschecks if the rendered items contain any widget with
      // the text "Item 99".
      expect(find.text('Item 99'), findsOneWidget);
    });

    tearDown(() {
      mockItemService = null;
      mockItems = null;
    });
  });

  group("Test - Basic error handling", () {
    // We create a mock ItemService and a list of 100 items.
    // The setUp func makes sure all of our services are up and running, before we
    // pump the widget.
    // And since we've already mocked the ItemServide class, we can now manupulate the
    // returned data any way we like. Which is being done in the when()... block
    setUp(() async {
      mockItemService = MockItemService();
      when(mockItemService?.fetchItems()).thenAnswer((realInvocation) async {
        await Future.delayed(const Duration(seconds: 1)).then((value) {
          throw Exception('Failed to fetch data');
        });
      });
    });

    // Test to simulate an error during fetch
    testWidgets('Test - Error in fetch request', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemsList(itemService: mockItemService!),
          ),
        ),
      );

      // Pumps out the remaining frames
      await tester.pumpAndSettle();

      // Check that the widget shows an error message
      expect(find.text('Failed to fetch data'), findsOneWidget);

      // Ensure no items are displayed
      expect(find.byType(ListTile), findsNothing);
    });
  });
}

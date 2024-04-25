import 'package:flutter/material.dart';
import 'package:widget_test/services/item_service.dart';
import 'package:widget_test/views/item_list.dart';

void main() {
  runApp(const MyWidgetTestDemoApp());
}

class MyWidgetTestDemoApp extends StatelessWidget {
  const MyWidgetTestDemoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ItemsList(
        itemService: DemoItemService(),
      ),
    );
  }
}

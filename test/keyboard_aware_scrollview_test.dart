import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_aware_scrollview/keyboard_aware_scrollview.dart';

void main() {
  group('KeyboardAwareScrollView', () {
    testWidgets('renders children correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              children: [
                const Text('Child 1'),
                const Text('Child 2'),
                const Text('Child 3'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
      expect(find.text('Child 3'), findsOneWidget);
    });

    testWidgets('applies spacing between children', (WidgetTester tester) async {
      const spacing = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              spacing: spacing,
              children: [
                Container(height: 50, color: Colors.red),
                Container(height: 50, color: Colors.blue),
              ],
            ),
          ),
        ),
      );

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(Column),
        ),
      );

      expect(column.spacing, equals(spacing));
    });

    testWidgets('applies crossAxisAlignment correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Test'),
              ],
            ),
          ),
        ),
      );

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(Column),
        ),
      );

      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.center));
    });

    testWidgets('applies scroll padding correctly', (WidgetTester tester) async {
      const padding = EdgeInsets.all(16.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              scrollPadding: padding,
              children: [
                const Text('Test'),
              ],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(SingleChildScrollView),
        ),
      );

      expect(scrollView.padding, equals(padding));
    });

    testWidgets('uses custom scroll controller', (WidgetTester tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              scrollController: controller,
              children: [
                Container(height: 1000),
              ],
            ),
          ),
        ),
      );

      expect(controller.hasClients, isTrue);

      controller.dispose();
    });

    testWidgets('applies scroll physics correctly', (WidgetTester tester) async {
      const physics = NeverScrollableScrollPhysics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              scrollPhysics: physics,
              children: [
                const Text('Test'),
              ],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(SingleChildScrollView),
        ),
      );

      expect(scrollView.physics, equals(physics));
    });

    testWidgets('applies keyboardDismissBehavior correctly', (WidgetTester tester) async {
      const behavior = ScrollViewKeyboardDismissBehavior.onDrag;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              keyboardDismissBehavior: behavior,
              children: [
                const Text('Test'),
              ],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(SingleChildScrollView),
        ),
      );

      expect(scrollView.keyboardDismissBehavior, equals(behavior));
    });

    testWidgets('does not adjust height when keyboard is not visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              children: [
                Container(height: 100),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(SizedBox),
        ),
      );

      // When keyboard is not visible, height should be null
      expect(sizedBox.height, isNull);
    });

    testWidgets('widget structure remains valid when keyboard appears', (WidgetTester tester) async {
      // Set a specific size for the test
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      // Use a ValueNotifier to control keyboard height without rebuilding the widget
      final keyboardHeight = ValueNotifier<double>(0);

      // Build the widget tree - place widget near bottom so keyboard will overlap it
      await tester.pumpWidget(
        MaterialApp(
          home: ValueListenableBuilder<double>(
            valueListenable: keyboardHeight,
            builder: (context, height, _) {
              return MediaQuery(
                data: MediaQueryData(
                  size: const Size(400, 800),
                  viewInsets: EdgeInsets.only(bottom: height),
                ),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    children: [
                      const SizedBox(height: 200),
                      KeyboardAwareScrollView(
                        children: [
                          Container(height: 400, color: Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Now simulate keyboard appearing with 300px height
      keyboardHeight.value = 300;
      await tester.pump(); // Trigger the rebuild
      await tester.pumpAndSettle(); // Wait for all animations and post-frame callbacks

      // Verify widget still renders correctly with keyboard
      expect(find.byType(KeyboardAwareScrollView), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, isNotNull);

      // Reset the physical size
      tester.view.resetPhysicalSize();
    });

    testWidgets('ignores small keyboard height changes (less than 70px)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              viewInsets: EdgeInsets.only(bottom: 50), // Less than 70px threshold
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: KeyboardAwareScrollView(
                children: [
                  Container(height: 600),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(SizedBox),
        ),
      );

      // Should not adjust for small keyboard heights
      expect(sizedBox.height, isNull);
    });

    testWidgets('works with empty children list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              children: [],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(KeyboardAwareScrollView), findsOneWidget);
    });

    testWidgets('handles single child correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardAwareScrollView(
              children: [
                const Text('Single child'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Single child'), findsOneWidget);
    });

    testWidgets('recalculates dimensions when recalculationKeys change with keyboard visible', (
      WidgetTester tester,
    ) async {
      // Set a specific size for the test
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      // Use ValueNotifiers to control keyboard and content
      final keyboardHeight = ValueNotifier<double>(0);
      final contentHeight = ValueNotifier<double>(400);

      // Build the widget tree - place widget near bottom so keyboard will overlap it
      await tester.pumpWidget(
        MaterialApp(
          home: ValueListenableBuilder<double>(
            valueListenable: keyboardHeight,
            builder: (context, kbHeight, _) {
              return MediaQuery(
                data: MediaQueryData(
                  size: const Size(400, 800),
                  viewInsets: EdgeInsets.only(bottom: kbHeight),
                ),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    children: [
                      const SizedBox(height: 200),
                      ValueListenableBuilder<double>(
                        valueListenable: contentHeight,
                        builder: (context, height, _) {
                          return KeyboardAwareScrollView(
                            recalculationKeys: [height],
                            children: [
                              Container(height: height, color: Colors.red),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Simulate keyboard appearing with 300px height
      keyboardHeight.value = 300;
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify widget is constrained by keyboard
      var sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, isNotNull);
      final initialHeight = sizedBox.height;

      // Now change content to be smaller (200px instead of 400px)
      // Remaining space after keyboard: 800 - 300 - 200 (top offset) = 300px
      // New content height: 200px (fits within remaining space)
      contentHeight.value = 200;
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify dimensions were recalculated
      sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(KeyboardAwareScrollView),
          matching: find.byType(SizedBox),
        ),
      );

      // With smaller content (200px) that fits in remaining space (300px),
      // the height should now be null (no constraint needed)
      expect(sizedBox.height, isNull);
      expect(initialHeight, isNotNull); // Confirm it was constrained before

      // Reset the physical size
      tester.view.resetPhysicalSize();
    });
  });
}

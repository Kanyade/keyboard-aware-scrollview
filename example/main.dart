import 'package:flutter/material.dart';
import 'package:keyboard_aware_scrollview/keyboard_aware_scrollview.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Test(),
    ),
  );
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Keyboard Aware Scrollview Example',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: KeyboardAwareScrollView(
        spacing: 48,
        scrollPadding: EdgeInsets.symmetric(horizontal: 24),
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ' *
                15,
          ),
        ],
      ),
    );
  }
}

import 'dart:math' show min, max;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A ScrollView that adjusts its height to avoid being obscured by the keyboard.
/// It calculates its natural height and top offset, and when the keyboard appears,
/// it reduces its height accordingly to ensure that its content remains visible.
///
/// This widget is useful for forms or input fields that need to stay visible
/// when the keyboard is displayed and you cannot use other methods like using
/// `resizeToAvoidBottomInset` from a `Scaffold`.
class KeyboardAwareScrollView extends StatefulWidget {
  const KeyboardAwareScrollView({
    super.key,
    this.scrollPadding = EdgeInsets.zero,
    this.scrollPhysics,
    this.scrollController,
    this.keyboardDismissBehavior,
    this.spacing = 0,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    required this.children,
    this.recalculationKeys = const [],
  });

  /// See also: [SingleChildScrollView.padding]
  final EdgeInsets scrollPadding;

  /// See also: [SingleChildScrollView.physics]
  final ScrollPhysics? scrollPhysics;

  /// See also: [SingleChildScrollView.controller]
  final ScrollController? scrollController;

  /// See also: [SingleChildScrollView.keyboardDismissBehavior]
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  /// See also: [Column.spacing]
  final double spacing;

  /// See also: [Column.crossAxisAlignment]
  final CrossAxisAlignment crossAxisAlignment;

  /// See also: [Column.children]
  final List<Widget> children;

  /// A list of keys that, when changed, will trigger a recalculation of the
  /// natural dimensions of the widget. This is useful when the content or layout
  /// of the widget changes and you need to ensure that the height adjustment
  /// remains accurate.
  ///
  /// For example, you might include keys related to the visibility of certain
  /// widgets, dynamic content changes, or any other factors that could affect
  /// the size and position of the widget.
  final List<Object?> recalculationKeys;

  @override
  State<KeyboardAwareScrollView> createState() => _KeyboardAwareScrollView();
}

class _KeyboardAwareScrollView extends State<KeyboardAwareScrollView> {
  final _wrapperKey = GlobalKey();
  final _contentKey = GlobalKey();
  ({double height, double topOffset})? _naturalDimensions;

  @override
  void initState() {
    super.initState();
    _calculateNaturalDimensions();
  }

  @override
  void didUpdateWidget(covariant KeyboardAwareScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!const DeepCollectionEquality().equals(oldWidget.recalculationKeys, widget.recalculationKeys)) {
      _calculateNaturalDimensions();
    }
  }

  void _calculateNaturalDimensions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final renderBox = _contentKey.currentContext!.findRenderObject()! as RenderBox;
      final topBox = _wrapperKey.currentContext!.findRenderObject()! as RenderBox;
      final size = renderBox.size;
      final columnTopOffset = renderBox.localToGlobal(Offset.zero).dy;
      final parentTopOffset = topBox.localToGlobal(Offset.zero).dy;
      setState(() {
        _naturalDimensions = (height: size.height, topOffset: max(columnTopOffset, parentTopOffset));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final keyboardHeightMinApplied = keyboardHeight > 70.0 ? keyboardHeight : 0.0;

    late final double? columnHeight;

    if (keyboardHeightMinApplied != 0.0 && _naturalDimensions != null) {
      final widgetBottom = _naturalDimensions!.topOffset + _naturalDimensions!.height;
      final keyboardTop = screenHeight - keyboardHeightMinApplied;

      if (widgetBottom > keyboardTop) {
        columnHeight = min(
          _naturalDimensions!.height,
          screenHeight - keyboardHeightMinApplied - (_naturalDimensions!.topOffset),
        );
      } else {
        columnHeight = null;
      }
    } else {
      columnHeight = null;
    }

    return SizedBox(
      key: _wrapperKey,
      height: columnHeight,
      child: SingleChildScrollView(
        padding: widget.scrollPadding,
        physics: widget.scrollPhysics,
        controller: widget.scrollController,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        child: Column(
          key: _contentKey,
          spacing: widget.spacing,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: widget.children,
        ),
      ),
    );
  }
}

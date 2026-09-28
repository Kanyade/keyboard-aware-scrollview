# KeyboardAwareScrollview

[![Version](https://img.shields.io/pub/v/keyboard_aware_scrollview.svg)](https://pub.dev/packages/keyboard_aware_scrollview) ![GitHub license](https://img.shields.io/badge/license-BSD3-blue.svg?style=flat)

### A ScrollView wrapper that automatically adjusts its size when the keyboard appears.

## Usage

`KeyboardAwareScrollView` behaves similarly to a simple `SingleChildScrollView` combined with a `Column`, just add your children and the usual configurations.
By default it does not impose a constrained height but when the keyboard appears it limits its height for the content to be always visible.

This is useful in special cases, for example when you cannot use `resizeToAvoidBottomInset` from a `Scaffold` to handle this for you.
If you are able to use the `Scaffold`'s `resizeToAvoidBottomInset`, you may need to check which one has better performance with your widgets.

```dart
KeyboardAwareScrollView(
  spacing: 48,
  scrollPadding: EdgeInsets.symmetric(horizontal: 24),
  children: [
    TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    ),
    Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ' * 15,
    ),
  ],
),
```

<img src="https://raw.githubusercontent.com/Kanyade/keyboard-aware-scrollview/refs/heads/master/example/keyboard-aware-scrollview.gif" alt="KeyboardAwareScrollView Demo" width="260">

## Parameters

| Parameter                 | Description                                                                                                                                                                                                                                                                              |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `scrollPadding`           | Padding around the content.                                                                                                                                                                                                                                                              |
| `scrollPhysics`           | `ScrollPhysics` of the scrollable content.                                                                                                                                                                                                                                               |
| `scrollController`        | `ScrollController` of the scrollable content.                                                                                                                                                                                                                                            |
| `keyboardDismissBehavior` | `ScrollViewKeyboardDismissBehavior` of the scrollable content.                                                                                                                                                                                                                           |
| `spacing`                 | Spacing between children.                                                                                                                                                                                                                                                                |
| `crossAxisAlignment`      | `CrossAxisAlignment` for the children                                                                                                                                                                                                                                                    |
| `children`                | Widgets to be displayed.                                                                                                                                                                                                                                                                 |
| `recalculationKeys`       | Custom keys attached to the scrollview. If this list changes, the natural dimensions of the content will be recalculated which is necessary for proper functioning. If you have optional widgets, you must use this parameter and the keys need to change based on the optional widgets. |

## License

```
Copyright 2026 Norbert Csörgő

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

## Support

If you found this package useful, consider supporting the creation of many more to come:

- [Buy me a coffee](https://buymeacoffee.com/norbertcsorgo.me)
- [Revolut](https://revolut.me/norber6psx)

Check out more of my work at [norbertcsorgo.me](https://norbertcsorgo.me/), or try [dartmonitor.dev](https://dartmonitor.dev/) to keep your dependencies in check.

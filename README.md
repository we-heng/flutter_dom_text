# DomText

[![pub package](https://img.shields.io/badge/pub-v0.0.1-blue.svg)](https://pub.dev/packages/dom_text)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Flutter Web](https://img.shields.io/badge/Flutter-Web%20(CanvasKit%20%26%20WASM)-02569B?logo=flutter)](https://flutter.dev)

`DomText` is a widget modeled after Flutter's `Text` widget. It uses `HtmlElementView` to render text as real HTML, enabling proper **SEO**, **copy-paste**, **Ctrl+F**, and **Google Translate** support.

---

## Contents

- [Installation](#installation)
- [Widget](#widget)
- [Arguments](#arguments)
- [Example](#example)
  - [In Flutter](#in-flutter)
  - [HTML Representation](#html-representation)
- [Example Explained](#example-explained)
  - [Conversion Model](#conversion-model)
  - [Arguments Not Directly Represented in HTML](#arguments-not-directly-represented-in-html)
- [Implementation Overview](#implementation-overview)
- [Security](#security)
- [License](#license)

---

## Installation

Add the latest published version to `pubspec.yaml`:

```yaml
dependencies:
  dom_text: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## Widget

### `DomText`

| Property | Type | Description |
|---|---|---|
| `data` | `String` | The text content to display. |

---

## Arguments

| Argument | Type | Description |
|---|---|---|
| `key` | `Key` | Identifier key. Used by Flutter to identify the widget and is not directly rendered into the HTML element. |
| `style` | `TextStyle` | Text style, contains additional arguments. `TextStyle` properties are converted into equivalent inline CSS properties and applied directly to the HTML element. |
| `strutStyle` | `StrutStyle` | Minimum vertical dimensions of lines of text, contains additional arguments. Controls the minimum line dimensions used by Flutter's text layout system and has no direct one-to-one HTML equivalent. |
| `textAlign` | `TextAlign` | Text alignment. Converted to the CSS `text-align` property. |
| `textDirection` | `TextDirection` | Direction in which the text flows, such as left-to-right or right-to-left. Converted to the CSS `direction` property. |
| `locale` | `Locale` | Locale used for text rendering and font/glyph selection. Can be represented by the HTML `lang` attribute where applicable. |
| `softWrap` | `bool` | Whether the text should wrap onto additional lines. Converted into equivalent CSS text-wrapping behavior. |
| `overflow` | `TextOverflow` | How text is handled when it exceeds its available space. Converted into equivalent CSS overflow behavior where supported. |
| `textScaleFactor` | `double` | Legacy text scaling factor. Deprecated by Flutter and superseded by `textScaler`. |
| `textScaler` | `TextScaler` | Controls text scaling, including nonlinear accessibility text scaling. The resulting scale is applied to the rendered HTML text. |
| `maxLines` | `int` | Maximum number of lines the text may occupy. Can be represented using CSS line clamping where supported. |
| `semanticsLabel` | `String` | Alternative text exposed to accessibility services such as screen readers. Controlled by Flutter's semantics system and does not change the visible HTML text. |
| `semanticsIdentifier` | `String` | Identifier assigned to the text's semantics node. Controlled by Flutter's semantics system and is not directly rendered into the HTML element. |
| `textWidthBasis` | `TextWidthBasis` | Determines how the width of the text is calculated. Primarily controls Flutter text layout and has no direct one-to-one HTML equivalent. |
| `textHeightBehavior` | `TextHeightBehavior` | Controls how text height is applied to the first and last lines. Primarily controls Flutter text layout and may be approximated using CSS where applicable. |
| `selectionColor` | `Color` | Color used to highlight selected text. Applied using CSS selection styling where supported. |
| `cursorEvent` | `bool` | Controls whether the HTML element receives pointer events. Defaults to `true`. When `true`, the HTML text can receive pointer events and may prevent interaction with Flutter/CanvasKit content underneath. When `false`, pointer events pass through the HTML element to Flutter/CanvasKit content underneath. |
| `htmlElement` | `String` | HTML element used to render the text. Supported elements are `span`, `p`, `h1`, `h2`, `h3`, `h4`, `h5`, and `h6`. Defaults to `span`. |

---

## Example

### In Flutter

```dart
DomText(
  'Hello world. This is my DomText widget.',
  key: const Key('example-text'),
  style: const TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    letterSpacing: 1.2,
    height: 1.5,
    decoration: TextDecoration.underline,
  ),
  strutStyle: const StrutStyle(
    fontSize: 24,
    height: 1.5,
  ),
  textAlign: TextAlign.center,
  textDirection: TextDirection.ltr,
  locale: Locale('en', 'SG'),
  softWrap: true,
  overflow: TextOverflow.ellipsis,
  textScaler: const TextScaler.linear(1.0),
  maxLines: 2,
  semanticsLabel: 'Hello world. This is my DomText widget.',
  semanticsIdentifier: 'example-text',
  textWidthBasis: TextWidthBasis.parent,
  textHeightBehavior: const TextHeightBehavior(
    applyHeightToFirstAscent: true,
    applyHeightToLastDescent: true,
  ),
  selectionColor: Colors.blue,
  cursorEvent: true,
  htmlElement: 'span',
)
```

### HTML Representation

```html
<span
  lang="en-SG"
  style="
    color: black;
    font-size: 24px;
    font-weight: 700;
    font-style: italic;
    letter-spacing: 1.2px;
    line-height: 1.5;
    text-decoration: underline;
    text-align: center;
    direction: ltr;
    white-space: normal;
    overflow: hidden;
    text-overflow: ellipsis;
    pointer-events: auto;
  ">
  Hello world. This is my DomText widget.
</span>
```

---

## Example Explained

### Conversion Model

The conversion follows this general model:

```
data                → HTML text content
style               → inline CSS
textAlign           → text-align
textDirection       → direction
locale              → lang
softWrap            → CSS wrapping
overflow            → CSS overflow
maxLines            → CSS line clamping
textScaler          → CSS text scaling
selectionColor      → CSS selection styling
cursorEvent         → pointer-events
htmlElement         → HTML element type
```

### Arguments Not Directly Represented in HTML

Some arguments belong to Flutter's widget, layout, or semantics systems rather than the DOM itself:

```
key                 → Flutter widget identity
strutStyle          → Flutter text layout
semanticsLabel      → Flutter semantics
semanticsIdentifier → Flutter semantics
textWidthBasis      → Flutter text layout
textHeightBehavior  → Flutter text layout
```

---

## Implementation Overview

The package intentionally keeps its implementation small and Web-focused. The main source files are:

### `src/dom_text.dart`

Defines the public `DomText` widget and coordinates Flutter layout with the browser-rendered element.

Its responsibilities are:

- Merge the widget style with the surrounding `DefaultTextStyle`.
- Convert the supported text arguments into CSS through `style_converter.dart`.
- Create the invisible Flutter `Text` layout placeholder.
- Place the HTML element over the placeholder using a `Stack`.
- Keep the Flutter layout size synchronized with the HTML element's measured width and height.
- Preserve Flutter semantics such as `semanticsLabel` and `semanticsIdentifier`.

The invisible Flutter `Text` is a layout proxy. Flutter needs a widget size to position surrounding widgets, while the visible text is owned by the browser. The HTML implementation reports its measured `scrollWidth` and `scrollHeight` back to this widget so translated text, browser resizing, and font changes can update the Flutter layout.

### `src/style_converter.dart`

Contains the pure Flutter-to-CSS conversion logic. It converts text alignment, direction, wrapping, font properties, colors, decorations, overflow, line clamping, and pointer-event behavior into inline CSS.

When adding a supported styling property, update this file and keep the conversion independent from widget or browser code.

### `src/html_implement.dart`

Creates the real browser element with `HtmlElementView.fromTagName`.

Its responsibilities are:

- Set plain text with `innerText`.
- Apply the generated inline CSS.
- Configure pointer events.
- Watch browser size changes with `ResizeObserver`.
- Watch DOM text changes, including Google Translate updates, with `MutationObserver`.
- Report the element's current width and height back to `DomText`.

This file uses the `web` package and is intentionally Web-only. Keep browser APIs here rather than placing them in the widget or CSS conversion code.

---

## Security

`dom_text` assigns text values strictly via the browser's DOM `innerText` property. It never sets `innerHTML`, preventing any Cross-Site Scripting (XSS) or HTML injection vulnerabilities.

This does not validate application-provided URLs. Validate and restrict `linkUrl` values according to your application's security requirements.

To report a vulnerability, follow the process in [SECURITY.md](SECURITY.md).

---

## License

MIT License. See [LICENSE](LICENSE) for details.
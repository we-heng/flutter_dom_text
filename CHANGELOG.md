## 0.0.3
* Added section to `example/main.dart` to contrast text rendered using standard Text widget and DomText widget.
* Updated `README.md` to reflect the correct release version.
* Updated DomText to more closely match Flutter’s standard Text widget, including improved font handling, text scaling, CSS styling, locale support, and corrected layout sizing to prevent excessive spacing.
* Added dartdoc comments to the complete public DomText API.

## 0.0.2
* Fixed HTML text disappearing in deployed and release-mode web builds by using typed DOM operations.
* Added `example/serve_web.py` for serving compiled web output locally.

## 0.0.1
* Initial release
* `data` - The text content to display.
* `key` - Identifier key. Used by Flutter to identify the widget and is not directly rendered into the HTML element.
* `style` - Text style, contains additional arguments. `TextStyle` properties are converted into equivalent inline CSS properties and applied directly to the HTML element.
* `strutStyle` - Minimum vertical dimensions of lines of text, contains additional arguments. Controls the minimum line dimensions used by Flutter's text layout system and has no direct one-to-one HTML equivalent.
* `textAlign` - Text alignment. Converted to the CSS `text-align` property.
* `textDirection` - Direction in which the text flows, such as left-to-right or right-to-left. Converted to the CSS `direction` property.
* `locale` - Locale used for text rendering and font/glyph selection. Can be represented by the HTML `lang` attribute where applicable.
* `softWrap` - Whether the text should wrap onto additional lines. Converted into equivalent CSS text-wrapping behavior.
* `overflow` - How text is handled when it exceeds its available space. Converted into equivalent CSS overflow behavior where supported.
* `textScaleFactor` - Legacy text scaling factor. Deprecated by Flutter and superseded by `textScaler`.
* `textScaler` - Controls text scaling, including nonlinear accessibility text scaling. The resulting scale is applied to the rendered HTML text.
* `maxLines` - Maximum number of lines the text may occupy. Can be represented using CSS line clamping where supported.
* `semanticsLabel` - Alternative text exposed to accessibility services such as screen readers. Controlled by Flutter's semantics system and does not change the visible HTML text.
* `semanticsIdentifier` - Identifier assigned to the text's semantics node. Controlled by Flutter's semantics system and is not directly rendered into the HTML element.
* `textWidthBasis` - Determines how the width of the text is calculated. Primarily controls Flutter text layout and has no direct one-to-one HTML equivalent.
* `textHeightBehavior` - Controls how text height is applied to the first and last lines. Primarily controls Flutter text layout and may be approximated using CSS where applicable.
* `selectionColor` - Color used to highlight selected text. Applied using CSS selection styling where supported.
* `cursorEvent` - Controls whether the HTML element receives pointer events. Defaults to `true`. When `true`, the HTML text can receive pointer events and may prevent interaction with Flutter/CanvasKit content underneath. When `false`, pointer events pass through the HTML element to Flutter/CanvasKit content underneath.
* `htmlElement` - HTML element used to render the text. Supported elements are `span`, `p`, `h1`, `h2`, `h3`, `h4`, `h5`, and `h6`. Defaults to `span`.
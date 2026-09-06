import 'package:flutter/widgets.dart';

String domTextCss({
  required TextStyle style,
  required TextAlign textAlign,
  required TextDirection textDirection,
  required bool softWrap,
  required TextOverflow overflow,
  required int? maxLines,
  required bool cursorEvent,
  required String tag,
}) {
  final rules = <String>[
    'box-sizing: border-box',
    'display: ${tag == 'span' ? 'inline-block' : 'block'}',
    'margin: 0',
    'padding: 0',
    'pointer-events: ${cursorEvent ? 'auto' : 'none'}',
    'user-select: text',
    '-webkit-user-select: text',
    'direction: ${textDirection == TextDirection.rtl ? 'rtl' : 'ltr'}',
    'text-align: ${_cssTextAlign(textAlign)}',
    'white-space: ${softWrap ? 'normal' : 'nowrap'}',
    "font-family: '${style.fontFamily ?? 'Roboto'}', sans-serif",
    'font-size: ${style.fontSize ?? 14}px',
    'font-weight: ${style.fontWeight?.value ?? 400}',
    'font-style: ${style.fontStyle == FontStyle.italic ? 'italic' : 'normal'}',
    'line-height: ${style.height ?? 1.2}',
  ];
  final color = style.color;
  if (color != null) {
    rules.add('color: ${_cssColor(color)}');
  }
  if (style.letterSpacing != null) {
    rules.add('letter-spacing: ${style.letterSpacing}px');
  }
  final decoration = style.decoration;
  if (decoration != null) {
    rules.add('text-decoration: ${_cssDecoration(decoration)}');
  }
  if (!softWrap || maxLines == 1) {
    rules.add('overflow: hidden');
    if (overflow == TextOverflow.ellipsis) {
      rules.add('text-overflow: ellipsis');
    }
  }
  if (maxLines != null && maxLines > 1) {
    rules.add('display: -webkit-box');
    rules.add('-webkit-box-orient: vertical');
    rules.add('-webkit-line-clamp: $maxLines');
  }
  return '${rules.join('; ')};';
}

String _cssTextAlign(TextAlign align) => switch (align) {
  TextAlign.center => 'center',
  TextAlign.right || TextAlign.end => 'right',
  TextAlign.justify => 'justify',
  _ => 'left',
};

String _cssColor(Color color) {
  final red = (color.r * 255).round();
  final green = (color.g * 255).round();
  final blue = (color.b * 255).round();
  return 'rgba($red, $green, $blue, ${color.a.toStringAsFixed(3)})';
}

String _cssDecoration(TextDecoration decoration) {
  final values = <String>[];
  if (decoration.contains(TextDecoration.underline)) {
    values.add('underline');
  }
  if (decoration.contains(TextDecoration.lineThrough)) {
    values.add('line-through');
  }
  if (decoration.contains(TextDecoration.overline)) {
    values.add('overline');
  }
  return values.isEmpty ? 'none' : values.join(' ');
}

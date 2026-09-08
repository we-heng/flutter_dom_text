import 'package:flutter/widgets.dart';

String domTextCss({
  required TextStyle style,
  required TextAlign textAlign,
  required TextDirection textDirection,
  required bool softWrap,
  required TextOverflow overflow,
  required TextScaler textScaler,
  required int? maxLines,
  required bool cursorEvent,
  required String tag,
}) {
  final rules = <String>[
    'box-sizing: border-box',
    'display: ${tag == 'span' ? 'inline-block' : 'block'}',
    'margin: 0',
    'padding: 0',
    'border: 0',
    'vertical-align: baseline',
    'pointer-events: ${cursorEvent ? 'auto' : 'none'}',
    'user-select: text',
    '-webkit-user-select: text',
    'direction: ${textDirection == TextDirection.rtl ? 'rtl' : 'ltr'}',
    'text-align: ${_cssTextAlign(textAlign)}',
    'white-space: ${softWrap ? 'normal' : 'nowrap'}',
    'font-family: ${_cssFontFamilies(style)}',
    'font-size: ${textScaler.scale(style.fontSize ?? 14)}px',
    'font-weight: ${style.fontWeight?.value ?? 400}',
    'font-style: ${style.fontStyle == FontStyle.italic ? 'italic' : 'normal'}',
  ];
  if (style.height != null) {
    rules.add('line-height: ${style.height}');
  }
  final color = style.color;
  if (color != null) {
    rules.add('color: ${_cssColor(color)}');
  }
  if (style.letterSpacing != null) {
    rules.add('letter-spacing: ${style.letterSpacing}px');
  }
  if (style.wordSpacing != null) {
    rules.add('word-spacing: ${style.wordSpacing}px');
  }
  final decoration = style.decoration;
  if (decoration != null) {
    rules.add('text-decoration: ${_cssDecoration(decoration)}');
    if (style.decorationColor != null) {
      rules.add('text-decoration-color: ${_cssColor(style.decorationColor!)}');
    }
    if (style.decorationStyle != null) {
      rules.add(
        'text-decoration-style: ${_cssDecorationStyle(style.decorationStyle!)}',
      );
    }
    if (style.decorationThickness != null) {
      rules.add('text-decoration-thickness: ${style.decorationThickness}');
    }
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

String _cssFontFamilies(TextStyle style) {
  final families = <String>[
    if (style.fontFamily != null) style.fontFamily!,
    ...?style.fontFamilyFallback,
    'Roboto',
    'Noto Sans',
    'sans-serif',
  ];
  return families.map(_cssFontFamily).join(', ');
}

String _cssFontFamily(String family) {
  if (family == 'sans-serif' || family == 'serif' || family == 'monospace') {
    return family;
  }
  return '"${family.replaceAll('"', '\\"')}"';
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

String _cssDecorationStyle(TextDecorationStyle style) => switch (style) {
  TextDecorationStyle.solid => 'solid',
  TextDecorationStyle.double => 'double',
  TextDecorationStyle.dotted => 'dotted',
  TextDecorationStyle.dashed => 'dashed',
  TextDecorationStyle.wavy => 'wavy',
};

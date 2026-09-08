import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'html_implement.dart';
import 'style_converter.dart';

/// A [Text]-like widget that renders native HTML text on Flutter Web.
class DomText extends StatefulWidget {
  /// The plain text content rendered by the HTML element.
  final String data;

  /// The Flutter text style converted to CSS for the HTML element.
  final TextStyle? style;

  /// The minimum line dimensions used by the Flutter layout proxy.
  final StrutStyle? strutStyle;

  /// How the text is aligned within its available width.
  final TextAlign? textAlign;

  /// The direction in which the text flows.
  final TextDirection? textDirection;

  /// The locale used for Flutter text layout and the HTML `lang` attribute.
  final Locale? locale;

  /// Whether the text may wrap onto multiple lines.
  final bool? softWrap;

  /// How text that exceeds its available space is handled.
  final TextOverflow? overflow;

  /// The legacy multiplier used to scale the text.
  @Deprecated('Use textScaler instead')
  final double? textScaleFactor;

  /// The text scaler applied by both Flutter layout and the HTML text.
  final TextScaler? textScaler;

  /// The maximum number of lines rendered by the text.
  final int? maxLines;

  /// An alternative label exposed to accessibility services.
  final String? semanticsLabel;

  /// The identifier assigned to this text's semantics node.
  final String? semanticsIdentifier;

  /// The basis used by Flutter to calculate the text width.
  final TextWidthBasis? textWidthBasis;

  /// Controls how Flutter applies height to the first and last lines.
  final TextHeightBehavior? textHeightBehavior;

  /// The browser selection color for the rendered text.
  final Color? selectionColor;

  /// Whether the HTML element receives pointer events.
  final bool cursorEvent;

  /// The supported HTML element used to render the text.
  final String htmlElement;

  /// Creates text rendered as a native HTML element on Flutter Web.
  const DomText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    @Deprecated('Use textScaler instead') this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.cursorEvent = true,
    this.htmlElement = 'span',
  }) : assert(
         htmlElement == 'span' ||
             htmlElement == 'p' ||
             htmlElement == 'h1' ||
             htmlElement == 'h2' ||
             htmlElement == 'h3' ||
             htmlElement == 'h4' ||
             htmlElement == 'h5' ||
             htmlElement == 'h6',
         'htmlElement must be a supported text element',
       );

  @override
  State<DomText> createState() => _DomTextState();
}

class _DomTextState extends State<DomText> {
  double _htmlWidth = 0;
  double _htmlHeight = 0;

  void _onHtmlSizeChanged(Size size) {
    if (!mounted ||
        ((size.width - _htmlWidth).abs() < 0.5 &&
            (size.height - _htmlHeight).abs() < 0.5)) {
      return;
    }
    setState(() {
      _htmlWidth = size.width;
      _htmlHeight = size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context);
    final effectiveStyle = defaultStyle.style.merge(widget.style);
    final effectiveAlign =
        widget.textAlign ?? defaultStyle.textAlign ?? TextAlign.start;
    final effectiveDirection =
        widget.textDirection ?? Directionality.of(context);
    final effectiveSoftWrap = widget.softWrap ?? defaultStyle.softWrap;
    final effectiveOverflow = widget.overflow ?? defaultStyle.overflow;
    final effectiveScaler =
        widget.textScaler ??
        (widget.textScaleFactor == null
            ? TextScaler.noScaling
            : TextScaler.linear(widget.textScaleFactor!));

    final css = domTextCss(
      style: effectiveStyle,
      textAlign: effectiveAlign,
      textDirection: effectiveDirection,
      softWrap: effectiveSoftWrap,
      overflow: effectiveOverflow,
      textScaler: effectiveScaler,
      maxLines: widget.maxLines,
      cursorEvent: widget.cursorEvent,
      tag: widget.htmlElement,
    );
    final ghost = Opacity(
      opacity: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: math.max(_htmlWidth, 0),
          minHeight: math.max(_htmlHeight, 0),
        ),
        child: Text(
          widget.data,
          style: effectiveStyle.copyWith(
            fontFamily: effectiveStyle.fontFamily ?? 'Roboto',
          ),
          strutStyle: widget.strutStyle,
          textAlign: effectiveAlign,
          textDirection: effectiveDirection,
          locale: widget.locale,
          softWrap: effectiveSoftWrap,
          overflow: effectiveOverflow,
          textScaler: effectiveScaler,
          maxLines: widget.maxLines,
        ),
      ),
    );

    return Semantics(
      label: widget.semanticsLabel,
      identifier: widget.semanticsIdentifier,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          ghost,
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !widget.cursorEvent,
              child: buildHtmlElement(
                key: ValueKey('${widget.data}-${widget.htmlElement}-$css'),
                text: widget.data,
                tag: widget.htmlElement,
                css: css,
                locale: widget.locale,
                pointerEvents: widget.cursorEvent,
                onSizeChanged: _onHtmlSizeChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

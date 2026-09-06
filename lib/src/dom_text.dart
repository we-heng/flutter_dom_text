import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'html_implement.dart';
import 'style_converter.dart';

/// A [Text]-like widget that renders native HTML text on Flutter Web.
class DomText extends StatefulWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  @Deprecated('Use textScaler instead')
  final double? textScaleFactor;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final String? semanticsIdentifier;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool cursorEvent;
  final String htmlElement;

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
      maxLines: widget.maxLines,
      cursorEvent: widget.cursorEvent,
      tag: widget.htmlElement,
    );
    final ghost = Opacity(
      opacity: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: math.max(_htmlWidth, 0),
          minHeight: math.max(
            _htmlHeight,
            widget.maxLines == null
                ? 0
                : (effectiveStyle.fontSize ?? 14) *
                      (effectiveStyle.height ?? 1.2) *
                      widget.maxLines!,
          ),
        ),
        child: Text(
          widget.data,
          style: effectiveStyle.copyWith(
            fontFamily: effectiveStyle.fontFamily ?? 'Roboto',
            fontSize: (effectiveStyle.fontSize ?? 14) * 1.04,
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

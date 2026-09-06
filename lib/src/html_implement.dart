import 'dart:js_interop';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

Widget buildHtmlElement({
  Key? key,
  required String text,
  required String tag,
  required String css,
  required bool pointerEvents,
  required ValueChanged<Size> onSizeChanged,
}) {
  return HtmlElementView.fromTagName(
    key: key,
    tagName: tag,
    onElementCreated: (Object created) {
      final htmlElement = created as web.HTMLElement;
      htmlElement.innerText = text;
      htmlElement.style.cssText = css;
      htmlElement.style.pointerEvents = pointerEvents ? 'auto' : 'none';

      void reportSize() {
        onSizeChanged(
          Size(
            htmlElement.scrollWidth.toDouble(),
            htmlElement.scrollHeight.toDouble(),
          ),
        );
      }

      final resizeObserver = web.ResizeObserver(
        ((
              JSArray<web.ResizeObserverEntry> entries,
              web.ResizeObserver observer,
            ) {
              reportSize();
            })
            .toJS,
      );
      resizeObserver.observe(htmlElement);

      final mutationObserver = web.MutationObserver(
        ((JSArray<web.MutationRecord> records, web.MutationObserver observer) {
          reportSize();
        }).toJS,
      );
      mutationObserver.observe(
        htmlElement,
        web.MutationObserverInit(
          childList: true,
          characterData: true,
          subtree: true,
        ),
      );

      reportSize();
    },
  );
}

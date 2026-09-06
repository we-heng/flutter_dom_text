# Security Policy

## Supported Versions

Only the latest version published on pub.dev receives security updates.

## Safe HTML Handling (XSS Prevention)

`dom_text` is specifically designed with security in mind:
- **No `innerHTML` injection**: All text data passed to `HtmlText` is assigned using the DOM `innerText` property.
- Text content is never parsed as raw HTML markup, effectively eliminating Cross-Site Scripting (XSS) vectors from user-provided text.
- If you render links via `HtmlText.link`, only standard URL href attributes are bound.

## Reporting a Vulnerability

Report privately via GitHub's private vulnerability reporting. 

Maintainers and contributors may review reports, reproduce the issue, assess its impact, and propose or implement a fix. There is no guaranteed response, triage, or remediation timeline.

When appropriate, reporters may be invited to help validate a fix. Please wait for coordination before publicly disclosing the vulnerability or publishing technical details that could enable exploitation.
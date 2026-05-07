part of '../common_components.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    super.key,
    required this.titleText,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.textScaler,
  });

  final String titleText;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextScaler? textScaler;

  /// A11y feature: lets you override text for screen readers
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final userScale = MediaQuery.of(context).textScaler;

    return Semantics(
      // if label given → override; else → use text
      label: semanticsLabel ?? titleText,
      child: Text(
        titleText,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        textScaler:
            textScaler ??
            userScale.clamp(minScaleFactor: 1.0, maxScaleFactor: 2.5),
        // ✅ Prevents layout breaking
        style: textStyle,
      ),
    );
  }
}

class HighlightText extends StatelessWidget {
  const HighlightText({
    super.key,
    required this.source,
    required this.highlightColor,
    this.query,
    required this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.textScaler,
    this.semanticsLabel,
  });

  final String source;
  final Color highlightColor;
  final String? query;
  final TextStyle style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    if (query.isNullOrEmpty ||
        !source.toLowerCase().contains(query!.toLowerCase())) {
      return CommonText(
        titleText: source,
        textStyle: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        textScaler: textScaler,
        semanticsLabel: semanticsLabel,
      );
    }

    final regex = RegExp(RegExp.escape(query!), caseSensitive: false);
    final matches = regex.allMatches(source);

    if (matches.isEmpty) {
      return CommonText(
        titleText: source,
        textStyle: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        textScaler: textScaler,
        semanticsLabel: semanticsLabel,
      );
    }

    final spans = <TextSpan>[];
    int last = 0;

    for (final m in matches) {
      if (m.start > last) {
        spans.add(
          TextSpan(
            text: source.substring(
              last,
              m.start,
            ),
            style: style, // <-- ensure original style is applied

          ),
        );
      }

      spans.add(
        TextSpan(
          text: source.substring(m.start, m.end),
          style: style.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
            color: style.color, // make sure it keeps your original text color
          ),
        ),
      );

      last = m.end;
    }

    if (last < source.length) {
      spans.add(TextSpan(text: source.substring(last), style: style));
    }

    final userScale = MediaQuery.of(context).textScaler;

    return Semantics(
      label: semanticsLabel ?? source,
      child: RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.clip,
        textScaler:
            textScaler ??
            userScale.clamp(minScaleFactor: 1.0, maxScaleFactor: 2.5),
        text: TextSpan(children: spans, style: style),
      ),
    );
  }
}

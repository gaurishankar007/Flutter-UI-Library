import 'package:material_ui/material_ui.dart';

class BaseText extends StatelessWidget {

  const BaseText(
    this.text, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.color,
    this.fontFamily,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.decoration,
    this.decorationColor,
  });

  factory BaseText.overline(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    Color? color,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    color: color,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  factory BaseText.label(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  factory BaseText.link(
    String text, {
    double fontSize = 17,
    TextAlign? textAlign,
    TextOverflow? overflow,
    Color? color,
    Color? decorationColor,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    decorationColor: decorationColor,
  );

  factory BaseText.button(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  factory BaseText.body(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    fontSize: 17,
  );

  factory BaseText.heading5(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    fontSize: 17,
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w600,
    decoration: textDecoration,
    decorationColor: decorationColor,
  );

  factory BaseText.heading4(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    fontSize: 20,
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w600,
    decoration: textDecoration,
    decorationColor: decorationColor,
  );

  factory BaseText.heading3(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    fontSize: 24,
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w600,
    decoration: textDecoration,
    decorationColor: decorationColor,
  );

  factory BaseText.heading2(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    fontSize: 32,
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w600,
    decoration: textDecoration,
    decorationColor: decorationColor,
  );

  factory BaseText.heading1(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    fontSize: 40,
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w600,
    decoration: textDecoration,
    decorationColor: decorationColor,
  );
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  final Color? decorationColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
      ),
    );
  }
}

import 'package:emtech_project/extensions/text_styles.dart';
import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  const HeadingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.titleText
          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }
}

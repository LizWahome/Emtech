import 'package:emtech_project/extensions/colors.dart';
import 'package:emtech_project/extensions/text_styles.dart';
import 'package:flutter/material.dart';

class TotalCoursesRow extends StatelessWidget {
  final String total;
  const TotalCoursesRow({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        total,
        style: context.displaySmall
            ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
      Container(
        margin: EdgeInsets.only(left: 7),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: AppColors.pink, borderRadius: BorderRadius.circular(20)),
        child: Text(
          "October",
          style: context.dividerTextSmall?.copyWith(color: Colors.white),
        ),
      )
    ]);
  }
}

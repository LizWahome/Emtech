import 'package:emtech_project/extensions/colors.dart';
import 'package:emtech_project/extensions/text_styles.dart';
import 'package:emtech_project/features/instructor/data/create_course.dart';
import 'package:emtech_project/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class CourseDetails extends StatefulWidget {
  final CreateCourse course;
  const CourseDetails({super.key, required this.course});

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("${widget.course.name}", style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.mainPurple),),
          SizedBox(height: 12,),
          HeadingText(text: widget.course.description ?? "")],
      ),
    );
  }
}

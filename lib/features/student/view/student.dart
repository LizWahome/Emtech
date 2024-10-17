import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emtech_project/extensions/colors.dart';
import 'package:emtech_project/extensions/text_styles.dart';
import 'package:emtech_project/features/instructor/data/create_course.dart';
import 'package:emtech_project/utils/assets.dart';
import 'package:emtech_project/widgets/common_row.dart';
import 'package:emtech_project/widgets/custom_button.dart';
import 'package:emtech_project/widgets/heading_text.dart';
import 'package:emtech_project/widgets/total_courses_row.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<CreateCourse> courses = [];
  List<CreateCourse> enrolledCourses = [];
   enrollCourse(CreateCourse course) {
    if (!enrolledCourses.contains(course)) {
      setState(() {
        enrolledCourses.add(course);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are already enrolled in this course.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonRow(
                  color: Colors.blue,
                  image: AssetsUrls.student,
                  profile: AssetsUrls.user),
              HeadingText(text: "Total Courses"),
              SizedBox(
                height: 10,
              ),
              TotalCoursesRow(total: "342"),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                    color: AppColors.pink.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text(
                      "Here are videos you can watch",
                      style: context.titleText,
                    ),
                    ElevatedButton(onPressed: () {}, child: Text("Interact"))
                  ],
                ),
              ),
              HeadingText(text: "Latest Courses"),
              SizedBox(
                  height: 300,
                  child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final course = enrolledCourses[index];
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.pink.withOpacity(0.4)),
                          child: Column(
                            children: [
                              HeadingText(text: "${course.name}"),
                              course.logo!.isNotEmpty
                                  ? Image.network(course.logo!.first)
                                  : Image.asset(AssetsUrls.user),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Progress"),
                                  Text("67%"),
                                ],
                              ),
                              LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(12),
                                value: 67.0,
                                backgroundColor:
                                    AppColors.midBlue.withOpacity(0.2),
                                valueColor:
                                    AlwaysStoppedAnimation(AppColors.midBlue),
                                minHeight: 20,
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: enrolledCourses.length)),
              HeadingText(text: "New Courses"),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("courses")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    snapshot.data!.docs.forEach((element) {
                      CreateCourse course = CreateCourse.fromDocument(element);
                      courses.add(course);
                    });
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return ListTile(
                            title: Text(course.name ?? ""),
                            trailing: CustomKtButton(
                              width: 100,
                              height: 40,
                              btnText: "Enroll",
                              onPress: () {
                                enrollCourse(course);
                              },
                            ),
                          );
                        },
                        itemCount: courses.length);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

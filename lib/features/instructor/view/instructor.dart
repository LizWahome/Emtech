import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emtech_project/extensions/colors.dart';
import 'package:emtech_project/extensions/text_styles.dart';
import 'package:emtech_project/features/instructor/data/create_course.dart';
import 'package:emtech_project/features/instructor/view/course_details.dart';
import 'package:emtech_project/features/instructor/view/create_course.dart';
import 'package:emtech_project/utils/assets.dart';
import 'package:emtech_project/widgets/common_row.dart';
import 'package:emtech_project/widgets/heading_text.dart';
import 'package:emtech_project/widgets/total_courses_row.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class InstructorPage extends StatefulWidget {
  const InstructorPage({super.key});

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}

class _InstructorPageState extends State<InstructorPage> {
  late List<QuickActions> functions;
  List<CreateCourse> courses = [];
  VideoPlayerController? _videoPlayerController;
  File? _videoFile;
  Uint8List? _videoBytes;
  String? _videoUrl;

  showCreateSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return CreateCoursePage();
        });
  }

  @override
  void initState() {
    super.initState();
    functions = [
      QuickActions(
          name: "create", onPressed: showCreateSheet, color: Colors.green),
      QuickActions(
          name: "videos", onPressed: _pickVideo, color: Colors.purpleAccent),
      QuickActions(
          name: "documents",
          onPressed: uploadDocument,
          color: Colors.blueAccent)
    ];
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        _videoFile = File(result.files.single.path!);
      });

      _videoPlayerController = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController!.play();
        });
    }
  }

  Future<void> uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      try {
        FirebaseStorage storage = FirebaseStorage.instance;

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = storage.ref().child('documents/$fileName');

        UploadTask uploadTask = storageRef.putFile(file);

        TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});

        String downloadUrl = await snapshot.ref.getDownloadURL();
        print('File uploaded successfully. Download URL: $downloadUrl');
      } catch (e) {
        print('Error occurred while uploading the file: $e');
      }
    } else {
      print('No file selected');
    }
  }

  Future<String> uploadFileToFirebase(
      Uint8List fileBytes, String fileType) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('$fileType/${DateTime.now().millisecondsSinceEpoch}_$fileType');

    final uploadTask = storageRef.putData(fileBytes);

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonRow(
                color: AppColors.pink,
                image: AssetsUrls.instructor,
                profile: AssetsUrls.user),
            HeadingText(text: "Total Courses"),
            SizedBox(
              height: 12,
            ),
            //TotalCoursesRow(total: "400"),
            SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 25,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: functions.length,
                itemBuilder: (context, index) {
                  final action = functions[index];
                  return InkWell(
                    onTap: action.onPressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: action.color,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        action.name,
                        style: context.dividerTextSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  width: 12,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            if (_videoPlayerController != null &&
                _videoPlayerController!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: Stack(children: [
                  VideoPlayer(_videoPlayerController!),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_videoPlayerController!.value.isPlaying) {
                                _videoPlayerController!.pause();
                              } else {
                                _videoPlayerController!.play();
                              }
                            });
                          },
                          icon: _videoPlayerController!.value.isPlaying
                              ? Icon(Icons.play_circle)
                              : Icon(Icons.pause_circle)))
                ]),
              ),
            HeadingText(text: "My Courses"),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("courses").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                courses.clear();
                snapshot.data!.docs.forEach((element) {
                  CreateCourse course = CreateCourse.fromDocument(element);
                  courses.add(course);
                });
                return ListView.separated(
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CourseDetails(course: course)));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.pink.withOpacity(0.4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderRadius: BorderRadius.circular(20),
                                value: 67.0,
                                backgroundColor:
                                    AppColors.midBlue.withOpacity(0.2),
                                valueColor:
                                    AlwaysStoppedAnimation(AppColors.midBlue),
                                minHeight: 20,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 8,
                      );
                    },
                    itemCount: courses.length);
              },
            ))
          ],
        ),
      ),
    ));
  }
}

class QuickActions {
  final String name;
  final void Function()? onPressed;
  final Color color;
  QuickActions(
      {required this.name, required this.onPressed, required this.color});
}

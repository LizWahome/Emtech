import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emtech_project/features/instructor/data/create_course.dart';
import 'package:emtech_project/helpers/custom_file_picker.dart';
import 'package:emtech_project/helpers/show_toast.dart';
import 'package:emtech_project/widgets/custom_button.dart';
import 'package:emtech_project/widgets/custom_textfield.dart';
import 'package:emtech_project/widgets/heading_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({super.key});

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController descCtr = TextEditingController();
  bool loading = false;
  List<dynamic> imagePaths = [];
  List<PlatformFile>? pickedImages;

  @override
  void dispose() {
    nameCtr.dispose();
    super.dispose();
  }

  Future selectImage() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image, withData: true);
    if (result == null) return;
    setState(() {
      pickedImages = result.files;
    });
  }

  Future uploadImages(List<PlatformFile> files) async {
    List<String> downloadUrls = [];
    for (var file in files) {
      if (file.bytes != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
            'course_images/${DateTime.now().millisecondsSinceEpoch}_${file.bytes}');

        final uploadTask = storageRef.putData(file.bytes!);

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    }

    return downloadUrls;
  }

  Future<void> createCourse() async {
    setState(() {
      loading = true;
    });
    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      List<String> imageUrls = [];
      if (pickedImages != null && pickedImages!.isNotEmpty) {
        imageUrls = await uploadImages(pickedImages!); // Upload selected images
      }
      CreateCourse course = CreateCourse(
          courseID: timestamp.toString(),
          name: nameCtr.text.trim(),
          description: descCtr.text.trim(),
          logo: imageUrls);
      await FirebaseFirestore.instance
          .collection("courses")
          .doc(course.courseID)
          .set(course.toMap());

      ToastUtils.showSuccessToast(
          context, "Course Seccessfully created", "Success");
      Navigator.pop(context);
      nameCtr.clear();
      descCtr.clear();
    } catch (e) {
      ToastUtils.showSuccessToast(
          context, "An error occured, ${e.toString()}", "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          const HeadingText(text: "What is the name of your course"),
          const SizedBox(
            height: 8,
          ),
          CustomTextField(labelText: "Course Name", controller: nameCtr),
          const HeadingText(text: "Give your course some description"),
          const SizedBox(
            height: 8,
          ),
          CustomTextField(
            controller: descCtr,
            labelText: "Description",
          ),
          HeadingText(text: "Add an image to represent your course"),
          SizedBox(
            height: 9,
          ),
          // ElevatedButton(onPressed: selectImage, child: Text("Images")),
          CustomKtButton(
              isLoading: loading, onPress: createCourse, btnText: "Create")
        ],
      ),
    );
  }
}

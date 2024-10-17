import 'package:emtech_project/features/approver/view/approver.dart';
import 'package:emtech_project/features/instructor/view/instructor.dart';
import 'package:emtech_project/features/onboarding/login/login.dart';
import 'package:emtech_project/features/onboarding/register/register.dart';
import 'package:emtech_project/features/student/view/student.dart';
import 'package:emtech_project/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

   Future<void> _checkLoginStatus() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (user != null) {
        // If user is logged in, fetch their role from Firestore
        String? role = await _authService.getUserRole(user.uid);
        if (role == 'student') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentPage()),
          );
        } else if (role == 'instructor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InstructorPage()),
          );
        } else if (role == 'approver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ApproverPage()),
          );
        }
      } else {
        // If no user is logged in, navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Register()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

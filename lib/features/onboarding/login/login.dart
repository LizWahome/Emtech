import 'package:emtech_project/extensions/colors.dart';
import 'package:emtech_project/extensions/text_styles.dart';
import 'package:emtech_project/features/approver/view/approver.dart';
import 'package:emtech_project/features/instructor/view/instructor.dart';
import 'package:emtech_project/features/onboarding/register/register.dart';
import 'package:emtech_project/features/student/view/student.dart';
import 'package:emtech_project/helpers/show_toast.dart';
import 'package:emtech_project/services/auth.dart';
import 'package:emtech_project/widgets/custom_button.dart';
import 'package:emtech_project/widgets/custom_textfield.dart';
import 'package:emtech_project/widgets/heading_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  
    Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();

    User? user = await _authService.loginWithEmailAndPassword(email, password);
    if (user != null) {
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
      } else {
        // Handle unknown roles or errors
        print('Role not found');
      }
    } else {
      // Handle login error
      print('Login failed');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeadingText(text: "Hello,\nWelcome back"),
              Text("Kindly login to get access"),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: emailController,
                labelText: "Enter your email",
              ),
              CustomTextField(
                controller: passController,
                labelText: "Enter your password",
              ),
             
              SizedBox(
                height: 20,
              ),
              CustomKtButton(btnText: "Login", onPress: _login,),
              SizedBox(height: 50,),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Don't have an account? ",style: context.dividerTextLarge?.copyWith(color: Colors.black)),
                        TextSpan(text: "Register", style: context.dividerTextLarge?.copyWith(color: AppColors.primary))
                      ]
                    )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

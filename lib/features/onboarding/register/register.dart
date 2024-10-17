import 'package:emtech_project/extensions/colors.dart';
import 'package:emtech_project/extensions/text_styles.dart';
import 'package:emtech_project/features/onboarding/login/login.dart';
import 'package:emtech_project/helpers/show_toast.dart';
import 'package:emtech_project/services/auth.dart';
import 'package:emtech_project/widgets/custom_button.dart';
import 'package:emtech_project/widgets/custom_textfield.dart';
import 'package:emtech_project/widgets/heading_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _dropdownValue;
  bool _showDropdown = false;
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void toggleDropdownVisibility() {
    setState(() {
      _showDropdown = !_showDropdown;
    });
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  Future<void> _register() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();

    User? user = await _authService.registerWithEmailAndPassword(
        email, password, _dropdownValue!);
    if (user != null) {
      ToastUtils.showSuccessToast(
          context, "Successfully registered as $_dropdownValue", "Success");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
    } else {
      ToastUtils.showErrorToast(
          context, "Something went wrong, try again later.", "Error");
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
              HeadingText(text: "Hello,\nWelcome to your next course"),
              Text("Kindly register to get access"),
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
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.primary)),
                onTap: toggleDropdownVisibility,
                title: Text("${_dropdownValue ?? "Kindly select your role"}"),
                trailing: DropdownButton(
                    underline: SizedBox(),
                    items: [
                      DropdownMenuItem(
                        child: Text("student"),
                        value: "student",
                      ),
                      DropdownMenuItem(
                        child: Text("instructor"),
                        value: "instructor",
                      ),
                      DropdownMenuItem(
                        child: Text("approver"),
                        value: "approver",
                      ),
                    ],
                    //value: _dropdownValue,
                    onChanged: dropdownCallback),
              ),
              SizedBox(
                height: 20,
              ),
              CustomKtButton(btnText: "Register", onPress: _register,),
              SizedBox(height: 50,),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Already have an account? ", style: context.dividerTextLarge?.copyWith(color: Colors.black)),
                        TextSpan(text: "Login", style: context.dividerTextLarge?.copyWith(color: AppColors.primary))
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

import 'package:emtech_project/features/onboarding/login/login.dart';
import 'package:emtech_project/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommonRow extends StatefulWidget {
  final Color color;
  final String image;
  final String profile;
  const CommonRow(
      {super.key,
      required this.color,
      required this.image,
      required this.profile});

  @override
  State<CommonRow> createState() => _CommonRowState();
}

class _CommonRowState extends State<CommonRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                image: DecorationImage(image: AssetImage(widget.image))),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are you sure you want to logout?"),
                      actions: [
                        CustomKtButton(
                          width: 100,
                          height: 40,
                          btnText: "Logout",
                          onPress: () async{
                            
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            
                          },
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"))
                      ],
                    );
                  });
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(widget.profile),
            ),
          )
        ],
      ),
    );
  }
}

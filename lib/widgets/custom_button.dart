import 'package:emtech_project/extensions/hide_keyboard.dart';
import 'package:flutter/material.dart';

class CustomKtButton extends StatelessWidget {
  final String btnText;
  final VoidCallback? onPress;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool? isActive;
  final EdgeInsets? margin;
  final Alignment? alignment;

  const CustomKtButton(
      {Key? key,
      required this.btnText,
      this.onPress,
      this.width,
      this.height,
      this.margin,
      this.alignment,
      this.isActive = true,
      this.isLoading = false,
      String? text,
      Null Function()? onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: isActive != null && isActive!
              ? WidgetStateProperty.all(Theme.of(context).primaryColor)
              : WidgetStateProperty.all(
                  Theme.of(context).colorScheme.outline,
                ),
        ),
        onPressed: isLoading
            ? null
            : () {
                context.hideKeyboard();

                onPress?.call();
              },
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                btnText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
      ),
    );
  }
}
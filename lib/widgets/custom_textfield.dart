import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double? height;
  final double? width;

  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final bool? isRequired;
  final int? maxLength;
  final bool obscureText;
  final bool showNoKeyboard;
  final List<TextInputFormatter>? inputFormatters;
  final double paddingHorizontal;
  final Widget? suffixIcon;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final String? initialValue;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.height,
      this.labelText = 'Enter text',
      this.hintText = '',
      this.suffixIcon,
      this.width,
      this.maxLength,
      this.prefixIcon,
      this.inputFormatters,
      this.paddingHorizontal = 0,
      this.obscureText = false,
      this.isRequired = false,
      this.showNoKeyboard = false,
      this.validator,
      this.initialValue,
      this.prefix});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width == null ? double.infinity : width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal, vertical: 7),
        child: SizedBox(
          //height: height ?? 65.h,
          child: TextFormField(
            initialValue: initialValue,
            maxLength: maxLength,
            controller: controller,
            obscureText: obscureText,
            inputFormatters: showNoKeyboard
                ? [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ]
                : null,
            keyboardType: showNoKeyboard ? TextInputType.number : null,
            validator: validator,
            decoration: InputDecoration(
              prefix: prefix,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(labelText),
                  Visibility(
                    visible: isRequired ?? false,
                    child: Text(
                      " *",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                ],
              ),
              suffix: suffixIcon,
              counter: const SizedBox.shrink(),
              hintText: hintText,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blueAccent.withOpacity(0.1),
            ),
          ),
        ),
      ),
    );
  }
}

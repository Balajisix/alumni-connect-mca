import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization; // Added text capitalization

  CustomTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none, required MaterialColor borderColor, // Default: No capitalization
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  get hintText => null;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization, // Apply capitalization
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.white), // ✅ Typed text will be white
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.white70), // ✅ Hint text in white (slightly dim)
        prefixIcon: Icon(widget.icon, color: Colors.white), // ✅ Icon color set to white
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // ✅ White border
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // ✅ White border when focused
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if(value == null || value.isEmpty){
          return "Please enter fields";
        }
        return null;
      },
    );
  }
}

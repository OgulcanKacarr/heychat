import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final bool useSpace;
  final bool isOnChange;
  final Function(String)? onchange_func;


  CustomTextfieldWidget({
    required this.hint,
    required this.controller,
    required this.keyboardType,
    required this.isPassword,
    required this.prefixIcon,
    this.suffixIcon,
    this.useSpace = false,
    this.isOnChange = false,
    this.onchange_func
  });

  @override
  _CustomTextfieldWidgetState createState() => _CustomTextfieldWidgetState();
}

class _CustomTextfieldWidgetState extends State<CustomTextfieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.pinkAccent,
            width: 2.0,
          ),
        ),
        labelText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle password visibility
            });
          },
          child: widget.suffixIcon,
        )
            : null,
      ),
      onChanged: widget.isOnChange ? widget.onchange_func : null,
      inputFormatters: widget.useSpace
          ? [] // Boşluk karakterine izin ver
          : [FilteringTextInputFormatter.deny(RegExp(r'\s'))], // Boşluk karakterini engelle
    );
  }
}

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTextField
    extends StatelessWidget {
  final TextEditingController
      controller;

  final String label;

  final String hint;

  final IconData? prefixIcon;

  final bool obscureText;

  final TextInputType
      keyboardType;

  final String? Function(
    String?,
  )? validator;

  final int maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType =
        TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return TextFormField(
      controller:
          controller,
      obscureText:
          obscureText,
      keyboardType:
          keyboardType,
      validator:
          validator,
      maxLines:
          obscureText
              ? 1
              : maxLines,
      decoration:
          InputDecoration(
        labelText:
            label,
        hintText:
            hint,
        prefixIcon:
            prefixIcon == null
                ? null
                : Icon(
                    prefixIcon,
                    color:
                        AppColors
                            .textSecondary,
                  ),
        filled:
            true,
        fillColor:
            AppColors.surface,
        contentPadding:
            const EdgeInsets
                .symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                AppColors.border,
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                AppColors.border,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
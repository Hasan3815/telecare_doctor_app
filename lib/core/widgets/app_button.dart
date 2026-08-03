import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppButton
    extends StatelessWidget {
  final String text;

  final VoidCallback?
      onPressed;

  final bool isLoading;

  final IconData? icon;

  final Color?
      backgroundColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child:
          ElevatedButton(
        onPressed:
            isLoading
                ? null
                : onPressed,
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ??
                  AppColors.primary,
          foregroundColor:
              Colors.white,
          disabledBackgroundColor:
              AppColors.primary
                  .withValues(
            alpha: 0.6,
          ),
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  if (icon != null) ...[
                    Icon(icon),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  Text(
                    text,
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
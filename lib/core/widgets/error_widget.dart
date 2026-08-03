import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppErrorWidget
    extends StatelessWidget {
  final String message;

  final VoidCallback?
      onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons
                  .error_outline_rounded,
              size: 54,
              color:
                  AppColors.error,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              message,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color: AppColors
                    .textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(
                height: 18,
              ),
              OutlinedButton(
                onPressed:
                    onRetry,
                child:
                    const Text(
                  'Try Again',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
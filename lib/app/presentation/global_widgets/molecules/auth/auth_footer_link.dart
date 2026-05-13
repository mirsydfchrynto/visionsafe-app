import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// Link navigasi di bawah layar auth (misal: "Join the quest!").
class AuthFooterLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: AppTextStyles.bodyMedium),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: Color(0xFF003366),
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

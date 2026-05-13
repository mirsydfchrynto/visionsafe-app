import 'package:flutter/material.dart';

/// Pemisah antara form manual dan social auth.
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1.5)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1.5)),
      ],
    );
  }
}

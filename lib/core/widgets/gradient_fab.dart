import 'package:flutter/material.dart';

class GradientFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const GradientFAB({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF253D2C),
              Color(0xFF2E6F40),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: const Color.fromARGB(255, 210, 208, 208), size: 28),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final List<Color>? gradientColors;
  final Alignment gradientCenter;
  final double gradientRadius;
  final bool isGlass;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 16,
    this.fontSize = 18,
    this.gradientColors,
    this.gradientCenter = Alignment.topCenter,
    this.gradientRadius = 1.5,
    this.isGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    // Default blue gradient for primary button
    final List<Color> defaultGradient = [
      const Color(0xFF4CABEF), // Lighter blue for highlight
      const Color(0xFF007ACC), // Base blue
    ];

    // Glass effect gradient
    final List<Color> glassGradient = [
      Colors.white.withOpacity(0.3), // Lighter center
      Colors.white.withOpacity(0.1), // Darker/transparent edges
    ];

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: isGlass
            ? Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1,
              )
            : null,
        gradient: RadialGradient(
          center: gradientCenter,
          radius: gradientRadius,
          colors: gradientColors ?? (isGlass ? glassGradient : defaultGradient),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

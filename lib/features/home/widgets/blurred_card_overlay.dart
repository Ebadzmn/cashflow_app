import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';

class BlurredCardOverlay extends StatelessWidget {
  final Widget child;
  final bool isPro;

  const BlurredCardOverlay({
    super.key,
    required this.child,
    required this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    if (isPro) {
      return child;
    }

    return Stack(
      children: [
        // The underlying card
        child,

        // The Blur Overlay
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              16,
            ), // Match standard card radius
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.white.withValues(
                  alpha: 0.1,
                ), // White tint instead of black
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    context.push(Routes.PREMIUM_PLANS);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Normal White Button
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.workspace_premium,
                          color: Color(0xFF2F80ED),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Upgrade to Pro',
                          style: TextStyle(
                            color: Color(0xFF2F80ED), // Blue text
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

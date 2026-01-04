import 'dart:ui';

import 'package:flutter/material.dart';

enum AppSnackBarType { success, error, warning, info }

class AppSnackBar {
  static void show(
      BuildContext context, {
        required String message,
        AppSnackBarType type = AppSnackBarType.info,
      }) {
    final config = _config(type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: config.color.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      config.icon,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  static _SnackBarConfig _config(AppSnackBarType type) {
    return switch (type) {
      AppSnackBarType.success => const _SnackBarConfig(
        color: Color(0xFF2ECC71),
        icon: Icons.check_circle_rounded,
      ),
      AppSnackBarType.error => const _SnackBarConfig(
        color: Color(0xFFE74C3C),
        icon: Icons.error_rounded,
      ),
      AppSnackBarType.warning => const _SnackBarConfig(
        color: Color(0xFFF39C12),
        icon: Icons.warning_rounded,
      ),
      AppSnackBarType.info => const _SnackBarConfig(
        color: Color(0xFF3498DB),
        icon: Icons.info_rounded,
      ),
    };
  }
}

class _SnackBarConfig {
  final Color color;
  final IconData icon;

  const _SnackBarConfig({
    required this.color,
    required this.icon,
  });
}


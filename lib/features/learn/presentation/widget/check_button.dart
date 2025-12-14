import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';

class CheckButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const CheckButton({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<CheckButton> createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: width,
      child: Center(
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: width - 20,
            height: width * 0.15,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? const Color.fromRGBO(49, 230, 62, 1.0)
                  : const Color.fromRGBO(223, 223, 223, 1.0),
              borderRadius: BorderRadius.circular(20),
              boxShadow: widget.enabled
                  ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  offset: _isPressed
                      ? const Offset(2, 2)
                      : const Offset(6, 6),
                  blurRadius: _isPressed ? 6 : 12,
                ),
              ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.white24,
                highlightColor: Colors.transparent,
                onTapDown: widget.enabled
                    ? (_) => setState(() => _isPressed = true)
                    : null,
                onTapUp: widget.enabled
                    ? (_) {
                  setState(() => _isPressed = false);
                  widget.onTap();
                }
                    : null,
                onTapCancel: () =>
                    setState(() => _isPressed = false),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.learn_btn_check,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.enabled
                          ? Colors.white
                          : const Color.fromRGBO(166, 166, 166, 1.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

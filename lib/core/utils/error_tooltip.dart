import 'package:flutter/material.dart';

class ErrorTooltip {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context, GlobalKey anchorKey, String message) {
    // Remove existing tooltip if any
    hide();

    final RenderBox? renderBox = anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + size.height,
        left: position.dx,
        width: size.width,
        child: Material(
          color: Colors.transparent,
          child: Text(
            message,
            style: const TextStyle(color: Colors.red, fontSize: 12.0),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
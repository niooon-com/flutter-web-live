import "dart:ui";
import "package:flutter/material.dart";

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final Color? borderColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 22.0,
    this.blur = 16.0,
    this.backgroundColor,
    this.borderColor,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF111B21).withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.1),
              width: 1.0,
            ),
        boxShadow: boxShadow ??
            [
              // 3D bottom drop shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              // Subtle top-left highlight glow
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 38.0,
    this.color,
    this.backgroundColor,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.size,
          height: widget.size,
          transform: Matrix4.translationValues(0, _isPressed ? 1.5 : 0, 0),
          decoration: BoxDecoration(
            color: widget.backgroundColor ??
                (_isPressed
                    ? const Color(0xFF202C33).withValues(alpha: 0.95)
                    : const Color(0xFF202C33).withValues(alpha: 0.75)),
            borderRadius: BorderRadius.circular(widget.size * 0.32),
            border: Border.all(
              color: _isPressed
                  ? const Color(0xFF00A884).withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.14),
              width: 1.1,
            ),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [
                    // 3D tactile elevation
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(-1, -1),
                    ),
                  ],
          ),
          child: Icon(
            widget.icon,
            color: widget.color ?? const Color(0xFFE9EDEF),
            size: widget.size * 0.48,
          ),
        ),
      ),
    );
  }
}

class GlassButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? color;
  final double borderRadius;

  const GlassButton({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.gradient,
    this.color,
    this.borderRadius = 14.0,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: widget.gradient ??
              const LinearGradient(
                colors: [Color(0xFF00A884), Color(0xFF008069)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: Colors.white.withValues(alpha: _isPressed ? 0.2 : 0.35),
            width: 1.1,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [
                  // 3D elevated button shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: const Color(0xFF25D366).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.15),
                    blurRadius: 3,
                    offset: const Offset(-1, -1),
                  ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}

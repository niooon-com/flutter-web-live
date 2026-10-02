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
    this.borderRadius = 24.0,
    this.blur = 18.0,
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
        color: backgroundColor ?? const Color(0xFF0F172A).withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.1),
              width: 1.0,
            ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 4),
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

class GlassIconButton extends StatelessWidget {
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
    this.size = 40.0,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(size * 0.3),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Icon(
            icon,
            color: color ?? Colors.white70,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
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
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          color: color ?? Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: gradient != null
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.15),
          ),
          boxShadow: [
            if (gradient != null)
              BoxShadow(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                blurRadius: 16,
                spreadRadius: 1,
              ),
          ],
        ),
        child: child,
      ),
    );
  }
}

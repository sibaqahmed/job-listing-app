import 'package:flutter/material.dart';

class AnimatedShiningTitle extends StatefulWidget {
  final String text;
  final double minScale;
  final double maxScale;
  final Duration duration;

  const AnimatedShiningTitle({
    Key? key,
    required this.text,
    this.minScale = 0.98,
    this.maxScale = 1.06,
    this.duration = const Duration(milliseconds: 1400),
  }) : super(key: key);

  @override
  _AnimatedShiningTitleState createState() => _AnimatedShiningTitleState();
}

class _AnimatedShiningTitleState extends State<AnimatedShiningTitle> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final accent = theme.colorScheme.secondary;

    final TextStyle baseGlowStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 20,
    ) ??
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w800);

    final TextStyle baseMainStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w900,
      fontSize: 20,
      letterSpacing: 0.2,
    ) ??
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.2);

    return ScaleTransition(
      scale: _scaleAnim,
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (context, child) {
          final glowVal = _glowAnim.value;

          final color = Color.lerp(primary, accent, glowVal * 0.6) ?? primary;
          final shadowBlur = 6.0 + (glowVal * 8.0);
          final shadowColor = color.withOpacity(0.25 + glowVal * 0.25);

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Opacity(
                opacity: 0.35 * glowVal,
                child: Text(
                  widget.text,
                  style: baseGlowStyle.copyWith(
                    foreground: Paint()..color = color.withOpacity(0.6),
                    shadows: [
                      Shadow(
                        color: shadowColor,
                        blurRadius: shadowBlur,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                widget.text,
                style: baseMainStyle.copyWith(color: color),
              ),
            ],
          );
        },
      ),
    );
  }
}
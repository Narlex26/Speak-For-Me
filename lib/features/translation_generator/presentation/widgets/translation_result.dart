import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranslationResult extends StatefulWidget {
  final String text;
  final Color color;
  final bool isLegendary;

  const TranslationResult({
    super.key,
    required this.text,
    required this.color,
    this.isLegendary = false,
  });

  @override
  State<TranslationResult> createState() => _TranslationResultState();
}

class _TranslationResultState extends State<TranslationResult>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(48),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: widget.isLegendary
              ? const Color(0xFFFFFDE7)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          gradient: widget.isLegendary
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF9C4), Color(0xFFFFECB3)],
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: widget.isLegendary
                  ? const Color(0xFFFFD600).withValues(alpha: 0.5)
                  : widget.color.withValues(alpha: 0.2),
              blurRadius: widget.isLegendary ? 30 : 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: widget.isLegendary
                ? const Color(0xFFFFD600)
                : widget.color.withValues(alpha: 0.3),
            width: widget.isLegendary ? 3 : 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isLegendary) ...[
              const Text('✨ TRADUCTION LÉGENDAIRE ✨',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF57F17), letterSpacing: 1.2)),
              const SizedBox(height: 12),
            ],
            Icon(
              Icons.format_quote_rounded,
              size: 32,
              color: widget.isLegendary ? const Color(0xFFFFB300) : widget.color.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 20),
            Text(
              widget.text,
              style: GoogleFonts.merriweather(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.format_quote_rounded,
              size: 32,
              color: widget.color.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
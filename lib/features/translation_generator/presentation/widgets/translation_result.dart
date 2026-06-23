import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranslationResult extends StatefulWidget {
  final String text;
  final Color color;
  final bool isEasterEgg;

  const TranslationResult({
    super.key,
    required this.text,
    required this.color,
    this.isEasterEgg = false,
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
    final accent = widget.isEasterEgg ? const Color(0xFFD4AF37) : widget.color;
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
          color: widget.isEasterEgg ? null : Colors.white,
          gradient: widget.isEasterEgg
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFDF5), Color(0xFFFDF3D0)],
                )
              : null,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: widget.isEasterEgg ? 0.4 : 0.2),
              blurRadius: widget.isEasterEgg ? 28 : 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: accent.withValues(alpha: widget.isEasterEgg ? 0.6 : 0.3),
            width: widget.isEasterEgg ? 2.5 : 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isEasterEgg) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'PHRASE LÉGENDAIRE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            Icon(
              Icons.format_quote_rounded,
              size: 32,
              color: accent.withValues(alpha: 0.5),
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
              color: accent.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}


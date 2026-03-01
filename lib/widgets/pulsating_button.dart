import 'package:flutter/material.dart';

class PulsatingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isRecording;
  final Color color;
  final IconData icon;

  const PulsatingButton({
    super.key,
    required this.onPressed,
    required this.isRecording,
    required this.color,
    required this.icon,
  });

  @override
  State<PulsatingButton> createState() => _PulsatingButtonState();
}

class _PulsatingButtonState extends State<PulsatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        if (widget.isRecording) {
          _controller.forward();
        }
      }
    });
  }

  @override
  void didUpdateWidget(PulsatingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !_controller.isAnimating) {
      _controller.forward();
    } else if (!widget.isRecording) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsating ring
        if (widget.isRecording)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 140 * _scaleAnimation.value,
                height: 140 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withOpacity(_opacityAnimation.value),
                    width: 4,
                  ),
                ),
              );
            },
          ),
        // Second pulsating ring (delayed)
        if (widget.isRecording)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delayedValue = (_scaleAnimation.value - 0.15).clamp(1.0, 1.3);
              final delayedOpacity = (_opacityAnimation.value + 0.15).clamp(0.0, 0.6);
              return Container(
                width: 140 * delayedValue,
                height: 140 * delayedValue,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withOpacity(delayedOpacity),
                    width: 3,
                  ),
                ),
              );
            },
          ),
        // Main button
        GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.isRecording ? 100 : 120,
            height: widget.isRecording ? 100 : 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isRecording
                    ? [Colors.red.shade400, Colors.red.shade600]
                    : [widget.color, widget.color.withValues(alpha: 0.7)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.isRecording ? Colors.red : widget.color)
                      .withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              widget.isRecording ? Icons.stop_rounded : widget.icon,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}


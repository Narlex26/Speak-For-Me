import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SpectralGraphWidget extends StatefulWidget {
  final Color baseColor;
  final bool isAnimating;

  const SpectralGraphWidget({
    super.key,
    required this.baseColor,
    this.isAnimating = true,
  });

  @override
  State<SpectralGraphWidget> createState() => _SpectralGraphWidgetState();
}

class _SpectralGraphWidgetState extends State<SpectralGraphWidget> {
  final List<double> _bars = List.filled(30, 0.0);
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.isAnimating) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(SpectralGraphWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _startAnimation();
      } else {
        _timer?.cancel();
        // Reset bars
        setState(() {
          for (int i = 0; i < _bars.length; i++) {
            _bars[i] = 0.1;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          for (int i = 0; i < _bars.length; i++) {
            // Generate random height between 0.1 and 1.0 with some noise coherence
            double noise = _random.nextDouble() * 0.8 + 0.1;
            // Smooth transition
            _bars[i] = (_bars[i] + noise) / 2;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.baseColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SPECTRAL ANALYSIS',
                style: TextStyle(
                  color: widget.baseColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_bars.length, (index) {
                return Flexible(
                  child: FractionallySizedBox(
                    heightFactor: _bars[index],
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: widget.baseColor.withOpacity(0.7),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}


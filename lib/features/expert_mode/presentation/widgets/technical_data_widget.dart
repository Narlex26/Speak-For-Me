import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TechnicalDataWidget extends StatefulWidget {
  const TechnicalDataWidget({super.key});

  @override
  State<TechnicalDataWidget> createState() => _TechnicalDataWidgetState();
}

class _TechnicalDataWidgetState extends State<TechnicalDataWidget> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  final Random _random = Random();

  final List<String> _technicalTerms = [
    'Analyzing audio stream...',
    'Frequency modulation detected',
    'Decoding specialized phonemes...',
    'Applying FFT transform',
    'Filtering background noise',
    'Calibrating vocal sensors',
    'Cross-referencing database',
    'Neural network activated',
    'Pattern recognition: 98%',
    'Isolating emotional vector',
    'Decrypting secret code...',
    'Processing...',
    'Buffer overflow prevented',
    'Quantum stabilizing...'
  ];

  @override
  void initState() {
    super.initState();
    _startLogGeneration();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startLogGeneration() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() {
          if (_logs.length > 20) {
            _logs.removeAt(0);
          }
          final term = _technicalTerms[_random.nextInt(_technicalTerms.length)];
          final value = _random.nextInt(9999);
          _logs.add('D: ${DateTime.now().millisecond} | $term [0x${value.toRadixString(16).toUpperCase()}]');
        });

        // Auto-scroll to bottom
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.greenAccent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SYSTEM LOG [DEBUG]',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 10,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.greenAccent, height: 4, thickness: 0.5),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                return Text(
                  _logs[index],
                  style: const TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 10,
                    fontFamily: 'Courier',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


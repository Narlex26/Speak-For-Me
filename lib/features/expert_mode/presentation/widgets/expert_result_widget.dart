import 'package:flutter/material.dart';

class ExpertResultWidget extends StatelessWidget {
  final Color color;

  const ExpertResultWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                'ANALYSIS COMPLETE',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 20),
          _buildStatRow('Confidence Score', '99.9%', Colors.greenAccent),
          _buildStatRow('Emotional Vector', 'Sarcastic / Hungry', Colors.orangeAccent),
          _buildStatRow('Frequency Range', '452Hz - 12kHz', Colors.blueAccent),
          _buildStatRow('Processing Time', '0.042ms', Colors.white70),
          const SizedBox(height: 8),
          Text(
            'Note: Result certified by neural network batch #4829.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'Courier',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


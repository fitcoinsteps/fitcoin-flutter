import 'package:flutter/material.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';

class TrackingStatsCard extends StatelessWidget {
  final TrackingSession session;
  const TrackingStatsCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tracking Active',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Started: ${session.startedAt.toLocal()}'),
            // Add more stats like distance if available
          ],
        ),
      ),
    );
  }
}
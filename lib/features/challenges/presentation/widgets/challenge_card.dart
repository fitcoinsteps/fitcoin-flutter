import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/challenges/domain/entities/challenge.dart';
import 'package:fitcoin/features/challenges/domain/entities/user_challenge.dart';
import 'package:fitcoin/features/challenges/presentation/providers/challenge_providers.dart';
import 'package:fitcoin/features/challenges/presentation/states/challenge_states.dart';

class ChallengeCard extends ConsumerWidget {
  final Challenge challenge;

  const ChallengeCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(challengeControllerProvider);

    // Find active challenge matching this card's challenge ID
    UserChallenge? activeChallenge;
    if (state is ChallengesLoaded) {
      for (final uc in state.activeChallenges) {
        if (uc.challengeId == challenge.id) {
          activeChallenge = uc;
          break;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Title and progress info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (activeChallenge != null) ...[
                  // "23/500 steps"
                  Text(
                    '${activeChallenge.stepsGained}/${activeChallenge.goalValue} steps',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (activeChallenge.progressPercent / 100).clamp(0.0, 1.0),
                      backgroundColor: Colors.white.withOpacity(0.1),
                      color: Colors.green,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activeChallenge.progressPercent >= 100
                        ? 'Completed'
                        : 'Need ${(activeChallenge.goalValue - activeChallenge.stepsGained).clamp(0, 999999)} more',
                    style: TextStyle(
                      color: activeChallenge.progressPercent >= 100 ? Colors.green : Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ] else
                // Inactive
                  Text(
                    '${challenge.goalValue} steps in ${challenge.timeLimitMinutes} min',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Action button / check
          activeChallenge != null
              ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
              : ElevatedButton(
            onPressed: () {
              ref
                  .read(challengeControllerProvider.notifier)
                  .activateChallenge(challenge.id);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }
}
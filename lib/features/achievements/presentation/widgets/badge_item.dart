import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';

class BadgeItem extends StatelessWidget {
  final AchievementModel achievement;

  const BadgeItem({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: achievement.isUnlocked
                ? Colors.amber.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            border: Border.all(
              color: achievement.isUnlocked ? Colors.amber : Colors.grey,
              width: 2,
            ),
            boxShadow: achievement.isUnlocked
                ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              achievement.icon,
              style: TextStyle(
                fontSize: 32,
                color: achievement.isUnlocked ? null : Colors.grey,
                shadows: achievement.isUnlocked
                    ? [
                        const Shadow(
                          blurRadius: 10.0,
                          color: Colors.amber,
                          offset: Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          achievement.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: achievement.isUnlocked ? Colors.black87 : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          achievement.description,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

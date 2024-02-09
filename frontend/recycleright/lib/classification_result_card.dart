import 'package:flutter/material.dart';

class ClassificationResultCard extends StatelessWidget {
  final String category;
  final String advice;
  const ClassificationResultCard({
    Key? key,
    required this.category,
    required this.advice, required CrossAxisAlignment crossAxisAlignment,
  }) : super(key: key);

  IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'recycle':
        return Icons.recycling;
      case 'compost':
        return Icons.park;
      case 'landfill':
        return Icons.delete;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData categoryIcon = getIconForCategory(category);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              categoryIcon,
              size: 48,
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            Text(
              category,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              advice,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

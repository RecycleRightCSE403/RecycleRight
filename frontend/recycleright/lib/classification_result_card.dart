import 'package:flutter/material.dart';

class ClassificationResultCard extends StatelessWidget {
  final String category;
  final String advice;

  const ClassificationResultCard({
    Key? key,
    required this.category,
    required this.advice,
    required CrossAxisAlignment crossAxisAlignment,
  }) : super(key: key);

  // Updated to include "Garbage" and "Error" categories
  Map<String, dynamic> getIconAndColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'recycle':
        return {
          'icon': Icons.recycling,
          'color': Colors.green,
        };
      case 'compost':
        return {
          'icon': Icons.park,
          'color': Colors.lightGreen,
        };
      case 'other':
        return {
          'icon': Icons.delete,
          'color': Colors.grey,
        };
      case 'garbage':
        return {
          'icon': Icons.delete_outline,
          'color': Colors.brown,
        };
      case 'error':
        return {
          'icon': Icons.error_outline, 
          'color': Colors.red, 
        };
      default:
        return {
          'icon': Icons.question_mark,
          'color': Colors.grey,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = getIconAndColorForCategory(category);
    final IconData categoryIcon = categoryData['icon'];
    final Color color = categoryData['color'];

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
              color: color, 
            ),
            const SizedBox(height: 10),
            Text(
              category,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color, 
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

import 'package:flutter/material.dart';

class ClassificationResultCard extends StatelessWidget {
  final String category;
  final Widget adviceWidget;

  const ClassificationResultCard({
    Key? key,
    required this.category,
    required this.adviceWidget,
  }) : super(key: key);

  Map<String, dynamic> getIconAndColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'recycle':
        return {'icon': Icons.recycling, 'color': Colors.green};
      case 'compost':
        return {'icon': Icons.park, 'color': Colors.lightGreen};
      case 'garbage':
        return {'icon': Icons.delete_outline, 'color': Colors.brown};
      case 'donate':
        return {'icon': Icons.volunteer_activism, 'color': Colors.purple};
      case 'special':
        return {'icon': Icons.star, 'color': Colors.orange};
      default:
        return {'icon': Icons.help_outline, 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = getIconAndColorForCategory(category);
    final IconData categoryIcon = categoryData['icon'];
    final Color color = categoryData['color'];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2), // just changing the background
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                categoryIcon,
                size: 60,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                category,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 10),
              adviceWidget,
            ],
          ),
        ),
      ),
    );
  }
}

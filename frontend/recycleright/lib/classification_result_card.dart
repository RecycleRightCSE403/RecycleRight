import 'package:flutter/material.dart';

// A custom widget that displays the classification result of an item.
//
// This widget presents a card with an icon and colors corresponding to the classification
// category (e.g., recycle, compost, other, garbage, or error), along with advice on how
// to properly dispose of the item. It's designed to provide a visually appealing and
// informative summary for the user.
class ClassificationResultCard extends StatelessWidget {
  // The category of the item as determined by the classification model.
  //
  // This value is used to determine the icon and color to display on the card.
  final String category;
  // A widget containing advice or instructions related to the item's disposal
  // based on its category.
  final Widget adviceWidget;


  // Constructs a `ClassificationResultCard` widget.
  //
  // Requires [category] and [advice] parameters to display classification information.
  // The [crossAxisAlignment] parameter is also required for layout purposes, though
  // its usage has been deprecated in favor of internal layout decisions.
  const ClassificationResultCard({
    Key? key,
    required this.category,
    required this.adviceWidget,
  }) : super(key: key);

  // Determines the icon and color associated with the specified category.
  //
  // The function maps category names to their corresponding icons and colors.
  // Categories include 'recycle', 'compost', 'other', 'garbage', and 'error',
  // with a default fallback for unrecognized categories.
  //
  // - Parameters:
  //   - category: The category name to get the icon and color for.
  // - Returns: A map containing the 'icon' as an [IconData] and 'color' as a [Color].
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
    // Retrieve icon and color based on the category of the item.
    final categoryData = getIconAndColorForCategory(category);
    final IconData categoryIcon = categoryData['icon'];
    final Color color = categoryData['color'];

    // The card layout includes the icon, category name, and advice text.
    return Card(
      elevation: 8, // Adds a subtle shadow for depth effect.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2), // just changing the background
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Ensures content is nicely spaced within the card.
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimizes the column's height to fit its content.
            children: [
              Icon(
                categoryIcon,
                size: 60,
                color: color,
              ),
              const SizedBox(height: 12), // Spacing between the icon and category name.
              Text(
                category,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 10), // Spacing between the category name and advice text.
              adviceWidget,
            ],
          ),
        ),
      ),
    );
  }
}

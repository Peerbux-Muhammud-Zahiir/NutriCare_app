import 'package:flutter/material.dart';

class EmoticonFace extends StatelessWidget {
  final String emoticonFace;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final Color color; // Add this parameter

  const EmoticonFace({
    Key? key,
    required this.emoticonFace,
    required this.label,
    required this.onTap,
    required this.isSelected,
    required this.color, // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoticonFace,
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

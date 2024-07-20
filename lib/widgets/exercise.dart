import 'package:flutter/material.dart';

class ExerciseTile extends StatefulWidget {
  final IconData icon;
  final String exerciseName;
  final Color color;
  final VoidCallback onTap;
  final bool isSelected;
  final String description;

  const ExerciseTile({
    required this.icon,
    required this.exerciseName,
    required this.color,
    required this.onTap,
    required this.isSelected,
    required this.description,
  });

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  Color borderColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        setState(() {
          borderColor = widget.color.withOpacity(0.6); // Change border color on tap
        });
      },
      onTapCancel: () {
        setState(() {
          borderColor = Colors.transparent; // Reset border color if tap is canceled
        });
      },
      onTapUp: (_) {
        setState(() {
          borderColor = widget.color; // Restore original border color on tap up
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2), // Dynamic border color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.exerciseName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

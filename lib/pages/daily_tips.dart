import 'package:flutter/material.dart';
import 'dart:math';
import 'package:nutricare/widgets/emoticon.dart';
import 'package:nutricare/widgets/exercise.dart';


class DailyTips extends StatefulWidget {
  const DailyTips({Key? key}) : super(key: key);

  @override
  State<DailyTips> createState() => _DailyTipsState();
}

class _DailyTipsState extends State<DailyTips> {
  String selectedEmotion = '';
  String selectedExercise = '';

  List<String> quotes = [
    "You are enough just as you are !",
    "Your patience is your power.",
    "Take a small step everyday, you're almost there!",
  ];

  void onEmotionSelected(String emotion) {
    setState(() {
      selectedEmotion = emotion;
    });
  }

  void onExerciseSelected(String exerciseName, String message, Color color) {
    setState(() {
      selectedExercise = exerciseName;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: color,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void showRandomQuote() {
    int index = Random().nextInt(quotes.length);
    String quote = quotes[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.greenAccent,
          content: Text(
            quote,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hi! Click the bell icon for a quote",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: showRandomQuote,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'How do you feel?',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmoticonFace(
                    emoticonFace: '😞',
                    label: 'Bad',
                    onTap: () => onEmotionSelected('Bad'),
                    isSelected: selectedEmotion == 'Bad',
                  ),
                  EmoticonFace(
                    emoticonFace: '😊',
                    label: 'Fine',
                    onTap: () => onEmotionSelected('Fine'),
                    isSelected: selectedEmotion == 'Fine',
                  ),
                  EmoticonFace(
                    emoticonFace: '😁',
                    label: 'Well',
                    onTap: () => onEmotionSelected('Well'),
                    isSelected: selectedEmotion == 'Well',
                  ),
                  EmoticonFace(
                    emoticonFace: '🤩',
                    label: 'Excellent',
                    onTap: () => onEmotionSelected('Excellent'),
                    isSelected: selectedEmotion == 'Excellent',
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView(
                  children: [
                    ExerciseTile(
                      icon: Icons.directions_run,
                      exerciseName: 'Exercise',
                      color: Colors.orange,
                      onTap: () => onExerciseSelected(
                        'Exercise',
                        'Some examples include:\n1. Squats for your legs.\n2. Lunges for your upper legs.\n3. Planks for your core and back.\n4. Pull-ups for your biceps, shoulders, and wrists.',
                        Colors.orange,
                      ),
                      isSelected: selectedExercise == 'Exercise',
                      description:
                      'Exercise is a natural stress reliever. When you are physically active, it changes the body\'s chemistry in a positive way.',
                    ),
                    ExerciseTile(
                      icon: Icons.mood,
                      exerciseName: 'Stress Management',
                      color: Colors.green,
                      onTap: () => onExerciseSelected(
                        'Stress Management',
                        'Some stress management activities include:\n1. Go on a walk.\n2. Take a jog.\n3. Listen to calming music.\n4. Take breaks when needed.',
                        Colors.green,
                      ),
                      isSelected: selectedExercise == 'Stress Management',
                      description:
                      'Stress is unavoidable, but knowing what triggers your stress and knowing how to cope is key in maintaining good mental health.',
                    ),
                    ExerciseTile(
                      icon: Icons.local_dining,
                      exerciseName: 'Eat Healthy',
                      color: Colors.pink,
                      onTap: () => onExerciseSelected(
                        'Eat Healthy',
                        'Some eating healthy techniques include:\n1. Increase Calcium and Vitamin D.\n2. Add more potassium.\n3. Limit Added Sugars.\n4. Aim for a Variety of Colours.',
                        Colors.pink,
                      ),
                      isSelected: selectedExercise == 'Eat Healthy',
                      description:
                      'Your brain is one of the busiest organs in your body and it needs the right kind of fuel to keep it functioning at its very best.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmoticonFace extends StatelessWidget {
  final String emoticonFace;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const EmoticonFace({
    required this.emoticonFace,
    required this.label,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.greenAccent : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              emoticonFace,
              style: TextStyle(
                fontSize: 32,
                color: isSelected ? Colors.black : Colors.greenAccent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}

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
          borderColor = Colors.greenAccent;
        });
      },
      onTapCancel: () {
        setState(() {
          borderColor = Colors.transparent;
        });
      },
      onTapUp: (_) {
        setState(() {
          borderColor = Colors.transparent;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  widget.exerciseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

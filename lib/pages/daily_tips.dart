import 'package:flutter/material.dart';
import 'package:nutricare/widgets/emoticon.dart';
import 'package:nutricare/widgets/exercise.dart';
import 'package:nutricare/widgets/survey_dialog.dart';
import 'dart:math';

class DailyTips extends StatefulWidget {
  const DailyTips({Key? key}) : super(key: key);

  @override
  State<DailyTips> createState() => _DailyTipsState();
}

class _DailyTipsState extends State<DailyTips> {
  String selectedEmotion = '';
  String selectedExercise = '';

  List<String> quotes = [
    "You are enough just as you are!",
    "Your patience is your power.",
    "Take a small step every day, you're almost there!",
  ];

  void onEmotionSelected(String emotion, Color color) {
    setState(() {
      selectedEmotion = emotion;
    });

    _showEmotionDialog(emotion, color);
  }

  void _showEmotionDialog(String emotion, Color color) {
    String message;
    switch (emotion) {
      case 'Bad':
        message = 'Hey there, it looks like you\'re feeling down today.\n\nQuick Activities:\n\n- Take a few deep breaths and focus on the present moment.\n- Step outside for some fresh air and sunshine (if possible).\n- Do a short burst of exercise (jumping jacks, dancing, a quick walk).\n- Listen to some upbeat music.\n\nSelf-Care Tips:\n\n- Treat yourself to something you enjoy, like a warm bath, reading a good book, or watching a funny movie.\n- Talk to a friend or family member you trust about how you\'re feeling.\n- Write down your thoughts and feelings in a journal. This can help you process and understand what\'s bothering you.';
        break;
      case 'Fine':
        message = 'Hey! It looks like you\'re doing alright today.\n\nSometimes it\'s good to mix things up a bit! How about trying one of these:\n\n- Challenge yourself: Learn a new skill, try a new recipe, take a different route on your walk.\n- Express yourself creatively: Write, draw, paint, dance, sing - anything to get your creative juices flowing.\n- Connect with others: Spend time with loved ones, join a club or group activity, volunteer in your community.';
        break;
      case 'Well':
        message = 'Fantastic! Feeling well is something to celebrate! Tracking your mood is a great way to gain self-awareness and identify what helps you feel your best.\n\nGreat goal for tomorrow! Here are some quick exercise ideas if you need a little inspiration:\n\n- Take a brisk walk or jog\n- Do a short yoga or bodyweight workout routine\n- Go for a bike ride';
        break;
      case 'Excellent':
        message = 'Woohoo! That\'s amazing to hear!\n\nSounds like you set yourself up for a fantastic day! Excellent planning, healthy habits, and accomplishment are all great recipes for feeling excellent.\n\nEven small habits like daily exercise can have a big impact on your overall well-being.\n\nRemember to celebrate your successes, big and small. Feeling excellent is something to be proud of!\n\nHave a fantastic rest of your day and keep up the excellent work! I\'m here to support you in any way I can.';
        break;
      default:
        message = 'Something went wrong.';
    }

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

  void showSurveyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SurveyDialog(
          questions: [
            "Have you been crying more than usual?",
            "Have you lost interest in activities you normally enjoy?",
            "Do you feel a lack of motivation or energy?",
            "Do you feel hopeless or like things won't get better?",
            "Have you experienced changes in your appetite or sleep patterns? (Trouble sleeping, sleeping more, overeating, loss of appetite)",
            "Have you noticed a change in your energy level?",
            "Do you feel motivated and engaged with your activities today, or are you going through the motions?",
            "Were there any small things you enjoyed or found positive?",
            "Do you feel energized and ready to tackle the day?",
            "Are you finding it easy to focus and concentrate on tasks today?",
            "Did you do anything specific today that you might want to incorporate more often to maintain a positive mood?",
            "Is there anything you can take from today's excellent mood and carry it forward into tomorrow?",
            "Do you feel like spreading the positivity?",
          ],
          onEmotionSelected: onEmotionSelected,
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
              const Text(
                'How do you feel?',
                style: TextStyle(
                  color: Color(0xFF2abca4),
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
                    onTap: () => onEmotionSelected('Bad', Colors.red),
                    isSelected: selectedEmotion == 'Bad',
                    color: Colors.red,
                  ),
                  EmoticonFace(
                    emoticonFace: '😊',
                    label: 'Fine',
                    onTap: () => onEmotionSelected('Fine', Colors.blue),
                    isSelected: selectedEmotion == 'Fine',
                    color: Colors.blue,
                  ),
                  EmoticonFace(
                    emoticonFace: '😁',
                    label: 'Well',
                    onTap: () => onEmotionSelected('Well', Colors.green),
                    isSelected: selectedEmotion == 'Well',
                    color: Colors.green,
                  ),
                  EmoticonFace(
                    emoticonFace: '🤩',
                    label: 'Excellent',
                    onTap: () => onEmotionSelected('Excellent', Colors.yellow),
                    isSelected: selectedEmotion == 'Excellent',
                    color: Colors.yellow,
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
                      onTap: () => _showExerciseDialog(
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
                      onTap: () => _showExerciseDialog(
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
                      onTap: () => _showExerciseDialog(
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
              const SizedBox(height: 20),
              SizedBox(
                width: 200, // Adjust the width to make it less wide
                height: 50, // Adjust the height to make it more compact
                child: ElevatedButton(
                  onPressed: showSurveyDialog,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF2abca4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Take a Survey',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExerciseDialog(String exerciseName, String message, Color color) {
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
}
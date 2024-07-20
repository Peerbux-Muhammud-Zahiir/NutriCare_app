import 'package:flutter/material.dart';

class SurveyDialog extends StatefulWidget {
  final List<String> questions;
  final void Function(String, Color) onEmotionSelected;

  const SurveyDialog({
    Key? key,
    required this.questions,
    required this.onEmotionSelected,
  }) : super(key: key);

  @override
  _SurveyDialogState createState() => _SurveyDialogState();
}

class _SurveyDialogState extends State<SurveyDialog> {
  Map<int, bool> _responses = {}; // Store the responses for each question

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Survey'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.questions.map((question) {
            int index = widget.questions.indexOf(question);
            return CheckboxListTile(
              title: Text(question),
              value: _responses[index] ?? false,
              onChanged: (bool? value) {
                setState(() {
                  _responses[index] = value ?? false;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _evaluateResponses();
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _evaluateResponses() {
    List<int> firstFive = List.generate(5, (index) => index);
    List<int> remaining = List.generate(widget.questions.length - 5, (index) => index + 5);

    int firstFiveChecked = _responses.entries.where((entry) => firstFive.contains(entry.key) && entry.value).length;
    int remainingChecked = _responses.entries.where((entry) => remaining.contains(entry.key) && entry.value).length;

    String emotion;
    Color color;

    if (firstFiveChecked > 0) {
      if (firstFiveChecked >= 2) {
        emotion = 'Fine';
        color = Colors.blue;
      } else {
        emotion = 'Bad';
        color = Colors.red;
      }
    } else if (remainingChecked >= 2) {
      emotion = 'Well';
      color = Colors.green;
    } else {
      emotion = 'Excellent';
      color = Colors.yellow;
    }

    widget.onEmotionSelected(emotion, color);
  }
}

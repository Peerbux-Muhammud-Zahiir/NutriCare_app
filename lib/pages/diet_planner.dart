import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutricare/widgets/food_type_card.dart';

class DietPlanner extends StatefulWidget {
  const DietPlanner({super.key});

  @override
  _DietPlannerState createState() => _DietPlannerState();
}

class _DietPlannerState extends State<DietPlanner> {
  List<String> meals = ['1 meal', '2 meals', '3 meals', '4 meals'];
  String selected = '4 meals';

  int _selectedOption1 = 1;
  int _selectedOption2 = 1;

  bool isAnythingSelected = false;
  bool isVegSelected = false;
  bool isMedSelected = false;
  bool isPaleoSelected = false;
  String? selectedCategory; // To store the currently selected category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50.0),
              Text(
                'Let us know your diet.',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                shrinkWrap: true,
                children: <Widget>[
                  _buildImageCard('https://i.ibb.co/pZcwHZ0/file-1.png', 'Pregnant Women', () {
                    _updateSelectedCategory('Pregnant Women');
                  }),
                  _buildImageCard('https://thumbs.dreamstime.com/b/female-olympic-athlete-running-marathon-person-celebrate-summer-games-athletics-medal-sportive-people-celebrating-track-field-174309058.jpg', 'Athletes', () {
                    _updateSelectedCategory('Athletes');
                  }),
                  _buildImageCard('https://static.vecteezy.com/system/resources/previews/001/879/424/non_2x/doctor-and-people-check-blood-sugar-level-with-glucose-meter-diabetes-type-two-check-up-diet-for-non-communicable-diseases-checking-insulin-illustration-for-business-card-banner-brochure-flyer-free-vector.jpg', 'Diabetic Patients', () {
                    _updateSelectedCategory('Diabetic Patients');
                  }),
                  _buildImageCard('https://static.vecteezy.com/system/resources/thumbnails/002/226/928/small/kawaii-heart-versus-high-cholesterol-levels-vector.jpg', 'Cholesterol Patients', () {
                    _updateSelectedCategory('Cholesterol Patients');
                  }),
                ],
              ),
              const SizedBox(height: 15.0),
              const SizedBox(height: 10.0),
              const SizedBox(height: 15.0),
              const SizedBox(height: 10.0),
              const SizedBox(height: 15.0),
              Text(
                'Weight',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio<int>(
                        value: 1,
                        groupValue: _selectedOption1,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption1 = value!;
                          });
                        },
                      ),
                      Text('Gain'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<int>(
                        value: 2,
                        groupValue: _selectedOption1,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption1 = value!;
                          });
                        },
                      ),
                      Text('Maintain'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<int>(
                        value: 3,
                        groupValue: _selectedOption1,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption1 = value!;
                          });
                        },
                      ),
                      Text('Lose'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                'Activity',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio<int>(
                        value: 1,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      Text('Little'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<int>(
                        value: 2,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      Text('Below average'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<int>(
                        value: 3,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      Text('Average'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<int>(
                        value: 4,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      Text('High'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<int>(
                        value: 5,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      Text('Very active'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build image cards with titles
  Widget _buildImageCard(String imageUrl, String title, VoidCallback onPress) {
    bool isSelected = selectedCategory == title; // Check if this category is selected
    return GestureDetector(
      onTap: onPress,
      child: Card(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Padding( // Add padding to position the icon nicely
                padding: EdgeInsets.only(left: 150.0, top: 150.0),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF2abca4),
                  size: 35,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Function to update the selected category and ensure single selection
  void _updateSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }
}
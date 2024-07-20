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
              const Text(
                'Let us know your diet.',
                style: TextStyle(
                  color: Color(0xFF2abca4),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                shrinkWrap: true,
                children: <Widget>[
                  _buildImageCard('https://i.ibb.co/pZcwHZ0/file-1.png', 'Pregnant Women', () {
                    _updateSelectedCategory('Pregnant Women');
                  }),
                  _buildImageCard('https://i.ibb.co/dDD37dp/female-olympic-athlete-running-marathon-person-celebrate-summer-games-athletics-medal-sportive-peopl.png', 'Athletes', () {
                    _updateSelectedCategory('Athletes');
                  }),
                  _buildImageCard('https://i.ibb.co/hy22JF5/doctor-and-people-check-blood-sugar-level-with-glucose-meter-diabetes-type-two-check-up-diet-for-non.png', 'Diabetic Patients', () {
                    _updateSelectedCategory('Diabetic Patients');
                  }),
                  _buildImageCard('https://i.ibb.co/27qPCKW/kawaii-heart-versus-high-cholesterol-levels-vector-removebg-preview.png', 'Cholesterol Patients', () {
                    _updateSelectedCategory('Cholesterol Patients');
                  }),
                ],
              ),
              const SizedBox(height: 15.0),
              const SizedBox(height: 10.0),
              const SizedBox(height: 15.0),
              const SizedBox(height: 10.0),
              const SizedBox(height: 15.0),
              const Text(
                'Weight',
                style: TextStyle(
                  color: Color(0xFF2abca4),
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
                      const Text('Gain'),
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
                      const Text('Maintain'),
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
                      const Text('Lose'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Activity',
                style: TextStyle(
                  color: Color(0xFF2abca4),
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
                      const Text('Little'),
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
                      const Text('Below average'),
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
                      const Text('Average'),
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
                      const Text('High'),
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
                      const Text('Very active'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the apply settings action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2abca4), // Change the button color to green
                    padding: const EdgeInsets.symmetric(
                      horizontal: 130, // Increase the horizontal padding
                      vertical: 20, // Increase the vertical padding
                    ),// Change the button color to blue
                  ),
                  child: const Text('Apply Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                ),
              ),
              const SizedBox(height: 20.0), // Add some space at the bottom
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
        color: isSelected ? Color(0xFF2abca4) : Colors.white, // Change card color when selected
        child: Column(
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black, // Change text color when selected
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
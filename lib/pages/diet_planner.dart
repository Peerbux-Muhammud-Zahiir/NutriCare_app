import 'package:flutter/material.dart';
import 'package:nutricare/randomutilities/equations.dart';

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

  void _onApplySettingsPressed() {
    SelectedOptions options = SelectedOptions(_selectedOption1, _selectedOption2);
    calculateDietWithContext(options, context);
  }

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
              // Text(
              //   'I want to eat',
              //   style: TextStyle(
              //     color: Colors.green[800],
              //     fontSize: 19.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(height: 10.0),
              // TextField(
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //       borderSide: BorderSide.none,
              //     ),
              //     filled: true,
              //     fillColor: Colors.green[200],
              //     hintText: '1500 Calories',
              //     hintStyle: TextStyle(
              //       color: Colors.green[500],
              //       fontWeight: FontWeight.bold,
              //       fontSize: 15.0,
              //     ),
              //     suffixText: 'Not sure?',
              //     suffixStyle: const TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.w600,
              //       fontSize: 15.0,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15.0),
              // Text(
              //   'in how many meals?',
              //   style: TextStyle(
              //     color: Colors.green[800],
              //     fontSize: 19.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(height: 10.0),
              // DropdownButton<String>(
              //   value: selected,
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       selected = newValue!;
              //     });
              //   },
              //   items: meals.map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // ),
              const SizedBox(height: 15.0),
              Text(
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
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _selectedOption1,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption1 = value!;
                          });
                        },
                      ),
                      const Text('Gain Weight'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: _selectedOption1,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption1 = value!;
                          });
                        },
                      ),
                      const Text('Maintain Weight'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 3,
                        groupValue: _selectedOption1,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption1 = value!;
                          });
                        },
                      ),
                      const Text('Lose Weight'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
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
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      const Text('Sedentary'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      const Text('Lightly active'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 3,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      const Text('Moderately active'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 4,
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
                  Row(
                    children: [
                      Radio(
                        value: 5,
                        groupValue: _selectedOption2,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption2 = value!;
                          });
                        },
                      ),
                      const Text('Extra active'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _onApplySettingsPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2abca4), // Set the button color to green
                  ),
                  child: const Text('Apply Settings',
                    style: TextStyle(
                      color: Colors.white,
                    ),

                  ),
                ),
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
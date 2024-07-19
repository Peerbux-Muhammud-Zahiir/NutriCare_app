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

  bool isAnythingSelected = false;
  bool isVegSelected = false;
  bool isMedSelected = false;
  bool isPaleoSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Let us know your diet.',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.0),
                Container(
                  height: 400.0,
                  child: GridView(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    children: <Widget>[
                      FoodTypeCard(
                        image: 'https://static.vecteezy.com/system/resources/thumbnails/000/585/705/small/5-08.jpg',
                        title: 'Pregnant Women',
                        isSelected: isAnythingSelected,
                        onPress: () {
                          setState(() {
                            isAnythingSelected = !isAnythingSelected;
                          });
                        },
                        imageSize: 5000000.0,
                      ),
                      FoodTypeCard(
                        image: 'https://thumbs.dreamstime.com/b/female-olympic-athlete-running-marathon-person-celebrate-summer-games-athletics-medal-sportive-people-celebrating-track-field-174309058.jpg',
                        title: 'athletes',
                        isSelected: isVegSelected,
                        onPress: () {
                          setState(() {
                            isVegSelected = !isVegSelected;
                          });
                        },
                        imageSize: 5000000.0,
                      ),
                      FoodTypeCard(
                        image: 'https://static.vecteezy.com/system/resources/previews/001/879/424/non_2x/doctor-and-people-check-blood-sugar-level-with-glucose-meter-diabetes-type-two-check-up-diet-for-non-communicable-diseases-checking-insulin-illustration-for-business-card-banner-brochure-flyer-free-vector.jpg',
                        title: 'Diabetic patients',
                        isSelected: isMedSelected,
                        onPress: () {
                          setState(() {
                            isMedSelected = !isMedSelected;
                          });
                        },
                        imageSize: 5000000.0,
                      ),
                      FoodTypeCard(
                        image: 'https://static.vecteezy.com/system/resources/thumbnails/002/226/928/small/kawaii-heart-versus-high-cholesterol-levels-vector.jpg',
                        title: 'Cholesterol patients',
                        isSelected: isPaleoSelected,
                        onPress: () {
                          setState(() {isPaleoSelected = !isPaleoSelected;
                          });
                        },
                        imageSize: 5000000.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  'I want to eat',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.green[200],
                    hintText: '1500 Calories',
                    hintStyle: TextStyle(
                      color: Colors.green[500],
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                    suffixText: 'Not sure?',
                    suffixStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  'in how many meals?',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButton<String>(
                  value: selected,
                  onChanged: (String? newValue) {
                    setState(() {
                      selected = newValue!;
                    });
                  },
                  items: meals.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
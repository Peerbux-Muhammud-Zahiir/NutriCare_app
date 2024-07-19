import 'package:flutter/material.dart';
import 'package:nutricare/models/nutritionalinfo.dart';
import 'package:nutricare/nutritionix/nutritionixapi.dart';

typedef OnItemSelected = void Function(String name, double calories, double cholesterol, String imageUrl);

class NutritionixSearch extends StatefulWidget {
  final OnItemSelected onItemSelected;

  const NutritionixSearch({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  _NutritionixSearchState createState() => _NutritionixSearchState();
}

class _NutritionixSearchState extends State<NutritionixSearch> {
  final NutritionixApi _api = NutritionixApi();
  List<dynamic> _foods = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchAutocompleteSuggestions() async {
    final suggestions = await _api.fetchAutocompleteData(_searchController.text);
    setState(() {
      _foods = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search...",
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _fetchAutocompleteSuggestions,
            ),
          ),
          onSubmitted: (value) => _fetchAutocompleteSuggestions(),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1.2,
        ),
        itemCount: _foods.length,
        itemBuilder: (context, index) {
          final food = _foods[index];
          return GestureDetector(
            onTap: () async {
              final details = await _api.getNutritionalInfo(food['food_name']);
              List<String> nutritionalInfoToDisplay = [];
              if (details.calories > 0) nutritionalInfoToDisplay.add('Calories: ${details.calories}');
              if (details.protein > 0) nutritionalInfoToDisplay.add('Protein: ${details.protein}g');
              if (details.totalFat > 0) nutritionalInfoToDisplay.add('Fat: ${details.totalFat}g');
              if (details.cholesterol > 0) nutritionalInfoToDisplay.add('Cholesterol: ${details.cholesterol}mg');

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(food['food_name']),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: nutritionalInfoToDisplay.map((info) => Text(info)).toList(),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Add'),
                      onPressed: () {
                        widget.onItemSelected(food['food_name'], details.calories, details.cholesterol, food['photo']['thumb']);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: Image.network(food['photo']['thumb'], fit: BoxFit.cover),
                ),
                Text(food['food_name'], style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
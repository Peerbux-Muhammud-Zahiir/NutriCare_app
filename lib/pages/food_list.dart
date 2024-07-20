import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food List'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('foods').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final foods = snapshot.data!.docs;

          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              var food = foods[index];
              return ListTile(
                leading: Image.network(
                  food['imageUrl'],
                  height: 50,
                  width: 50,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                title: Text(food['name']),
                subtitle: Text('Calories: ${food['calories']}'),
              );
            },
          );
        },
      ),
    );
  }
}
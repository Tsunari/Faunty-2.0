import 'package:faunty/pages/Catering/catering.dart';
import 'package:flutter/material.dart';
 
// Widget für anstehendes Catering
Widget nextCateringDutyWidget({required String username}) {
  final now = DateTime.now();
  for (int i = 0; i < 7; i++) {
    final dayIdx = (now.weekday - 1 + i) % 7;
    for (int mealIdx = 0; mealIdx < meals.length; mealIdx++) {
      final users = weekPlan[dayIdx][mealIdx];
      if (users.contains(username)) {
        return Card(
          // color: Colors.green.shade50,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // TODO 
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.event, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      'Next Catering: ${i == 0 ? 'Today' : 'in $i day${i > 1 ? 's' : ''}'} for ${meals[mealIdx]}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }
  return Card(
    color: Colors.green.shade50,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.event, color: Colors.green),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Kein anstehendes Catering gefunden.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}
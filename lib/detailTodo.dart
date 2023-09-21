import 'package:flutter/material.dart';

class DetailTodo extends StatelessWidget {
  final Map<String, dynamic> item;

  DetailTodo({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${item['title']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Body: ${item['body']}',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 8),
            Text('Days: ${item['days']}'),
          ],
        ),
      ),
    );
  }
}

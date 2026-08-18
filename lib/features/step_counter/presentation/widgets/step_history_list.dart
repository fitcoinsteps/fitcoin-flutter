import 'package:flutter/material.dart';

class StepHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> history; // list of {date, steps}
  const StepHistoryList({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return ListTile(
          title: Text(item['date']),
          trailing: Text('${item['steps']} steps'),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

void handlenotcontinue(BuildContext context, Function delete) {
  showDialog(
      context: (context),
      builder: (context) {
        return AlertDialog(
          title: const Text("Cancel"),
          content:
              (const Text("Are you sure you wan to cancel\nyour application?")),
          actions: [
            TextButton(
                onPressed: () {
                  delete();
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No")),
          ],
        );
      });
}

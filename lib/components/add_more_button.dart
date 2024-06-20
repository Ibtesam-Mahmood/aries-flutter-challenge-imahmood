import 'package:flutter/material.dart';

/// Button to add more options contracts
class AddOptionButton extends StatelessWidget {
  final Function() onPressed;

  const AddOptionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white.withOpacity(0.7),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Add Option',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.text, required this.onTap});

  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12.0)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            // icon chat
            const Icon(
              Icons.person_sharp,
              size: 30,
            ),

            // username
            Text(text)
          ],
        ),
      ),
    );
  }
}

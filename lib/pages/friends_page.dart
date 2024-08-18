import 'package:flutter/material.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Friends"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.group_add,
              size: 28,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.qr_code_scanner_outlined,
                size: 28,
              )),
        ],
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
    );
  }
}

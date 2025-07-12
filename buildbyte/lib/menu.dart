
import 'package:buildbyte/main.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  final ByteGame game;
  const PauseMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      MenuItem(label: 'Start Game', color: Colors.white, onTap: game.startGame),
      MenuItem(label: 'Quit', color: Colors.white, onTap: game.stopGame),
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Build Byte',
            style: TextStyle(
              color: Color(0xFFFF0000),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          for (final item in items)
            GestureDetector(
              onTap: item.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  item.label,
                  style: TextStyle(color: item.color, fontSize: 24),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String label;
  final Color color;
  final VoidCallback onTap;

  MenuItem({required this.label, required this.color, required this.onTap});
}

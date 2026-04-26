import 'package:flutter/material.dart';
import 'package:f_app/styled_text.dart';
import 'dart:math';

var random = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {
  var currentDiceRoll = 2;

  void choosePicture() {
    setState(() {
      currentDiceRoll = random.nextInt(6) + 1;
    });
  }

  @override
  Widget build(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: StyledText("Az első szerelem app a mösszömnek ❤️")),
        const SizedBox(height: 20),
        Center(
          child: Image.asset(
            'assets/images/dice-$currentDiceRoll.jpeg',
            width: 250,
          ),
        ),
        const SizedBox(height: 100),
        Center(
          child: TextButton(
            onPressed: choosePicture,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(top: 20),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 28),
            ),
            child: Text('Nyomd meg a gombot'),
          ),
        ),
      ],
    );
  }
}

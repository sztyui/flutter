import 'package:flutter/material.dart';

// import 'package:f_app/styled_text.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  final List<Color> colors;

  const GradientContainer({super.key, required this.colors});

  GradientContainer.purple({super.key}) : 
    colors = [Colors.deepPurple, Colors.indigo];
  
  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        child: Image.asset('assets/images/dice-2.jpeg'),
      ),
    );
  }
}
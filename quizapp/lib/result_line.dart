import 'package:flutter/material.dart';

class ResultData {
  const ResultData({required this.questionIndex, required this.question,
  required this.correctAnswer, required this.userAnswer});
  
  final int questionIndex;
  final String question;
  final String correctAnswer;
  final String userAnswer;

  bool get isCorrectAnswer {
    return userAnswer == correctAnswer;
  }


  String get index {
    return (questionIndex + 1).toString();
  }
}

class ResultLine extends StatelessWidget {
  const ResultLine({
    super.key,
    required this.input
  });

  final ResultData input;
    final MaterialColor successColor = Colors.green;
  final MaterialColor failedColor  = Colors.red;

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = input.isCorrectAnswer;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 80, 0, 209),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? successColor : failedColor,
          width: 0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Number with color indicator
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCorrect ? successColor : failedColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                input.index,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Middle - Question and answers
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  input.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Correct answer row - text at top left
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Correct: ',
                      style: TextStyle(color: successColor, fontSize: 12),
                    ),
                    Expanded(
                      child: Text(
                        input.correctAnswer,
                        softWrap: true,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Your answer row - text at top left
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your: ',
                      style: TextStyle(
                        color: isCorrect ? successColor : failedColor,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        input.userAnswer,
                        softWrap: true,
                        style: TextStyle(
                          color: isCorrect ? successColor : failedColor,
                          fontSize: 12,
                          fontWeight: isCorrect ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Right side - Success/Failure indicator
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              isCorrect ? '✓' : '✗',
              style: TextStyle(
                color: isCorrect ? successColor : failedColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
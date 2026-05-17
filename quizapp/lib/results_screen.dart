import 'package:flutter/material.dart';
import 'package:quizapp/data/questions.dart';
import 'package:quizapp/result_line.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.callBack,
    required this.chosenAnswers,
  });

  final void Function() callBack;
  final List<String> chosenAnswers;

  List<ResultLine> get summaryData {
    final List<ResultData> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add(
        ResultData(
          correctAnswer: questions[i].answers[0],
          question: questions[i].text,
          questionIndex: i,
          userAnswer: chosenAnswers[i],
        ),
      );
    }

    return [...summary.map((e) => ResultLine(input: e))];
  }

  String get successfulAnswers {
    return chosenAnswers
        .asMap()
        .entries
        .where((entry) => questions[entry.key].answers[0] == entry.value)
        .length
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'You answered $successfulAnswers out of ${questions.length.toString()} questions correctly!',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 201, 153, 251),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Visibility(
              visible: successfulAnswers == questions.length.toString(),
              child: Text(
                textAlign: TextAlign.center,
                'Most már akár le is szophatod magad... 🍆',
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 201, 153, 251),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: summaryData),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.replay),
                TextButton(
                  onPressed: callBack,
                  child: Text(
                    'Restart Quiz!',
                    style: TextStyle(color: Color.fromARGB(255, 201, 153, 251)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

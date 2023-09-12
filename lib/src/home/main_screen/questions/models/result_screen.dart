import 'package:flutter/material.dart';

import 'package:duolingo/src/home/main_screen/questions/models/questions.dart';
import 'package:duolingo/src/home/main_screen/questions/question.dart';
import 'package:duolingo/src/home/main_screen/questions/models/next_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    key,
    this.score,
    this.len
  });

  final int score;
  final int len;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 1000),
          const Text(
            'Your Score: ',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w500,
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  value: score / len,
                  color: Colors.green,
                  backgroundColor: Colors.white,
                ),
              ),
              Column(
                children: [
                  Text(
                    score.toString(),
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(score / len * 100).round()}%',
                    style: const TextStyle(fontSize: 25),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
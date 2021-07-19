import 'package:flutter/material.dart';
import 'package:quizzler/question.dart';
import 'package:quizzler/quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain brain = new QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  /*
  List <String> questionList = [
    'You can lead a cow down stairs but not up stairs.',
    'Approximately one quarter of human bones are in the feet.',
    'A slug\'s blood is green.',
  ];
  List <bool> answers = [
    false,
    true,
    true
  ];*/

  // List <Question> questionObj = [
  //   Question('You can lead a cow down stairs but not up stairs.',false),
  //   Question('Approximately one quarter of human bones are in the feet.', true),
  //   Question('A slug\'s blood is green.', true)
  //
  // ];
  List <Icon> scoreKeeper = [];
  int totalScore = 0;

  void answerChecker(bool chosenAns){
    bool correctAns = brain.getAnswer();
    if (correctAns == chosenAns){
      print('User got it right');
      scoreKeeper.add(
          Icon(
            Icons.check,
            color: Colors.green,
          )
      );
      totalScore += 1;
    }else{
      print('User got it wrong');
      scoreKeeper.add(Icon(
        Icons.close,
        color: Colors.red,
      ),);
    }
    brain.nextQuestion();
  }

  void createAlert(BuildContext context){
    Alert(
      context: context,
      type: AlertType.error,
      title: "Quiz Ended",
      desc: "Your Score: $totalScore",
      buttons: [
        DialogButton(
          child: Text(
            "Try Again?",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void resetGame(){
    totalScore = 0;
    scoreKeeper.clear();
    brain.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5.0, left: 5.0),
          child: Text(
            "Score: $totalScore",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                brain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        // True Button
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              color: Colors.green,
              child: TextButton(
                child: Text(
                  'True',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  //The user picked true.
                  setState(() {
                    if (brain.availableQuestion() == false){
                      createAlert(context);
                      resetGame();
                    }else {
                      answerChecker(true);
                    }});
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              color: Colors.red,
              child: TextButton(
                child: Text(
                  'False',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  //The user picked false.
                  setState(() {
                    if (brain.availableQuestion() == false){
                      createAlert(context);
                      resetGame();
                    }else {
                      answerChecker(false);
                    }
                  });
                },
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/

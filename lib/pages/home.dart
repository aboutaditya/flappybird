import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flappybird/pages/barrier.dart';
import 'package:flappybird/pages/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYAxis = 0;
  double time = 0;
  double height = 0;
  double inititalHeight = birdYAxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  int score = 0;
  int bestScore = 0;
  final Set<int> _scores = Set<int>();
  void jump() {
    setState(() {
      time = 0;
      inititalHeight = birdYAxis;
    });
  }

  void gameOver(timer) {
    timer.cancel();
    gameHasStarted = false;
    setState(() {
      birdYAxis = 0;
      time = 0;
      height = 0;
      inititalHeight = birdYAxis;
      gameHasStarted = false;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
      score = 0;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = (-4.9 * time * time) + (2.5 * time);
      setState(() {
        birdYAxis = inititalHeight - height;
      });

      setState(() {
        if (barrierXone < -1) {
          score += 1;
          barrierXone += 3;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (score > bestScore) {
          bestScore = score;
        }
      });
      setState(() {
        if (barrierXtwo < -1) {
          score += 1;

          barrierXtwo += 3;
        } else {
          barrierXtwo -= 0.05;
        }
      });
      Rect birdRect = Rect.fromLTWH(0, birdYAxis + 0.05, 80, 80);
      Rect barrierRectOne = Rect.fromLTWH(
          barrierXone * MediaQuery.of(context).size.width,
          88,
          100,
          MediaQuery.of(context).size.height / 2);
      Rect barrierRectTwo = Rect.fromLTWH(
          barrierXtwo * MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 2 - 1 + 0.05,
          100,
          MediaQuery.of(context).size.height / 2);

      if (birdRect.overlaps(barrierRectOne) ||
          birdRect.overlaps(barrierRectTwo) ||
          birdYAxis > 1 ||
          birdYAxis < -1.5) {
        gameOver(timer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 0),
                      alignment: Alignment(0, birdYAxis),
                      color: Colors.blue,
                      child: MyBird(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: gameHasStarted
                          ? Text(" ")
                          : Text(
                              'T A P  T O  P L A Y ',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 150.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 150.0,
                      ),
                    )
                  ],
                )),
            Container(
              color: Colors.green,
              height: 15,
            ),
            Expanded(
                child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SCORE',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        score.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BEST SCORE',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        bestScore.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      )
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

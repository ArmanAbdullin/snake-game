import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_game/blank_pixel.dart';
import 'package:snake_game/food_pixel.dart';
import 'package:snake_game/snake_pixel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //grid dimension
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  //snake position
  List<int> snakePos = [0, 1, 2];

  var currentDirection = snake_direction.RIGHT;
  //food position
  int foodPos = 45;

  //start the game
  void startGame() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
      });
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_direction.DOWN:
        {
          //add a head
          snakePos.add(snakePos.last + rowSize);
          //remove the tail
          snakePos.remove(0);
        }
        break;

      case snake_direction.UP:
        {
          //add a head
          snakePos.add(snakePos.last - rowSize);
          //remove the tail
          snakePos.remove(0);
        }
        break;

      case snake_direction.RIGHT:
        {
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            //remove the tail
            snakePos.add(snakePos.last - 1);
          }
          snakePos.removeAt(0);
        }
        break;

      case snake_direction.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            //remove the tail
            snakePos.add(snakePos.last - 1);
          }
          snakePos.removeAt(0);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //high scores
          Expanded(
            child: Container(),
          ),

          //game grid
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    currentDirection != snake_direction.UP) {
                  currentDirection = snake_direction.DOWN;
                } else if (details.delta.dy < 0 &&
                    currentDirection != snake_direction.DOWN) {
                  currentDirection = snake_direction.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    currentDirection != snake_direction.LEFT) {
                  currentDirection = snake_direction.RIGHT;
                } else if (details.delta.dx < 0 &&
                    currentDirection != snake_direction.RIGHT) {
                  currentDirection = snake_direction.LEFT;
                }
              },
              child: GridView.builder(
                  itemCount: totalNumberOfSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return const SnakePixel();
                    } else if (foodPos == index) {
                      return const FoodPixel();
                    } else {
                      return const BlankPixel();
                    }
                  }),
            ),
          ),

          //play button
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  child: Text('PLAY'),
                  color: Colors.pink,
                  onPressed: startGame,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

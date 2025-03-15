import 'package:flutter/material.dart';

void main() {
  runApp(CardMatchingGame());
}

class CardMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class CardModel {
  final String image;
  bool isFaceUp;
  bool isMatched;

  CardModel({required this.image, this.isFaceUp = false, this.isMatched = false});
}

List<CardModel> generateCards() {
  List<String> images = [
    'assets/clubs_2.png', 'assets/clubs_3.png', 'assets/clubs_4.png', 'assets/clubs_5.png', 'assets/clubs_6.png', 'assets/clubs_7.png', 'assets/clubs_8.png' 'assets/clubs_9.png', 'assets/clubs_10.png', 'assets/clubs_J.png', 'assets/clubs_Q.png', 'assets/clubs_K.png', 'assets/clubs_A.png', 'assets/diamonds_2.png', 'assets/diamonds_3.png', 'assets/diamonds_4.png', 'assets/diamonds_5.png', 'assets/diamonds_6.png', 'assets/diamonds_7.png', 'assets/diamonds_8.png' 'assets/diamonds_9.png', 'assets/diamonds_10.png', 'assets/diamonds_J.png', 'assets/diamonds_Q.png', 'assets/diamonds_K.png', 'assets/diamonds_A.png', 'assets/hearts_2.png', 'assets/hearts_3.png', 'assets/hearts_4.png', 'assets/hearts_5.png', 'assets/hearts_6.png', 'assets/hearts_7.png', 'assets/hearts_8.png' 'assets/hearts_9.png', 'assets/hearts_10.png', 'assets/hearts_J.png', 'assets/hearts_Q.png', 'assets/hearts_K.png', 'assets/hearts_A.png', 'assets/spades_2.png', 'assets/spades_3.png', 'assets/spades_4.png', 'assets/spades_5.png', 'assets/spades_6.png', 'assets/spades_7.png', 'assets/spades_8.png' 'assets/spades_9.png', 'assets/spades_10.png', 'assets/spades_J.png', 'assets/spades_Q.png', 'assets/spades_K.png', 'assets/spades_A.png',
];

  List<CardModel> cards = images.expand((image) => [CardModel(image: image), CardModel(image: image)]).toList();
  cards.shuffle();

  return cards;
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<CardModel> cards;
  int score = 0;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void onCardTap(int index) {
    setState(() {
      if (!cards[index].isFaceUp && !cards[index].isMatched) {
        cards[index].isFaceUp = true;
      }
    });

    checkMatch();
  }

  void checkMatch() {
    List<int> flippedIndexes = [];

    for (int i = 0; i < cards.length; i++) {
      if (cards[i].isFaceUp && !cards[i].isMatched) {
        flippedIndexes.add(i);
      }
    }

    if (flippedIndexes.length == 2) {
      if (cards[flippedIndexes[0]].image == cards[flippedIndexes[1]].image) {
        setState(() {
          cards[flippedIndexes[0]].isMatched = true;
          cards[flippedIndexes[1]].isMatched = true;
          score += 10;
        });
      } else {
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            cards[flippedIndexes[0]].isFaceUp = false;
            cards[flippedIndexes[1]].isFaceUp = false;
          });
        });
      }
    }
  }

  void resetGame() {
    setState(() {
      cards = generateCards();
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: \$score', style: TextStyle(fontSize: 18)),
                Text('Time: 00:00', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return CardWidget(
                    card: cards[index],
                    onTap: () => onCardTap(index),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: resetGame,
            child: Text('Reset Game'),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const CardWidget({Key? key, required this.card, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isMatched ? null : onTap,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationYTransition(turns: animation, child: child);
        },
        child: Container(
          key: ValueKey<bool>(card.isFaceUp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
            image: DecorationImage(
              image: AssetImage(card.isFaceUp ? card.image : 'assets/card_back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class RotationYTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> turns;

  const RotationYTransition({required this.child, required this.turns});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: turns,
      child: child,
      builder: (context, child) {
        final angle = turns.value * 3.1415927;
        return Transform(
          transform: Matrix4.rotationY(angle),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
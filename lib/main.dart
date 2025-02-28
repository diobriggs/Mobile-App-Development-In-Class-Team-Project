import 'dart:async'; // Importing Timer
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color petColor = Colors.yellow; // Initial color for "Neutral" mood
  String petMood = "Neutral"; // Initial mood
  String petMoodEmoji = "😐"; // Initial emoji for neutral mood
  bool isNameSet = false; // Track if the pet's name is set
  bool gameOver = false; // Track if the game is over
  TextEditingController _nameController = TextEditingController();
  Timer? _hungerTimer; // Timer for increasing hunger automatically
  Timer? _winTimer; // Timer for tracking win condition

  @override
  void initState() {
    super.initState();
    // Start the hunger timer when the app starts
    _startHungerTimer();
  }

  @override
  void dispose() {
    // Cancel the timers when the widget is disposed
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }

  // Function to start the hunger timer
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        _increaseHungerOverTime();
      });
    });
  }

  // Function to increase hunger automatically over time
  void _increaseHungerOverTime() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 70) {
      happinessLevel = (happinessLevel - 10).clamp(0, 100);
    }
    _updatePetAppearance();
  }

  // Function to start win condition timer
  void _startWinConditionTimer() {
    _winTimer = Timer(Duration(minutes: 3), () {
      setState(() {
        _showWinDialog();
      });
    });
  }

  // Function to update the pet's color and mood based on happiness level
  void _updatePetAppearance() {
    if (happinessLevel > 80) {
      petColor = Colors.green; // Happy
      petMood = "Happy";
      petMoodEmoji = "😄";
      _checkWinCondition();
    } else if (happinessLevel >= 30 && happinessLevel <= 80) {
      petColor = Colors.yellow; // Neutral
      petMood = "Neutral";
      petMoodEmoji = "😐";
      _winTimer?.cancel(); // Stop win timer if happiness drops below 80
    } else {
      petColor = Colors.red; // Unhappy
      petMood = "Unhappy";
      petMoodEmoji = "😢";
      _checkLossCondition();
    }
  }

  // Function to check win condition
  void _checkWinCondition() {
    if (_winTimer == null || !_winTimer!.isActive) {
      _startWinConditionTimer(); // Start win timer if happiness > 80
    }
  }

  // Function to check loss condition
  void _checkLossCondition() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _showGameOverDialog();
    }
  }

  // Function to display win dialog
  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You kept your pet happy for 3 minutes!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function to display game over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over!'),
        content: Text('Your pet is too hungry and unhappy.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function to reset the game after win/loss
  void _resetGame() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      gameOver = false;
      _winTimer?.cancel();
    });
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetAppearance(); // Update appearance based on new happiness level
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updatePetAppearance(); // Update appearance based on new happiness level
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Function to set the pet's name
  void _setPetName() {
    setState(() {
      petName =
          _nameController.text.isNotEmpty ? _nameController.text : "Your Pet";
      isNameSet = true; // Name is set, now show the main screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: isNameSet
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Name: $petName',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 16.0),
                  // Display pet's happiness with color change and mood indicator
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: petColor, // Color of the pet based on happiness
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Display the pet's mood and emoji
                  Text(
                    '$petMood $petMoodEmoji',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Happiness Level: $happinessLevel',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Hunger Level: $hungerLevel',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _playWithPet,
                    child: Text('Play with Your Pet'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _feedPet,
                    child: Text('Feed Your Pet'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Set a name for your pet:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter pet name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _setPetName,
                    child: Text('Confirm Name'),
                  ),
                ],
              ),
      ),
    );
  }
}

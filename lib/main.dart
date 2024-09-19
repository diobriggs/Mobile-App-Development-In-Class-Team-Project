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

  // Function to update the pet's color and mood based on happiness level
  void _updatePetAppearance() {
    if (happinessLevel > 70) {
      petColor = Colors.green; // Happy
      petMood = "Happy";
      petMoodEmoji = "😄";
    } else if (happinessLevel >= 30 && happinessLevel <= 70) {
      petColor = Colors.yellow; // Neutral
      petMood = "Neutral";
      petMoodEmoji = "😐";
    } else {
      petColor = Colors.red; // Unhappy
      petMood = "Unhappy";
      petMoodEmoji = "😢";
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaceNotesScreen(),
    );
  }
}

class PaceNotesScreen extends StatefulWidget {
  @override
  _PaceNotesScreenState createState() => _PaceNotesScreenState();
}

class _PaceNotesScreenState extends State<PaceNotesScreen> {
  List<String> paceNotes = [];
  int currentNoteIndex = 0;
  String feedbackMessage = '';

  TextEditingController paceNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pace Notes App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: paceNoteController,
              onChanged: (value) {
                // Allow the user to add pace notes
                // You can add validation or additional logic here
              },
              decoration: InputDecoration(labelText: 'Enter Pace Note'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add pace note to the list
                setState(() {
                  paceNotes.add(paceNoteController.text);
                  paceNoteController.clear();
                  feedbackMessage = 'Pace note added!';
                });

                // Reset feedback message after a short delay
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    feedbackMessage = '';
                  });
                });
              },
              child: Text('Add Pace Note'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Start the race
                setState(() {
                  currentNoteIndex = 0;
                });

                // You can add logic here to customize the behavior when the race starts
                if (paceNotes.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaceNoteFullScreenScreen(
                        paceNotes: paceNotes,
                        onNoteIndexChanged: (index) {
                          setState(() {
                            currentNoteIndex = index;
                          });
                        },
                        onResetPressed: () {
                          setState(() {
                            paceNotes.clear();
                          });
                        },
                      ),
                    ),
                  );
                }
              },
              child: Text('Start Race'),
            ),
            SizedBox(height: 16),
            if (feedbackMessage.isNotEmpty)
              Text(
                feedbackMessage,
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}

class PaceNoteFullScreenScreen extends StatefulWidget {
  final List<String> paceNotes;
  final Function(int) onNoteIndexChanged;
  final VoidCallback onResetPressed;

  PaceNoteFullScreenScreen({
    required this.paceNotes,
    required this.onNoteIndexChanged,
    required this.onResetPressed,
  });

  @override
  _PaceNoteFullScreenScreenState createState() =>
      _PaceNoteFullScreenScreenState();
}

class _PaceNoteFullScreenScreenState extends State<PaceNoteFullScreenScreen> {
  int currentNoteIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pace Note Full Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Pace Note:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '${currentNoteIndex + 1}. ${widget.paceNotes[currentNoteIndex]}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Adjust the font size here
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Show the previous pace note
                    if (currentNoteIndex > 0) {
                      setState(() {
                        currentNoteIndex--;
                      });
                    }
                  },
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Show the next pace note
                    if (currentNoteIndex < widget.paceNotes.length - 1) {
                      setState(() {
                        currentNoteIndex++;
                      });
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Reset the pace note list
                widget.onResetPressed();
                Navigator.pop(context); // Close the full-screen view
              },
              child: Text('Reset Pace Notes'),
            ),
          ],
        ),
      ),
    );
  }
}

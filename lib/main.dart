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
  bool isRaceStarted = false;

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
                  paceNotes.add('Pace Note: ${paceNotes.length + 1}');
                });
              },
              child: Text('Add Pace Note'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Start the race and display pace notes
                setState(() {
                  isRaceStarted = true;
                });
              },
              child: Text('Start Race'),
            ),
            if (isRaceStarted && paceNotes.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: 16),
                  Text('Current Pace Note:'),
                  Text(paceNotes[currentNoteIndex]),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Show the previous pace note
                          setState(() {
                            if (currentNoteIndex > 0) {
                              currentNoteIndex--;
                            }
                          });
                        },
                        child: Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Show the next pace note
                          setState(() {
                            if (currentNoteIndex < paceNotes.length - 1) {
                              currentNoteIndex++;
                            }
                          });
                        },
                        child: Text('Next'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Delete the current pace note
                          setState(() {
                            paceNotes.removeAt(currentNoteIndex);
                            if (currentNoteIndex >= paceNotes.length) {
                              currentNoteIndex = paceNotes.length - 1;
                            }
                          });
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
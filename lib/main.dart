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

class RallyTrack {
  final String name;
  final List<String> paceNotes;

  RallyTrack({required this.name, required this.paceNotes});
}

class PaceNotesScreen extends StatefulWidget {
  @override
  _PaceNotesScreenState createState() => _PaceNotesScreenState();
}

class _PaceNotesScreenState extends State<PaceNotesScreen> {
  List<RallyTrack> rallyTracks = [];
  int currentNoteIndex = 0;
  String feedbackMessage = '';

  TextEditingController rallyNameController = TextEditingController();
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
              controller: rallyNameController,
              onChanged: (value) {
                // Allow the user to enter the rally/track name
              },
              decoration: InputDecoration(labelText: 'Enter Rally/Track Name'),
            ),
            TextField(
              controller: paceNoteController,
              onChanged: (value) {
                // Allow the user to add pace notes
              },
              decoration: InputDecoration(labelText: 'Enter Pace Note'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save pace note with rally/track name
                String rallyName = rallyNameController.text.trim();
                if (rallyName.isNotEmpty && paceNoteController.text.isNotEmpty) {
                  RallyTrack rallyTrack = rallyTracks.firstWhere(
                    (track) => track.name == rallyName,
                    orElse: () {
                      RallyTrack newTrack = RallyTrack(name: rallyName, paceNotes: []);
                      rallyTracks.add(newTrack);
                      return newTrack;
                    },
                  );
                  setState(() {
                    rallyTrack.paceNotes.add(paceNoteController.text);
                    paceNoteController.clear();
                    feedbackMessage = 'Pace note added!';
                  });
                } else {
                  setState(() {
                    feedbackMessage = 'Enter both rally/track name and pace note!';
                  });
                }

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
                if (rallyTracks.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select Rally/Track'),
                        content: Column(
                          children: rallyTracks.map((track) {
                            return ListTile(
                              title: Text(track.name),
                              onTap: () {
                                Navigator.pop(context);
                                navigateToFullScreen(track);
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                } else {
                  setState(() {
                    feedbackMessage = 'Add pace notes before starting the race!';
                  });

                  // Reset feedback message after a short delay
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      feedbackMessage = '';
                    });
                  });
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

  void navigateToFullScreen(RallyTrack rallyTrack) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaceNoteFullScreenScreen(
          rallyTrack: rallyTrack,
          onNoteIndexChanged: (index) {
            setState(() {
              currentNoteIndex = index;
            });
          },
          onResetPressed: () {
            setState(() {
              rallyTrack.paceNotes.clear();
            });
          },
        ),
      ),
    );
  }
}

class PaceNoteFullScreenScreen extends StatefulWidget {
  final RallyTrack rallyTrack;
  final Function(int) onNoteIndexChanged;
  final VoidCallback onResetPressed;

  PaceNoteFullScreenScreen({
    required this.rallyTrack,
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
              'Rally/Track: ${widget.rallyTrack.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Current Pace Note:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '${currentNoteIndex + 1}. ${widget.rallyTrack.paceNotes[currentNoteIndex]}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    if (currentNoteIndex < widget.rallyTrack.paceNotes.length - 1) {
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
                // Reset the pace note list for the specific rally/track
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

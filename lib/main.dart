import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter, TextInputFormatter;
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'yanci',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(254, 246, 230, 1.0),
          surface: Color.fromRGBO(254, 246, 230, 1.0), // set background color
          ),
          scaffoldBackgroundColor: Color.fromRGBO(254, 246, 230, 1.0), // also set here for Scaffold
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Image.asset(
            'images/yanci.png',
            width: 240, // set desired width
            height: 240, // set desired height
            ),
            SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameSelectionPage()),
              );
           },
              child: Text('Neues Spiel'),
          ),
        ],
      ),
      ),
    );
    }

    

    
  }

class GameSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Spielauswahl'),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GamePage1()),
                    );
                },
                  icon: Icon(Icons.group),
                  label: Text('4 Spieler Teams'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage2()),
                    );
                  },
                  icon: Icon(Icons.person),
                  label: Text('4 Spieler Solo'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage3()),
                    );
                  },
                  icon: Icon(Icons.groups),
                  label: Text('3 Spieler Solo'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage4()),
                    );
                  },
                  icon: Icon(Icons.social_distance),
                  label: Text('2 Teams'),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
class GamePage1 extends StatefulWidget {
  @override
  _GamePage1State createState() => _GamePage1State();
}
class GamePage2 extends StatefulWidget {
  @override
  _GamePage2State createState() => _GamePage2State();
}
class GamePage3 extends StatefulWidget {
  @override
  _GamePage3State createState() => _GamePage3State();
}
class GamePage4 extends StatefulWidget {
  @override
  _GamePage4State createState() => _GamePage4State();
}

class _GamePage4State extends State<GamePage4> {
  final List<TextEditingController> _playerControllers =
      List.generate(2, (_) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('2 Spieler'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: Column(
                children: [
                  for (int i = 0; i < 2; i++) ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: _playerControllers[i],
                        decoration: InputDecoration(
                          labelText: 'Team ${i + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      List<String> playerNames = List.generate(
                        2,
                        (i) => _playerControllers[i].text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextGamePage2Players(
                            playerNames: playerNames,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text('Spiel starten'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextGamePage2Players extends StatefulWidget {
  final List<String> playerNames;

  const NextGamePage2Players({
    super.key,
    required this.playerNames,
  });

  @override
  _NextGamePage2PlayersState createState() => _NextGamePage2PlayersState();
}

class _NextGamePage2PlayersState extends State<NextGamePage2Players> {
  final List<int> _scores = [0, 0];
  final List<TextEditingController> _scoreControllers =
      List.generate(2, (_) => TextEditingController());

  Map<String, bool>? _checkboxStates;
  List<int>? _lastAddedScores;
  List<String>? _editLog;

  @override
  void dispose() {
    for (final controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Icon-Erklärung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.close), SizedBox(width: 8), Text('= Acamadi')]),
            Row(children: [Icon(Icons.exposure_plus_1), SizedBox(width: 8), Text('= Elinde okey vardi')]),
            Row(children: [Icon(Icons.exposure_plus_2), SizedBox(width: 8), Text('= Elinde iki okey vardi')]),
            Row(children: [Icon(Icons.done), SizedBox(width: 8), Text('= Bitirdi')]),
            Row(children: [Icon(Icons.done_all), SizedBox(width: 8), Text('= Okeyle bitirdi')]),
            Row(children: [Icon(Icons.sync), SizedBox(width: 8), Text('= Okeyle bitirmeye dönüyordu')]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2 Spieler'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            tooltip: 'Icon-Erklärung',
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.list),
                  tooltip: 'Edit-Log anzeigen',
                  onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                    title: Text('Edit-Log'),
                    content: Container(
                      constraints: BoxConstraints(maxHeight: 240, minWidth: 200),
                      width: 300,
                      child: (_editLog ?? []).isEmpty
                        ? Text('Keine Änderungen vorhanden.')
                        : ListView(
                          shrinkWrap: true,
                          children: (_editLog ?? [])
                            .reversed
                            .map((e) => Text(e, style: TextStyle(fontSize: 12)))
                            .toList(),
                        ),
                    ),
                    actions: [
                      TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Schließen'),
                      ),
                    ],
                    ),
                  );
                  },
                ),
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 2; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                    children: [
                      Text(widget.playerNames[i], style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Punkte: ${_scores[i]}'),
                        IconButton(
                        icon: Icon(Icons.edit, size: 18),
                        tooltip: 'Punkte bearbeiten',
                        onPressed: () async {
                          int? result = await showDialog<int>(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                            title: Text('Punkte bearbeiten'),
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.numberWithOptions(signed: true),
                              decoration: InputDecoration(
                              labelText: 'Punkte (+/-)',
                              border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Abbrechen'),
                              ),
                              TextButton(
                              onPressed: () {
                                final value = int.tryParse(controller.text);
                                if (value != null) {
                                Navigator.of(context).pop(value);
                                }
                              },
                              child: Text('OK'),
                              ),
                            ],
                            );
                          },
                          );
                          if (result != null && result != 0) {
                          setState(() {
                            _scores[i] += result;
                            (_lastAddedScores ??= List.filled(2, 0));
                            (_editLog ??= []).add(
                            '${DateTime.now().toIso8601String()} - ${widget.playerNames[i]}: ${result > 0 ? '+' : ''}$result'
                            );
                          });
                          }
                        },
                        ),
                      ],
                      ),
                      Text(
                      '+${_lastAddedScores != null ? _lastAddedScores![i] : '0'}',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                    ),
                  ),
                ],
                ),
                
              SizedBox(height: 32),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (playerIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text(
                            widget.playerNames[playerIndex],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...List.generate(6, (checkboxIndex) {
                            return StatefulBuilder(
                              builder: (context, setLocalState) {
                                final checkboxKey = '${playerIndex}_$checkboxIndex';
                                _checkboxStates ??= {};
                                _checkboxStates!.putIfAbsent(checkboxKey, () => false);

                                void handleCheckboxChange(bool? value) {
                                  setState(() {
                                    // Fourth checkbox logic (index 3)
                                    if (checkboxIndex == 3 && value == true) {
                                      for (int i = 0; i < 6; i++) {
                                        if (i != 3) {
                                          _checkboxStates!['${playerIndex}_$i'] = false;
                                        }
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // Fifth checkbox logic (index 4)
                                    else if (checkboxIndex == 4 && value == true) {
                                      for (int i = 0; i < 6; i++) {
                                        if (i != 4) {
                                          _checkboxStates!['${playerIndex}_$i'] = false;
                                        }
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // If any other checkbox is checked while 4th or 5th is checked, uncheck 4th/5th
                                    else if ((checkboxIndex != 3 && checkboxIndex != 4) && value == true) {
                                      if (_checkboxStates!['${playerIndex}_3'] == true) {
                                        _checkboxStates!['${playerIndex}_3'] = false;
                                      }
                                      if (_checkboxStates!['${playerIndex}_4'] == true) {
                                        _checkboxStates!['${playerIndex}_4'] = false;
                                      }
                                      if (checkboxIndex == 1 && value == true) {
                                        _checkboxStates!['${playerIndex}_2'] = false;
                                      }
                                      if (checkboxIndex == 2 && value == true) {
                                        _checkboxStates!['${playerIndex}_1'] = false;
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // 2nd and 3rd checkbox mutual exclusion (uncheck the other if this is unchecked)
                                    else if ((checkboxIndex == 1 || checkboxIndex == 2) && value == false) {
                                      _checkboxStates![checkboxKey] = false;
                                    }
                                    // Default: just set the value
                                    else {
                                      _checkboxStates![checkboxKey] = value ?? false;
                                    }
                                  });
                                }

                                Widget checkboxRow(IconData icon) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: _checkboxStates![checkboxKey],
                                        onChanged: handleCheckboxChange,
                                      ),
                                      Icon(icon, size: 18),
                                    ],
                                  );
                                }

                                if (checkboxIndex == 0) {
                                  return checkboxRow(Icons.close);
                                } else if (checkboxIndex == 1) {
                                  return checkboxRow(Icons.exposure_plus_1);
                                } else if (checkboxIndex == 2) {
                                  return checkboxRow(Icons.exposure_plus_2);
                                } else if (checkboxIndex == 3) {
                                  return checkboxRow(Icons.done);
                                } else if (checkboxIndex == 4) {
                                  return checkboxRow(Icons.done_all);
                                } else if (checkboxIndex == 5) {
                                  return checkboxRow(Icons.sync);
                                } else {
                                  return Checkbox(
                                    value: _checkboxStates![checkboxKey],
                                    onChanged: handleCheckboxChange,
                                  );
                                }
                              },
                            );
                          }),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _scores[playerIndex] += 101;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(60, 36),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: Text('+101'),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _scoreControllers[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if (newValue.text.isEmpty) return newValue;
                              final intValue = int.tryParse(newValue.text);
                              if (intValue == null || intValue > 1616) {
                                return oldValue;
                              }
                              return newValue;
                            }),
                          ],
                          decoration: InputDecoration(
                            labelText: widget.playerNames[index],
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  List<int> inputScores = List.generate(2, (i) {
                    return int.tryParse(_scoreControllers[i].text) ?? 0;
                  });

                  for (int i = 0; i < 2; i++) {
                    bool isChecked(int box) =>
                        _checkboxStates?['${i}_$box'] ?? false;

                    if (isChecked(0)) {
                      inputScores[i] = 101;
                    }
                    if (isChecked(1)) {
                      inputScores[i] *= 2;
                    }
                    if (isChecked(2)) {
                      inputScores[i] *= 4;
                    }
                    if (isChecked(5)) {
                      inputScores[i] *= 2;
                    }
                  }

                  for (int i = 0; i < 2; i++) {
                    bool isFourth = _checkboxStates?['${i}_3'] ?? false;
                    bool isFifth = _checkboxStates?['${i}_4'] ?? false;
                    if (isFourth || isFifth) {
                      inputScores[i] = 0;
                      int other = i == 0 ? 1 : 0;
                      int multiplier = isFourth ? 2 : 4;
                      inputScores[other] *= multiplier;
                    }
                  }

                  showDialog(
                    context: context,
                    builder: (context) {
                      int? selectedPlayer;
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return AlertDialog(
                            title: Text('Gösterge'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(2, (i) {
                                    return Column(
                                      children: [
                                        Text(widget.playerNames[i]),
                                        Checkbox(
                                          value: selectedPlayer == i,
                                          onChanged: (val) {
                                            setDialogState(() {
                                              if (val == true) {
                                                selectedPlayer = i;
                                              } else {
                                                selectedPlayer = null;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (selectedPlayer != null) {
                                    setState(() {
                                      _scores[selectedPlayer!] -= 5;
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  setState(() {
                    for (int i = 0; i < 2; i++) {
                      _scores[i] += inputScores[i];
                      _lastAddedScores ??= List.filled(2, 0);
                      _lastAddedScores![i] = inputScores[i];
                      _scoreControllers[i].clear();
                    }
                    if (_checkboxStates != null) {
                      _checkboxStates!.updateAll((key, value) => false);
                    }
                  });
                },
                child: Text('Punkte hinzufügen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _GamePage3State extends State<GamePage3> {
  final List<TextEditingController> _playerControllers =
      List.generate(3, (_) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('3 Spieler Solo'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: Column(
                children: [
                  for (int i = 0; i < 3; i++) ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: _playerControllers[i],
                        decoration: InputDecoration(
                          labelText: 'Spieler ${i + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      List<String> playerNames = List.generate(
                        3,
                        (i) => _playerControllers[i].text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextGamePageSolo3(
                            playerNames: playerNames,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text('Spiel starten'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextGamePageSolo3 extends StatefulWidget {
  final List<String> playerNames;

  const NextGamePageSolo3({
    super.key,
    required this.playerNames,
  });

  @override
  _NextGamePageSolo3State createState() => _NextGamePageSolo3State();
}

class _NextGamePageSolo3State extends State<NextGamePageSolo3> {
  final List<int> _scores = [0, 0, 0];
  final List<TextEditingController> _scoreControllers =
      List.generate(3, (_) => TextEditingController());

  Map<String, bool>? _checkboxStates;
  List<int>? _lastAddedScores;
  List<String>? _editLog;

  @override
  void dispose() {
    for (final controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Icon-Erklärung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.close), SizedBox(width: 8), Text('= Acamadi')]),
            Row(children: [Icon(Icons.exposure_plus_1), SizedBox(width: 8), Text('= Elinde okey vardi')]),
            Row(children: [Icon(Icons.exposure_plus_2), SizedBox(width: 8), Text('= Elinde iki okey vardi')]),
            Row(children: [Icon(Icons.done), SizedBox(width: 8), Text('= Bitirdi')]),
            Row(children: [Icon(Icons.done_all), SizedBox(width: 8), Text('= Okeyle bitirdi')]),
            Row(children: [Icon(Icons.sync), SizedBox(width: 8), Text('= Okeyle bitirmeye dönüyordu')]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3 Spieler Solo'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            tooltip: 'Icon-Erklärung',
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.list),
                  tooltip: 'Edit-Log anzeigen',
                  onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                    title: Text('Edit-Log'),
                    content: Container(
                      constraints: BoxConstraints(maxHeight: 240, minWidth: 200),
                      width: 300,
                      child: (_editLog ?? []).isEmpty
                        ? Text('Keine Änderungen vorhanden.')
                        : ListView(
                          shrinkWrap: true,
                          children: (_editLog ?? [])
                            .reversed
                            .map((e) => Text(e, style: TextStyle(fontSize: 12)))
                            .toList(),
                        ),
                    ),
                    actions: [
                      TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Schließen'),
                      ),
                    ],
                    ),
                  );
                  },
                ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              widget.playerNames[i],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Punkte: ${_scores[i]}',
                            ),
                            Text(
                              '+${_lastAddedScores != null ? _lastAddedScores![i] : '0'}',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, size: 18),
                              tooltip: 'Punkte bearbeiten',
                              onPressed: () async {
                                int? result = await showDialog<int>(
                                  context: context,
                                  builder: (context) {
                                    final controller = TextEditingController();
                                    return AlertDialog(
                                      title: Text('Punkte bearbeiten'),
                                      content: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.numberWithOptions(signed: true),
                                        decoration: InputDecoration(
                                          labelText: 'Punkte (+/-)',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Abbrechen'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final value = int.tryParse(controller.text);
                                            if (value != null) {
                                              Navigator.of(context).pop(value);
                                            }
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (result != null && result != 0) {
                                  setState(() {
                                    _scores[i] += result;
                                    (_lastAddedScores ??= List.filled(3, 0));
                                    (_editLog ??= []).add(
                                      '${DateTime.now().toIso8601String()} - ${widget.playerNames[i]}: ${result > 0 ? '+' : ''}$result'
                                    );
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              SizedBox(height: 32),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (playerIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text(
                            widget.playerNames[playerIndex],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...List.generate(6, (checkboxIndex) {
                            return StatefulBuilder(
                              builder: (context, setLocalState) {
                                final checkboxKey = '${playerIndex}_$checkboxIndex';
                                _checkboxStates ??= {};
                                _checkboxStates!.putIfAbsent(checkboxKey, () => false);

                                void handleCheckboxChange(bool? value) {
                                  // Only allow at most two "second" checkboxes (checkboxIndex == 1) checked across all players
                                  if (checkboxIndex == 1 && value == true) {
                                    int checkedCount = 0;
                                    for (int p = 0; p < 3; p++) {
                                      if (_checkboxStates!['${p}_1'] == true) checkedCount++;
                                    }
                                    if (checkedCount >= 2 && _checkboxStates![checkboxKey] == false) {
                                      return;
                                    }
                                  }
                                  // If any "second" checkbox (checkboxIndex == 1) is checked, uncheck all third checkboxes
                                  if (checkboxIndex == 1 && value == true) {
                                    for (int p = 0; p < 3; p++) {
                                      _checkboxStates!['${p}_2'] = false;
                                    }
                                  }
                                  // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all second and third checkboxes for all players except this one
                                  if (checkboxIndex == 2 && value == true) {
                                    for (int p = 0; p < 3; p++) {
                                      if (p != playerIndex) {
                                        _checkboxStates!['${p}_1'] = false;
                                        _checkboxStates!['${p}_2'] = false;
                                      }
                                    }
                                  }
                                  // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all other third checkboxes
                                  if (checkboxIndex == 2 && value == true) {
                                    for (int p = 0; p < 3; p++) {
                                      if (p != playerIndex) {
                                        _checkboxStates!['${p}_2'] = false;
                                      }
                                    }
                                  }
                                  // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all second checkboxes except this player
                                  if (checkboxIndex == 2 && value == true) {
                                    for (int p = 0; p < 3; p++) {
                                      if (p != playerIndex) {
                                        _checkboxStates!['${p}_1'] = false;
                                      }
                                    }
                                  }
                                  setState(() {
                                    // Fourth checkbox logic (index 3)
                                    if (checkboxIndex == 3 && value == true) {
                                      for (int i = 0; i < 6; i++) {
                                        if (i != 3) {
                                          _checkboxStates!['${playerIndex}_$i'] = false;
                                        }
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // Fifth checkbox logic (index 4)
                                    else if (checkboxIndex == 4 && value == true) {
                                      for (int i = 0; i < 6; i++) {
                                        if (i != 4) {
                                          _checkboxStates!['${playerIndex}_$i'] = false;
                                        }
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // If any other checkbox is checked while 4th or 5th is checked, uncheck 4th/5th
                                    else if ((checkboxIndex != 3 && checkboxIndex != 4) && value == true) {
                                      if (_checkboxStates!['${playerIndex}_3'] == true) {
                                        _checkboxStates!['${playerIndex}_3'] = false;
                                      }
                                      if (_checkboxStates!['${playerIndex}_4'] == true) {
                                        _checkboxStates!['${playerIndex}_4'] = false;
                                      }
                                      if (checkboxIndex == 1 && value == true) {
                                        _checkboxStates!['${playerIndex}_2'] = false;
                                      }
                                      if (checkboxIndex == 2 && value == true) {
                                        _checkboxStates!['${playerIndex}_1'] = false;
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // 2nd and 3rd checkbox mutual exclusion (uncheck the other if this is unchecked)
                                    else if ((checkboxIndex == 1 || checkboxIndex == 2) && value == false) {
                                      _checkboxStates![checkboxKey] = false;
                                    }
                                    // Default: just set the value
                                    else {
                                      _checkboxStates![checkboxKey] = value ?? false;
                                    }
                                  });
                                }

                                Widget checkboxRow(IconData icon) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: _checkboxStates![checkboxKey],
                                        onChanged: handleCheckboxChange,
                                      ),
                                      Icon(icon, size: 18),
                                    ],
                                  );
                                }

                                if (checkboxIndex == 0) {
                                  return checkboxRow(Icons.close);
                                } else if (checkboxIndex == 1) {
                                  return checkboxRow(Icons.exposure_plus_1);
                                } else if (checkboxIndex == 2) {
                                  return checkboxRow(Icons.exposure_plus_2);
                                } else if (checkboxIndex == 3) {
                                  return checkboxRow(Icons.done);
                                } else if (checkboxIndex == 4) {
                                  return checkboxRow(Icons.done_all);
                                } else if (checkboxIndex == 5) {
                                  return checkboxRow(Icons.sync);
                                } else {
                                  return Checkbox(
                                    value: _checkboxStates![checkboxKey],
                                    onChanged: handleCheckboxChange,
                                  );
                                }
                              },
                            );
                          }),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _scores[playerIndex] += 101;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(60, 36),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: Text('+101'),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _scoreControllers[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if (newValue.text.isEmpty) return newValue;
                              final intValue = int.tryParse(newValue.text);
                              if (intValue == null || intValue > 1616) {
                                return oldValue;
                              }
                              return newValue;
                            }),
                          ],
                          decoration: InputDecoration(
                            labelText: widget.playerNames[index],
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  List<int> inputScores = List.generate(3, (i) {
                    return int.tryParse(_scoreControllers[i].text) ?? 0;
                  });

                  for (int i = 0; i < 3; i++) {
                    bool isChecked(int box) =>
                        _checkboxStates?['${i}_$box'] ?? false;

                    if (isChecked(0)) {
                      inputScores[i] = 101;
                    }
                    if (isChecked(1)) {
                      inputScores[i] *= 2;
                    }
                    if (isChecked(2)) {
                      inputScores[i] *= 4;
                    }
                    if (isChecked(5)) {
                      inputScores[i] *= 2;
                    }
                  }

                  for (int i = 0; i < 3; i++) {
                    bool isFourth = _checkboxStates?['${i}_3'] ?? false;
                    bool isFifth = _checkboxStates?['${i}_4'] ?? false;
                    if (isFourth || isFifth) {
                      inputScores[i] = 0;
                      int multiplier = isFourth ? 2 : 4;
                      for (int j = 0; j < 3; j++) {
                        if (j != i) {
                          inputScores[j] *= multiplier;
                        }
                      }
                    }
                  }

                  showDialog(
                    context: context,
                    builder: (context) {
                      int? selectedPlayer;
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return AlertDialog(
                            title: Text('Gösterge'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(3, (i) {
                                    return Column(
                                      children: [
                                        Text(widget.playerNames[i]),
                                        Checkbox(
                                          value: selectedPlayer == i,
                                          onChanged: (val) {
                                            setDialogState(() {
                                              if (val == true) {
                                                selectedPlayer = i;
                                              } else {
                                                selectedPlayer = null;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (selectedPlayer != null) {
                                    setState(() {
                                      _scores[selectedPlayer!] -= 5;
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  setState(() {
                    for (int i = 0; i < 3; i++) {
                      _scores[i] += inputScores[i];
                      _lastAddedScores ??= List.filled(3, 0);
                      _lastAddedScores![i] = inputScores[i];
                      _scoreControllers[i].clear();
                    }
                    if (_checkboxStates != null) {
                      _checkboxStates!.updateAll((key, value) => false);
                    }
                  });
                },
                child: Text('Punkte hinzufügen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _GamePage2State extends State<GamePage2> {
  final List<TextEditingController> _playerControllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('4 Spieler Solo'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: Column(
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: _playerControllers[i],
                        decoration: InputDecoration(
                          labelText: 'Spieler ${i + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      List<String> playerNames = List.generate(
                        4,
                        (i) => _playerControllers[i].text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextGamePageSolo(
                            playerNames: playerNames,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text('Spiel starten'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextGamePageSolo extends StatefulWidget {
  final List<String> playerNames;

  const NextGamePageSolo({
    super.key,
    required this.playerNames,
  });

  @override
  _NextGamePageSoloState createState() => _NextGamePageSoloState();
}

class _NextGamePageSoloState extends State<NextGamePageSolo> {
  final List<int> _scores = [0, 0, 0, 0];
  final List<TextEditingController> _scoreControllers =
      List.generate(4, (_) => TextEditingController());

  Map<String, bool>? _checkboxStates;
  List<int>? _lastAddedScores;
  List<String>? _editLog;

  @override
  void dispose() {
    for (final controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Icon-Erklärung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.close), SizedBox(width: 8), Text('= Acamadi')]),
            Row(children: [Icon(Icons.exposure_plus_1), SizedBox(width: 8), Text('= Elinde okey vardi')]),
            Row(children: [Icon(Icons.exposure_plus_2), SizedBox(width: 8), Text('= Elinde iki okey vardi')]),
            Row(children: [Icon(Icons.done), SizedBox(width: 8), Text('= Bitirdi')]),
            Row(children: [Icon(Icons.done_all), SizedBox(width: 8), Text('= Okeyle bitirdi')]),
            Row(children: [Icon(Icons.sync), SizedBox(width: 8), Text('= Okeyle bitirmeye dönüyordu')]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4 Spieler Solo'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            tooltip: 'Icon-Erklärung',
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // First row: Spieler 1 & 2
              Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
              icon: Icon(Icons.list),
              tooltip: 'Edit-Log anzeigen',
              onPressed: () {
                showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Edit-Log'),
                  content: Container(
                  constraints: BoxConstraints(maxHeight: 240, minWidth: 200),
                  width: 300,
                  child: (_editLog ?? []).isEmpty
                    ? Text('Keine Änderungen vorhanden.')
                    : ListView(
                      shrinkWrap: true,
                      children: (_editLog ?? [])
                        .reversed
                        .map((e) => Text(e, style: TextStyle(fontSize: 12)))
                        .toList(),
                      ),
                  ),
                  actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Schließen'),
                  ),
                  ],
                ),
                );
              },
              ),
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                  children: [
                    Text(widget.playerNames[0], style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Punkte: ${_scores[0]}'),
                      IconButton(
                      icon: Icon(Icons.edit, size: 18),
                      tooltip: 'Punkte bearbeiten',
                      onPressed: () async {
                        int? result = await showDialog<int>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                          title: Text('Punkte bearbeiten'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.numberWithOptions(signed: true),
                            decoration: InputDecoration(
                            labelText: 'Punkte (+/-)',
                            border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Abbrechen'),
                            ),
                            TextButton(
                            onPressed: () {
                              final value = int.tryParse(controller.text);
                              if (value != null) {
                              Navigator.of(context).pop(value);
                              }
                            },
                            child: Text('OK'),
                            ),
                          ],
                          );
                        },
                        );
                        if (result != null && result != 0) {
                        setState(() {
                          _scores[0] += result;
                          (_lastAddedScores ??= List.filled(4, 0));
                          (_editLog ??= []).add(
                          '${DateTime.now().toIso8601String()} - ${widget.playerNames[0]}: ${result > 0 ? '+' : ''}$result'
                          );
                        });
                        }
                      },
                      ),
                    ],
                    ),
                    Text(
                    '+${_lastAddedScores != null ? _lastAddedScores![0] : '0'}',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                  children: [
                    Text(widget.playerNames[1], style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Punkte: ${_scores[1]}'),
                      IconButton(
                      icon: Icon(Icons.edit, size: 18),
                      tooltip: 'Punkte bearbeiten',
                      onPressed: () async {
                        int? result = await showDialog<int>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                          title: Text('Punkte bearbeiten'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.numberWithOptions(signed: true),
                            decoration: InputDecoration(
                            labelText: 'Punkte (+/-)',
                            border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Abbrechen'),
                            ),
                            TextButton(
                            onPressed: () {
                              final value = int.tryParse(controller.text);
                              if (value != null) {
                              Navigator.of(context).pop(value);
                              }
                            },
                            child: Text('OK'),
                            ),
                          ],
                          );
                        },
                        );
                        if (result != null && result != 0) {
                        setState(() {
                          _scores[1] += result;
                          (_lastAddedScores ??= List.filled(4, 0));
                          (_editLog ??= []).add(
                          '${DateTime.now().toIso8601String()} - ${widget.playerNames[1]}: ${result > 0 ? '+' : ''}$result'
                          );
                        });
                        }
                      },
                      ),
                    ],
                    ),
                    Text(
                    '+${_lastAddedScores != null ? _lastAddedScores![1] : '0'}',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                  ),
                ),
                ],
              ),
              SizedBox(height: 12),
              // Second row: Spieler 3 & 4
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                  children: [
                    Text(widget.playerNames[2], style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Punkte: ${_scores[2]}'),
                      IconButton(
                      icon: Icon(Icons.edit, size: 18),
                      tooltip: 'Punkte bearbeiten',
                      onPressed: () async {
                        int? result = await showDialog<int>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                          title: Text('Punkte bearbeiten'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.numberWithOptions(signed: true),
                            decoration: InputDecoration(
                            labelText: 'Punkte (+/-)',
                            border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Abbrechen'),
                            ),
                            TextButton(
                            onPressed: () {
                              final value = int.tryParse(controller.text);
                              if (value != null) {
                              Navigator.of(context).pop(value);
                              }
                            },
                            child: Text('OK'),
                            ),
                          ],
                          );
                        },
                        );
                        if (result != null && result != 0) {
                        setState(() {
                          _scores[2] += result;
                          (_lastAddedScores ??= List.filled(4, 0));
                          (_editLog ??= []).add(
                          '${DateTime.now().toIso8601String()} - ${widget.playerNames[2]}: ${result > 0 ? '+' : ''}$result'
                          );
                        });
                        }
                      },
                      ),
                    ],
                    ),
                    Text(
                    '+${_lastAddedScores != null ? _lastAddedScores![2] : '0'}',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                  children: [
                    Text(widget.playerNames[3], style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Punkte: ${_scores[3]}'),
                      IconButton(
                      icon: Icon(Icons.edit, size: 18),
                      tooltip: 'Punkte bearbeiten',
                      onPressed: () async {
                        int? result = await showDialog<int>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                          title: Text('Punkte bearbeiten'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.numberWithOptions(signed: true),
                            decoration: InputDecoration(
                            labelText: 'Punkte (+/-)',
                            border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Abbrechen'),
                            ),
                            TextButton(
                            onPressed: () {
                              final value = int.tryParse(controller.text);
                              if (value != null) {
                              Navigator.of(context).pop(value);
                              }
                            },
                            child: Text('OK'),
                            ),
                          ],
                          );
                        },
                        );
                        if (result != null && result != 0) {
                        setState(() {
                          _scores[3] += result;
                          (_lastAddedScores ??= List.filled(4, 0));
                          (_editLog ??= []).add(
                          '${DateTime.now().toIso8601String()} - ${widget.playerNames[3]}: ${result > 0 ? '+' : ''}$result'
                          );
                        });
                        }
                      },
                      ),
                    ],
                    ),
                    Text(
                    '+${_lastAddedScores != null ? _lastAddedScores![3] : '0'}',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                  ),
                ),
                ],
              ),
              SizedBox(height: 12),
            
            SizedBox(height: 32),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (playerIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text(
                            widget.playerNames[playerIndex],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...List.generate(6, (checkboxIndex) {
                            return StatefulBuilder(
                              builder: (context, setLocalState) {
                                final checkboxKey = '${playerIndex}_$checkboxIndex';
                                _checkboxStates ??= {};
                                _checkboxStates!.putIfAbsent(checkboxKey, () => false);

                                void handleCheckboxChange(bool? value) {
                                  // Only allow at most two "second" checkboxes (checkboxIndex == 1) checked across all players
                                  if (checkboxIndex == 1 && value == true) {
                                    int checkedCount = 0;
                                    for (int p = 0; p < 4; p++) {
                                      if (_checkboxStates!['${p}_1'] == true) checkedCount++;
                                    }
                                    if (checkedCount >= 2 && _checkboxStates![checkboxKey] == false) {
                                      return;
                                    }
                                  }
                                  // If any "second" checkbox (checkboxIndex == 1) is checked, uncheck all third checkboxes
                                  if (checkboxIndex == 1 && value == true) {
                                    for (int p = 0; p < 4; p++) {
                                      _checkboxStates!['${p}_2'] = false;
                                    }
                                  }
                                  // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all second and third checkboxes for all players except this one
                                  if (checkboxIndex == 2 && value == true) {
                                    for (int p = 0; p < 4; p++) {
                                      if (p != playerIndex) {
                                        _checkboxStates!['${p}_1'] = false;
                                        _checkboxStates!['${p}_2'] = false;
                                      }
                                    }
                                  }
                                  // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all other third checkboxes
                                  if (checkboxIndex == 2 && value == true) {
                                    for (int p = 0; p < 4; p++) {
                                      if (p != playerIndex) {
                                        _checkboxStates!['${p}_2'] = false;
                                      }
                                    }
                                  }
                                  // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all second checkboxes except this player
                                  if (checkboxIndex == 2 && value == true) {
                                    for (int p = 0; p < 4; p++) {
                                      if (p != playerIndex) {
                                        _checkboxStates!['${p}_1'] = false;
                                      }
                                    }
                                  }
                                  setState(() {
                                    // Fourth checkbox logic (index 3)
                                    if (checkboxIndex == 3 && value == true) {
                                      for (int i = 0; i < 6; i++) {
                                        if (i != 3) {
                                          _checkboxStates!['${playerIndex}_$i'] = false;
                                        }
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // Fifth checkbox logic (index 4)
                                    else if (checkboxIndex == 4 && value == true) {
                                      for (int i = 0; i < 6; i++) {
                                        if (i != 4) {
                                          _checkboxStates!['${playerIndex}_$i'] = false;
                                        }
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // If any other checkbox is checked while 4th or 5th is checked, uncheck 4th/5th
                                    else if ((checkboxIndex != 3 && checkboxIndex != 4) && value == true) {
                                      if (_checkboxStates!['${playerIndex}_3'] == true) {
                                        _checkboxStates!['${playerIndex}_3'] = false;
                                      }
                                      if (_checkboxStates!['${playerIndex}_4'] == true) {
                                        _checkboxStates!['${playerIndex}_4'] = false;
                                      }
                                      if (checkboxIndex == 1 && value == true) {
                                        _checkboxStates!['${playerIndex}_2'] = false;
                                      }
                                      if (checkboxIndex == 2 && value == true) {
                                        _checkboxStates!['${playerIndex}_1'] = false;
                                      }
                                      _checkboxStates![checkboxKey] = true;
                                    }
                                    // 2nd and 3rd checkbox mutual exclusion (uncheck the other if this is unchecked)
                                    else if ((checkboxIndex == 1 || checkboxIndex == 2) && value == false) {
                                      _checkboxStates![checkboxKey] = false;
                                    }
                                    // Default: just set the value
                                    else {
                                      _checkboxStates![checkboxKey] = value ?? false;
                                    }
                                  });
                                }

                                Widget checkboxRow(IconData icon) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: _checkboxStates![checkboxKey],
                                        onChanged: handleCheckboxChange,
                                      ),
                                      Icon(icon, size: 18),
                                    ],
                                  );
                                }

                                if (checkboxIndex == 0) {
                                  return checkboxRow(Icons.close);
                                } else if (checkboxIndex == 1) {
                                  return checkboxRow(Icons.exposure_plus_1);
                                } else if (checkboxIndex == 2) {
                                  return checkboxRow(Icons.exposure_plus_2);
                                } else if (checkboxIndex == 3) {
                                  return checkboxRow(Icons.done);
                                } else if (checkboxIndex == 4) {
                                  return checkboxRow(Icons.done_all);
                                } else if (checkboxIndex == 5) {
                                  return checkboxRow(Icons.sync);
                                } else {
                                  return Checkbox(
                                    value: _checkboxStates![checkboxKey],
                                    onChanged: handleCheckboxChange,
                                  );
                                }
                              },
                            );
                          }),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _scores[playerIndex] += 101;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(60, 36),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: Text('+101'),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _scoreControllers[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if (newValue.text.isEmpty) return newValue;
                              final intValue = int.tryParse(newValue.text);
                              if (intValue == null || intValue > 1616) {
                                return oldValue;
                              }
                              return newValue;
                            }),
                          ],
                          decoration: InputDecoration(
                            labelText: widget.playerNames[index],
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  List<int> inputScores = List.generate(4, (i) {
                    return int.tryParse(_scoreControllers[i].text) ?? 0;
                  });

                  for (int i = 0; i < 4; i++) {
                    bool isChecked(int box) =>
                        _checkboxStates?['${i}_$box'] ?? false;

                    if (isChecked(0)) {
                      inputScores[i] = 101;
                    }
                    if (isChecked(1)) {
                      inputScores[i] *= 2;
                    }
                    if (isChecked(2)) {
                      inputScores[i] *= 4;
                    }
                    if (isChecked(5)) {
                      inputScores[i] *= 2;
                    }
                  }

                  for (int i = 0; i < 4; i++) {
                    bool isFourth = _checkboxStates?['${i}_3'] ?? false;
                    bool isFifth = _checkboxStates?['${i}_4'] ?? false;
                    if (isFourth || isFifth) {
                      // In solo mode, just set this player's score to 0 and multiply all others
                      inputScores[i] = 0;
                      int multiplier = isFourth ? 2 : 4;
                      for (int j = 0; j < 4; j++) {
                        if (j != i) {
                          inputScores[j] *= multiplier;
                        }
                      }
                    }
                  }

                  showDialog(
                    context: context,
                    builder: (context) {
                      int? selectedPlayer;
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return AlertDialog(
                            title: Text('Gösterge'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(4, (i) {
                                    return Column(
                                      children: [
                                        Text(widget.playerNames[i]),
                                        Checkbox(
                                          value: selectedPlayer == i,
                                          onChanged: (val) {
                                            setDialogState(() {
                                              if (val == true) {
                                                selectedPlayer = i;
                                              } else {
                                                selectedPlayer = null;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (selectedPlayer != null) {
                                    setState(() {
                                      _scores[selectedPlayer!] -= 5;
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  setState(() {
                    for (int i = 0; i < 4; i++) {
                      _scores[i] += inputScores[i];
                      _lastAddedScores ??= List.filled(4, 0);
                      _lastAddedScores![i] = inputScores[i];
                      _scoreControllers[i].clear();
                    }
                    if (_checkboxStates != null) {
                      _checkboxStates!.updateAll((key, value) => false);
                    }
                  });
                },
                child: Text('Punkte hinzufügen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GamePage1State extends State<GamePage1> {
  final TextEditingController team1Controller = TextEditingController();
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();
  final TextEditingController team2Controller = TextEditingController();
  final TextEditingController player3Controller = TextEditingController();
  final TextEditingController player4Controller = TextEditingController();

  @override
  void dispose() {
    team1Controller.dispose();
    player1Controller.dispose();
    player2Controller.dispose();
    team2Controller.dispose();
    player3Controller.dispose();
    player4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
            leading: BackButton(
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('4 Spieler Teams'),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          SizedBox(
            width: 320,
            child: Column(
              children: [
                // Team 1 outline
                Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Text('Team 1'),
                TextField(
                  controller: team1Controller,
                  decoration: InputDecoration(
              labelText: 'Team 1',
              border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: player1Controller,
                  decoration: InputDecoration(
              labelText: 'Spieler 1',
              border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: player2Controller,
                  decoration: InputDecoration(
              labelText: 'Spieler 2',
              border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
                ),
                // Team 2 outline
                Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text('Team 2'),
                TextField(
                  controller: team2Controller,
                  decoration: InputDecoration(
              labelText: 'Team 2',
              border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: player3Controller,
                  decoration: InputDecoration(
              labelText: 'Spieler 3',
              border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: player4Controller,
                  decoration: InputDecoration(
              labelText: 'Spieler 4',
              border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
            onPressed: () {
              // Collect input values and navigate to the next page
              String team1Name = team1Controller.text;
              String player1Name = player1Controller.text;
              String player2Name = player2Controller.text;
              String team2Name = team2Controller.text;
              String player3Name = player3Controller.text;
              String player4Name = player4Controller.text;

              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NextGamePage(
                team1Name: team1Name,
                player1Name: player1Name,
                player2Name: player2Name,
                team2Name: team2Name,
                player3Name: player3Name,
                player4Name: player4Name,
                ),
              ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text('Spiel starten'),
                ),
              ],
            ),
          ),
              ],
            ),
          ],
        )
      ),
    );
  }
}

// Move NextGamePage outside of _GamePage1State

class NextGamePage extends StatefulWidget {
  final String team1Name;
  final String player1Name;
  final String player2Name;
  final String team2Name;
  final String player3Name;
  final String player4Name;

  const NextGamePage({
    super.key,
    required this.team1Name,
    required this.player1Name,
    required this.player2Name,
    required this.team2Name,
    required this.player3Name,
    required this.player4Name,
  });

  @override
  _NextGamePageState createState() => _NextGamePageState();
}

class _NextGamePageState extends State<NextGamePage> {
  final List<int> _scores = [0, 0, 0, 0];
  final List<TextEditingController> _scoreControllers =
      List.generate(4, (_) => TextEditingController());

  Map<String, bool>? _checkboxStates;
  List<int>? _lastAddedScores;
  List<String>? _editLog;

  @override
  void dispose() {
    for (final controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Icon-Erklärung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.close), SizedBox(width: 8), Text('= Acamadi')]),
            Row(children: [Icon(Icons.exposure_plus_1), SizedBox(width: 8), Text('= Elinde okey vardi')]),
            Row(children: [Icon(Icons.exposure_plus_2), SizedBox(width: 8), Text('= Elinde iki okey vardi')]),
            Row(children: [Icon(Icons.done), SizedBox(width: 8), Text('= Bitirdi')]),
            Row(children: [Icon(Icons.done_all), SizedBox(width: 8), Text('= Okeyle bitirdi')]),
            Row(children: [Icon(Icons.sync), SizedBox(width: 8), Text('= Okeyle bitirmeye dönüyordu')]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4 Spieler Teams'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            tooltip: 'Icon-Erklärung',
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 0, // No extra height, just for structure
              ),
              // Display total scores above the TextFields, grouped by teams
                Column(
                children: [
                  Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.list),
                    tooltip: 'Edit-Log anzeigen',
                    onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                      title: Text('Edit-Log'),
                      content: Container(
                        constraints: BoxConstraints(maxHeight: 240, minWidth: 200),
                        width: 300,
                        child: (_editLog ?? []).isEmpty
                          ? Text('Keine Änderungen vorhanden.')
                          : ListView(
                            shrinkWrap: true,
                            children: (_editLog ?? [])
                              .reversed
                              .map((e) => Text(e, style: TextStyle(fontSize: 12)))
                              .toList(),
                          ),
                      ),
                      actions: [
                        TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Schließen'),
                        ),
                      ],
                      ),
                    );
                    },
                  ),
                  ),
                  Text(widget.team1Name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Text(widget.player1Name),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Text('Punkte: ${_scores[0]}'),
                        IconButton(
                          icon: Icon(Icons.edit, size: 18),
                          tooltip: 'Punkte bearbeiten',
                          onPressed: () async {
                          int? result = await showDialog<int>(
                            context: context,
                            builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                              title: Text('Punkte bearbeiten'),
                              content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.numberWithOptions(signed: true),
                              decoration: InputDecoration(
                                labelText: 'Punkte (+/-)',
                                border: OutlineInputBorder(),
                              ),
                              ),
                              actions: [
                              TextButton(
                                onPressed: () {
                                Navigator.of(context).pop();
                                },
                                child: Text('Abbrechen'),
                              ),
                              TextButton(
                                onPressed: () {
                                final value = int.tryParse(controller.text);
                                if (value != null) {
                                  Navigator.of(context).pop(value);
                                }
                                },
                                child: Text('OK'),
                              ),
                              ],
                            );
                            },
                          );
                          if (result != null && result != 0) {
                            setState(() {
                            _scores[0] += result;
                            (_editLog ??= []).add(
                              '${DateTime.now().toIso8601String()} - ${widget.player1Name}: ${result > 0 ? '+' : ''}$result'
                            );
                            });
                          }
                          },
                        ),
                        ],
                      ),
                      Text(
                        '+${_lastAddedScores != null ? _lastAddedScores![0] : '0'}',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      ],
                    ),
                    ),
                    SizedBox(width: 32),
                    Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Text(widget.player2Name),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Text('Punkte: ${_scores[1]}'),
                        IconButton(
                          icon: Icon(Icons.edit, size: 18),
                          tooltip: 'Punkte bearbeiten',
                          onPressed: () async {
                          int? result = await showDialog<int>(
                            context: context,
                            builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                              title: Text('Punkte bearbeiten'),
                              content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.numberWithOptions(signed: true),
                              decoration: InputDecoration(
                                labelText: 'Punkte (+/-)',
                                border: OutlineInputBorder(),
                              ),
                              ),
                              actions: [
                              TextButton(
                                onPressed: () {
                                Navigator.of(context).pop();
                                },
                                child: Text('Abbrechen'),
                              ),
                              TextButton(
                                onPressed: () {
                                final value = int.tryParse(controller.text);
                                if (value != null) {
                                  Navigator.of(context).pop(value);
                                }
                                },
                                child: Text('OK'),
                              ),
                              ],
                            );
                            },
                          );
                          if (result != null && result != 0) {
                            setState(() {
                            _scores[1] += result;
                            (_editLog ??= []).add(
                              '${DateTime.now().toIso8601String()} - ${widget.player2Name}: ${result > 0 ? '+' : ''}$result'
                            );
                            });
                          }
                          },
                        ),
                        ],
                      ),
                      Text(
                        '+${_lastAddedScores != null ? _lastAddedScores![1] : '0'}',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      ],
                    ),
                    ),
                  ],
                  ),
                  SizedBox(height: 8),
                  Text(
                  '${widget.team1Name} gesamt: ${_scores[0] + _scores[1]}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(widget.team2Name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                    children: [
                      Text(widget.player3Name),
                      Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Punkte: ${_scores[2]}'),
                        IconButton(
                        icon: Icon(Icons.edit, size: 18),
                        tooltip: 'Punkte bearbeiten',
                        onPressed: () async {
                          int? result = await showDialog<int>(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                            title: Text('Punkte bearbeiten'),
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.numberWithOptions(signed: true),
                              decoration: InputDecoration(
                              labelText: 'Punkte (+/-)',
                              border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Abbrechen'),
                              ),
                              TextButton(
                              onPressed: () {
                                final value = int.tryParse(controller.text);
                                if (value != null) {
                                Navigator.of(context).pop(value);
                                }
                              },
                              child: Text('OK'),
                              ),
                            ],
                            );
                          },
                          );
                          if (result != null && result != 0) {
                          setState(() {
                            _scores[2] += result;
                            (_editLog ??= []).add(
                            '${DateTime.now().toIso8601String()} - ${widget.player3Name}: ${result > 0 ? '+' : ''}$result'
                            );
                          });
                          }
                        },
                        ),
                      ],
                      ),
                      Text(
                      '+${_lastAddedScores != null ? _lastAddedScores![2] : '0'}',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                    ),
                    SizedBox(width: 32),
                    Column(
                    children: [
                      Text(widget.player4Name),
                      Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Punkte: ${_scores[3]}'),
                        IconButton(
                        icon: Icon(Icons.edit, size: 18),
                        tooltip: 'Punkte bearbeiten',
                        onPressed: () async {
                          int? result = await showDialog<int>(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                            title: Text('Punkte bearbeiten'),
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.numberWithOptions(signed: true),
                              decoration: InputDecoration(
                              labelText: 'Punkte (+/-)',
                              border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Abbrechen'),
                              ),
                              TextButton(
                              onPressed: () {
                                final value = int.tryParse(controller.text);
                                if (value != null) {
                                Navigator.of(context).pop(value);
                                }
                              },
                              child: Text('OK'),
                              ),
                            ],
                            );
                          },
                          );
                          if (result != null && result != 0) {
                          setState(() {
                            _scores[3] += result;
                            (_editLog ??= []).add(
                            '${DateTime.now().toIso8601String()} - ${widget.player4Name}: ${result > 0 ? '+' : ''}$result'
                            );
                          });
                          }
                        },
                        ),
                      ],
                      ),
                      Text(
                      '+${_lastAddedScores != null ? _lastAddedScores![3] : '0'}',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                    ),
                  ],
                  ),
                  SizedBox(height: 8),
                  Text(
                  '${widget.team2Name} gesamt: ${_scores[2] + _scores[3]}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0),
                  // Edit log button (popup)
                  
                ],
                ),
                // 6 checkboxes for each player
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (playerIndex) {
                    return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                      Text(
                        [
                        widget.player1Name,
                        widget.player2Name,
                        widget.player3Name,
                        widget.player4Name
                        ][playerIndex],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List.generate(6, (checkboxIndex) {
                        return StatefulBuilder(
                        builder: (context, setLocalState) {
                          final checkboxKey = '${playerIndex}_$checkboxIndex';
                          _checkboxStates ??= {};
                          _checkboxStates!.putIfAbsent(checkboxKey, () => false);

                            void handleCheckboxChange(bool? value) {
                            // Only allow at most two "second" checkboxes (checkboxIndex == 1) checked across all players
                            if (checkboxIndex == 1 && value == true) {
                              int checkedCount = 0;
                              for (int p = 0; p < 4; p++) {
                              if (_checkboxStates!['${p}_1'] == true) checkedCount++;
                              }
                              // If already two are checked and this one is not checked, prevent checking
                              if (checkedCount >= 2 && _checkboxStates![checkboxKey] == false) {
                              return;
                              }
                            }
                            // If any "second" checkbox (checkboxIndex == 1) is checked, uncheck all third checkboxes
                            if (checkboxIndex == 1 && value == true) {
                              for (int p = 0; p < 4; p++) {
                              _checkboxStates!['${p}_2'] = false;
                              }
                            }
                            // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all second and third checkboxes for all players except this one
                            if (checkboxIndex == 2 && value == true) {
                              for (int p = 0; p < 4; p++) {
                              if (p != playerIndex) {
                                _checkboxStates!['${p}_1'] = false;
                                _checkboxStates!['${p}_2'] = false;
                              }
                              }
                            }

                            // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all other third checkboxes
                            if (checkboxIndex == 2 && value == true) {
                              for (int p = 0; p < 4; p++) {
                              if (p != playerIndex) {
                                _checkboxStates!['${p}_2'] = false;
                              }
                              }
                            }

                            // If any "third" checkbox (checkboxIndex == 2) is checked, uncheck all second checkboxes except this player
                            if (checkboxIndex == 2 && value == true) {
                              for (int p = 0; p < 4; p++) {
                              if (p != playerIndex) {
                                _checkboxStates!['${p}_1'] = false;
                              }
                              }
                            }
                          setState(() {
                            // Fourth checkbox logic (index 3)
                            if (checkboxIndex == 3 && value == true) {
                            // Uncheck all others for this player
                            for (int i = 0; i < 6; i++) {
                              if (i != 3) {
                              _checkboxStates!['${playerIndex}_$i'] = false;
                              }
                            }
                            _checkboxStates![checkboxKey] = true;
                            }
                            // Fifth checkbox logic (index 4)
                            else if (checkboxIndex == 4 && value == true) {
                            for (int i = 0; i < 6; i++) {
                              if (i != 4) {
                              _checkboxStates!['${playerIndex}_$i'] = false;
                              }
                            }
                            _checkboxStates![checkboxKey] = true;
                            }
                            // If any other checkbox is checked while 4th or 5th is checked, uncheck 4th/5th
                            else if ((checkboxIndex != 3 && checkboxIndex != 4) && value == true) {
                            if (_checkboxStates!['${playerIndex}_3'] == true) {
                              _checkboxStates!['${playerIndex}_3'] = false;
                            }
                            if (_checkboxStates!['${playerIndex}_4'] == true) {
                              _checkboxStates!['${playerIndex}_4'] = false;
                            }
                            // 2nd and 3rd checkbox mutual exclusion
                            if (checkboxIndex == 1 && value == true) {
                              _checkboxStates!['${playerIndex}_2'] = false;
                            }
                            if (checkboxIndex == 2 && value == true) {
                              _checkboxStates!['${playerIndex}_1'] = false;
                            }
                            _checkboxStates![checkboxKey] = true;
                            }
                            // 2nd and 3rd checkbox mutual exclusion (uncheck the other if this is unchecked)
                            else if ((checkboxIndex == 1 || checkboxIndex == 2) && value == false) {
                            _checkboxStates![checkboxKey] = false;
                            }
                            // Default: just set the value
                            else {
                            _checkboxStates![checkboxKey] = value ?? false;
                            }
                          });
                          }

                          Widget checkboxRow(IconData icon) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            Checkbox(
                              value: _checkboxStates![checkboxKey],
                              onChanged: handleCheckboxChange,
                            ),
                            Icon(icon, size: 18),
                            ],
                          );
                          }

                          if (checkboxIndex == 0) {
                          return checkboxRow(Icons.close);
                          } else if (checkboxIndex == 1) {
                          return checkboxRow(Icons.exposure_plus_1);
                          } else if (checkboxIndex == 2) {
                          return checkboxRow(Icons.exposure_plus_2);
                          } else if (checkboxIndex == 3) {
                          return checkboxRow(Icons.done);
                          } else if (checkboxIndex == 4) {
                          return checkboxRow(Icons.done_all);
                          } else if (checkboxIndex == 5) {
                          return checkboxRow(Icons.sync);
                          } else {
                          return Checkbox(
                            value: _checkboxStates![checkboxKey],
                            onChanged: handleCheckboxChange,
                          );
                          }
                        }
                        );
                      }),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                        setState(() {
                          _scores[playerIndex] += 101;
                        });
                        },
                        style: ElevatedButton.styleFrom(
                        minimumSize: Size(60, 36),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Text('+101'),
                      ),
                      ],
                    ),
                    );
                  }),
                  ),
                ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _scoreControllers[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if (newValue.text.isEmpty) return newValue;
                              final intValue = int.tryParse(newValue.text);
                              if (intValue == null || intValue > 1616) {
                                return oldValue;
                              }
                              return newValue;
                            }),
                          ],
                          decoration: InputDecoration(
                            labelText: [
                              widget.player1Name,
                              widget.player2Name,
                              widget.player3Name,
                              widget.player4Name
                            ][index],
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Prepare a list to hold the input values
                  List<int> inputScores = List.generate(4, (i) {
                  return int.tryParse(_scoreControllers[i].text) ?? 0;
                  });

                  // Apply checkbox rules for each player
                  for (int i = 0; i < 4; i++) {
                  // Helper to get checkbox state
                  bool isChecked(int box) =>
                    _checkboxStates?['${i}_$box'] ?? false;

                  // 1st checkbox: set input to 101
                  if (isChecked(0)) {
                    inputScores[i] = 101;
                  }
                  // 2nd checkbox: multiply by 2
                  if (isChecked(1)) {
                    inputScores[i] *= 2;
                  }
                  // 3rd checkbox: multiply by 4
                  if (isChecked(2)) {
                    inputScores[i] *= 4;
                  }
                  // 6th checkbox: multiply by 2
                  if (isChecked(5)) {
                    inputScores[i] *= 2;
                  }
                  }

                  // 4th and 5th checkbox: set own team to 0, multiply opponent team
                  for (int i = 0; i < 4; i++) {
                  bool isFourth = _checkboxStates?['${i}_3'] ?? false;
                  bool isFifth = _checkboxStates?['${i}_4'] ?? false;
                  if (isFourth || isFifth) {
                    // Determine teammate and opponents
                    int teammate = (i % 2 == 0) ? i + 1 : i - 1;
                    List<int> opponents = (i < 2) ? [2, 3] : [0, 1];
                    // Set own team to 0
                    inputScores[i] = 0;
                    inputScores[teammate] = 0;
                    // Multiply opponent team
                    int multiplier = isFourth ? 2 : 4;
                    for (var opp in opponents) {
                    inputScores[opp] *= multiplier;
                    }
                  }
                  }
                    // Show popup for 'Gösterge'
                    showDialog(
                    context: context,
                    builder: (context) {
                      int? selectedPlayer;
                      return StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                        title: Text('Gösterge'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (i) {
                            return Column(
                              children: [
                              Text([
                                widget.player1Name,
                                widget.player2Name,
                                widget.player3Name,
                                widget.player4Name
                              ][i]),
                              Checkbox(
                                value: selectedPlayer == i,
                                onChanged: (val) {
                                setDialogState(() {
                                  if (val == true) {
                                  selectedPlayer = i;
                                  } else {
                                  selectedPlayer = null;
                                  }
                                });
                                },
                              ),
                              ],
                            );
                            }),
                          ),
                          ],
                        ),
                        actions: [
                          TextButton(
                          onPressed: () {
                            if (selectedPlayer != null) {
                            setState(() {
                              _scores[selectedPlayer!] -= 5;
                            });
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text('Submit'),
                          ),
                        ],
                        );
                      },
                      );
                    },
                    );
                  // Add to total scores and clear input
                  setState(() {
                  for (int i = 0; i < 4; i++) {
                    _scores[i] += inputScores[i];
                    _lastAddedScores ??= List.filled(4, 0);
                    _lastAddedScores![i] = inputScores[i];
                    _scoreControllers[i].clear();
                  }
                  // Uncheck all checkboxes
                  if (_checkboxStates != null) {
                    _checkboxStates!.updateAll((key, value) => false);
                  }
                  });
                },
                child: Text('Punkte hinzufügen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

enum TimeLengthEnum { CustomTime, UntilEnd }

class MusicListTab extends StatefulWidget {
  @override
  State<MusicListTab> createState() => _MusicListTabState();
}

class _MusicListTabState extends State<MusicListTab> {
  List<PlatformFile> _selectedFiles = [];
  AudioPlayer _audioPlayer = AudioPlayer();
  String _currentPlayingFileName = '';
  bool _isPlaying = false;
  int _currentPlayingIndex = -1;
  Duration? duration;
  Duration? position;

  int selectedVal = 60;

  _MusicListTabState() {
    _selectedVal = _timeLengthList[0];
  }

  TimeLengthEnum? _timeLengthEnum;

  final _timeLengthList = ["1", "5", "10", "15", "30", "60"];
  String? _selectedVal = "";

  bool _isVisible = false;

  void endMusic() {
    _audioPlayer.stop();
    SystemNavigator.pop();
  }

  void startTimer() {
    _audioPlayer.onPlayerComplete.listen((event) {
      if (_currentPlayingIndex < _selectedFiles.length - 1) {
        _playAudio(_currentPlayingIndex + 1);
      } else {
        endMusic();
      }
    });

    if (_timeLengthEnum == TimeLengthEnum.CustomTime) {
      int customTimeInSeconds = int.parse(_selectedVal!);
      Future.delayed(Duration(minutes: customTimeInSeconds), () {
        endMusic();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateDuration();
    updatePosition();
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null) {
        setState(() {
          _selectedFiles
              .addAll(result.files); // Concatenate new files with existing ones
          _currentPlayingIndex =
              0; // Set the current index to the first file in the updated list
        });
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  void _playAudio(int index) async {
    if (index >= 0 && index < _selectedFiles.length) {
      _audioPlayer.play(
          DeviceFileSource(Uri.file(_selectedFiles[index].path!).toString()));

      _audioPlayer.onDurationChanged.listen((Duration d) {
        setState(() => duration = d);
      });

      _audioPlayer.onPositionChanged.listen((Duration p) {
        setState(() => position = p);
      });

      setState(() {
        _currentPlayingFileName = _selectedFiles[index].name ?? 'Unknown';
        _isPlaying = true;
        _currentPlayingIndex = index;
      });
    }
    startTimer();
  }

  void _pauseAudio() {
    _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _skipNext() {
    if (_currentPlayingIndex < _selectedFiles.length - 1) {
      _audioPlayer.pause();
      _playAudio(_currentPlayingIndex + 1);
      _audioPlayer.resume();
    }
  }

  void _skipPrevious() {
    if (_currentPlayingIndex > 0) {
      _audioPlayer.pause();
      _playAudio(_currentPlayingIndex - 1);
      _audioPlayer.resume();
    }
  }

  void updateDuration() {
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });
  }

  void updatePosition() {
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });
  }

  Future<void> _showStartConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Start SongDreamer"),
          content: Text("Do you want to start the SongDreamer?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                _startPlaylistAndNavigate();
              },
            ),
          ],
        );
      },
    );
  }

  void _startPlaylistAndNavigate() {
    if (_selectedFiles.isNotEmpty) {
      _playAudio(0);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showStartConfirmationDialog(context);
        },
        backgroundColor: Colors.teal.shade400,
        child: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        title: Text('Music List'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade300,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueGrey.shade100),
                  ),
                  onPressed: _pickFiles,
                  child: Text('Pick MP3 Files'),
                ),
                Center(
                  child: SizedBox(
                    width:
                        250,
                    height:
                        300,
                    child: DecoratedBox(
                      position: DecorationPosition.background,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade200,
                          border: Border.all(color: Colors.black)),
                      child: ListView.builder(
                        itemCount: _selectedFiles.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_selectedFiles[index].name ??
                                'No name available'),
                            subtitle: Text(_selectedFiles[index].path ??
                                'No path available'),
                            onTap: () {
                              _playAudio(index);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: RadioListTile<TimeLengthEnum>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        tileColor: Colors.blueGrey.shade200,
                        title: Text(
                          "Custom Time",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        value: TimeLengthEnum.CustomTime,
                        groupValue: _timeLengthEnum,
                        onChanged: (val) {
                          setState(() {
                            _timeLengthEnum = val;
                            _isVisible = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: RadioListTile<TimeLengthEnum>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        tileColor: Colors.blueGrey.shade200,
                        title: Text(
                          "Until Finishes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        value: TimeLengthEnum.UntilEnd,
                        groupValue: _timeLengthEnum,
                        onChanged: (val) {
                          setState(() {
                            _timeLengthEnum = val;
                            _isVisible = false;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
                Visibility(
                  visible: _isVisible,
                  child: DropdownButtonFormField(
                    padding: EdgeInsets.fromLTRB(50.0, 0.0, 250.0, 0.0),
                    value: _selectedVal,
                    items: _timeLengthList
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedVal = val;
                      });
                    },
                    dropdownColor: Colors.blueGrey.shade100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.teal.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 5,
              child: Text(_currentPlayingFileName),
            ),
            Expanded(
              flex: 2,
              child: Text(
                position != null
                    ? '${position!.inMinutes}:${(position!.inSeconds % 60).toString().padLeft(2, '0')}'
                    : '0:00',
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                duration != null
                    ? '${duration!.inMinutes}:${(duration!.inSeconds % 60).toString().padLeft(2, '0')}'
                    : '0:00',
              ),
            ),
            IconButton(
              icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () {
                if (_isPlaying) {
                  _pauseAudio();
                } else {
                  if (_currentPlayingIndex != -1) {
                    _audioPlayer.resume();
                    setState(() {
                      _isPlaying = true;
                    });
                  }
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: _skipPrevious,
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: _skipNext,
            ),
          ],
        ),
      ),
    );
  }
}

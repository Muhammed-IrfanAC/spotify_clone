import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerPage extends StatefulWidget {
  final String poster;
  final String songName;
  final String artist;
  final String audioUrl;
  final AudioPlayer player;

  const AudioPlayerPage(
      {super.key,
      required this.player,
      required this.poster,
      required this.songName,
      required this.artist,
      required this.audioUrl});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  int playPauseStateVariable = 0;
  Icon playPauseIcon =
      const Icon(Icons.pause_circle_filled, size: 80, color: Colors.white);
  Duration? totalDuration;
  Duration? currentPosition;

  playMusic() async {
    await widget.player.stop();
    await widget.player.setSourceUrl(widget.audioUrl);
    widget.player.resume();
    playPauseStateVariable = 1;
  }

  getDuration() {
    widget.player.onDurationChanged.listen((Duration d) {
      setState(() => totalDuration = d);
    });
  }

  getCurrentPosition() {
    widget.player.onPositionChanged.listen((Duration p) {
      setState(() => currentPosition = p);
    });
  }

  @override
  void initState() {
    super.initState();
    playMusic();
    getDuration();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("CURRENTLY PLAYING"),
                        Text(widget.songName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 60),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 500,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(widget.poster),
                          fit: BoxFit.fill)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.songName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(widget.artist,
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Icon(Icons.favorite_border)],
                    )
                  ],
                ),
                const SizedBox(height: 15),
                ProgressBar(
                  progressBarColor: Colors.white,
                  thumbColor: Colors.white,
                  thumbGlowRadius: 18,
                  thumbRadius: 8,
                  progress: currentPosition ?? const Duration(milliseconds: 0),
                  total: totalDuration ?? const Duration(milliseconds: 0),
                  onSeek: (duration) async {
                    await widget.player.seek(duration);
                    setState(() {
                      currentPosition = duration;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.skip_previous_sharp,
                          size: 40, color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () async {
                          if (playPauseStateVariable == 0) {
                            widget.player.resume();
                            playPauseStateVariable = 1;
                            setState(() {
                              playPauseIcon = const Icon(
                                  Icons.pause_circle_filled,
                                  size: 80,
                                  color: Colors.white);
                            });
                          } else {
                            widget.player.pause();
                            playPauseStateVariable = 0;
                            setState(() {
                              playPauseIcon = const Icon(
                                  Icons.play_circle_filled,
                                  size: 80,
                                  color: Colors.white);
                            });
                          }
                        },
                        icon: playPauseIcon),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next_sharp,
                            size: 40, color: Colors.white)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

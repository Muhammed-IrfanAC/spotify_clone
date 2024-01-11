import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/screens/audio_player_screen.dart';

class SongList extends StatelessWidget {
  final AudioPlayer player;
  const SongList({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
        FirebaseFirestore.instance.collectionGroup('tracks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var trackDocs = snapshot.data?.docs;
            return ListView.builder(
                itemBuilder: (context, index) {
                  var trackData = trackDocs[index].data();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        trackData['songname']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(trackData['artistname']!,
                        style: const TextStyle(fontSize: 18),),
                      leading: SizedBox(
                          width: 100,
                          child: Image.network(
                            trackData['poster']!,
                            fit: BoxFit.fill,
                          )),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AudioPlayerPage(
                              player: player,
                              audioUrl: trackData['trackurl'],
                                poster: trackData['poster'],
                                songName: trackData['songname'],
                                artist: trackData['artistname'])));
                      },
                    ),
                  );
                },
                itemCount: trackDocs!.length);
          } else {
            return const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                ));
          }
        });
  }
}

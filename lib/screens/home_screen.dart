import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/widgets/greet_text.dart';
import 'package:spotify_clone/widgets/list_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AudioPlayer player = AudioPlayer();

  Future<void> updateTrackUrl() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Reference ref = storage.ref(); //cloud storage reference
    CollectionReference collectionReference =
        firestore.collection('tracks'); //firestore collection reference
    ListResult result = await ref.listAll();
    for (Reference item in result.items) {
      try {
        String downloadUrl = await item.getDownloadURL();
        String filename = item.name.split('.').first;
        await collectionReference
            .doc(filename)
            .update({'trackurl': downloadUrl});
      } catch (e) {
        print('Error updating urls');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    updateTrackUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.settings,
                      size: 30,
                    )
                  ],
                ),
              ),
              const GreetingText(),
              const SizedBox(
                height: 50,
              ),
              Text('Your Library',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              const Divider(thickness: 1.0,),
              SizedBox(height: 600, child: SongList(player: player,))
            ],
          ),
        ),
      ),
    );
  }
}

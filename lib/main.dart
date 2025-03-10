import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/audio_bloc/audio_bloc.dart';
import 'package:music_player/bloc/audio_bloc/audio_event.dart';
import 'package:music_player/screen/audio_play.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AudioPlayerBloc()..add(InitAudioEvent()),
        child: AudioPlayerScreen(),
      ),
    );
  }
}


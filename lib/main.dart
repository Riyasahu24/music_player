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
      home: BlocProvider(
        create: (context) => AudioPlayerBloc()..add(InitAudioEvent()),
        child: MyAppApp(),
      ),
    );
  }
}

// class MyAppApp extends StatefulWidget {
//   @override
//   _MyAppAppState createState() => _MyAppAppState();
// }

// class _MyAppAppState extends State<MyAppApp> {
//   final player = AudioPlayer();
//   Duration position = Duration.zero;
//   Duration duration = Duration.zero;

//   String formatDuration(Duration d) {
//     final minutes = d.inMinutes.remainder(60);
//     final seconds = d.inSeconds.remainder(60);
//     return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
//   }

//   void handlePlayPause() {
//     if (player.playing) {
//       player.pause();
//     } else {
//       player.play();
//     }
//   }

//   void handleSeek(double value) {
//     player.seek(Duration(seconds: value.toInt()));
//   }

//   @override
//   void initState() {
//     super.initState();
//     player.setUrl(
//       "https://codeskulptor-demos.commondatastorage.googleapis.com/descent/background%20music.mp3",
//     );

//     // listen to position update
//     player.positionStream.listen((p) {
//       setState(() {
//         position = p;
//       });
//     });

//     player.durationStream.listen((d) {
//       setState(() {
//         duration = d!;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Audio Player')),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Text(formatDuration(position)),
//             Slider(
//               value: position.inSeconds.toDouble(),
//               onChanged: handleSeek,
//               min: 0.0,
//               max: duration.inSeconds.toDouble(),
//             ),
//             Text(formatDuration(duration)),
//             IconButton(
//               onPressed: handlePlayPause,
//               icon: Icon(player.playing ? Icons.pause : Icons.play_arrow),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     player.dispose(); // Clean up resources
//     super.dispose();
//   }
// }

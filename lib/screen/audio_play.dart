import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/audio_bloc/audio_bloc.dart';
import 'package:music_player/bloc/audio_bloc/audio_event.dart';
import 'package:music_player/bloc/audio_bloc/audio_state.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
        builder: (context, state) {
          if (state is AudioPlayerLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AudioPlayerLoaded) {

            // Ensure we don't get null durations
            final maxDuration = state.duration;
            final elapsedDuration = state.position;

            // Placeholder samples — generate from actual audio data or pre-load
            final List<double> samples = List.generate(60, (index) {
              if (index % 10 == 0) {
                return 1.0; // Peak points
              } else if (index % 5 == 0) {
                return 0.8; // Slightly lower peaks
              } else if (index % 3 == 0) {
                return 0.6; // Mid-level waves
              } else if (index % 2 == 0) {
                return 0.4; // Lower points
              } else {
                return 0.1; // Base level
              }
            });
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Image.asset(
                    "assets/images/image.png",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * .6,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade900,
                          Colors.grey.shade300,
                        ], // Your two colors
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Instant Crush",
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "feat. Julian Casablancas",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade100,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Text(formatDuration(state.position)),
                          Column(
                            children: [
                              SizedBox(
                                height: 100,
                                child: RectangleWaveform(
                                  activeBorderColor: Colors.grey.shade300,
                                  isRoundedRectangle: true,
                                  maxDuration: maxDuration,
                                  elapsedDuration: elapsedDuration,
                                  samples: samples,
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  absolute: true,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey.shade500,
                                ),
                              ),

                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  formatDuration(state.duration),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap:
                                      () => context.read<AudioPlayerBloc>().add(
                                        PlayPauseEvent(),
                                      ),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      state.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 60,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AudioPlayerError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(child: Text('Initial State'));
          }
        },
      ),
    );
  }
}

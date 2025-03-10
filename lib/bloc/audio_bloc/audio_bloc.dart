import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/bloc/audio_bloc/audio_event.dart';
import 'package:music_player/bloc/audio_bloc/audio_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer player = AudioPlayer();
  

  AudioPlayerBloc() : super(AudioPlayerInitial()) {
    on<InitAudioEvent>(_onInitAudio);
    on<PlayPauseEvent>(_onPlayPause);
    on<SeekEvent>(_onSeek);
    on<UpdatePositionEvent>(_onUpdatePosition);
    on<UpdatePlayerStateEvent>(_onUpdatePlayerState);
  }

  Future<void> _onInitAudio(
      InitAudioEvent event, Emitter<AudioPlayerState> emit) async {
    emit(AudioPlayerLoading());
    try {
      await player.setUrl(
          "https://codeskulptor-demos.commondatastorage.googleapis.com/descent/background%20music.mp3");

      // Listen to position stream
      player.positionStream.listen((position) {
        add(UpdatePositionEvent(position));
      });

      // Listen to player state (playing/paused)
      player.playerStateStream.listen((playerState) {
        add(UpdatePlayerStateEvent(playerState.playing));
      });

            player.processingStateStream.listen((processingState) {
        if (processingState == ProcessingState.completed) {
          player.seek(Duration.zero); // Reset to start
          player.play(); // Auto-restart
        }
      });


      emit(AudioPlayerLoaded(
          position: Duration.zero,
          duration: player.duration ?? Duration.zero,
          isPlaying: false));
    } catch (e) {
      emit(AudioPlayerError(e.toString()));
    }
  }

  Future<void> _onPlayPause(
      PlayPauseEvent event, Emitter<AudioPlayerState> emit) async {
    if (state is AudioPlayerLoaded) {
      final currentState = state as AudioPlayerLoaded;
      if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }
      emit(AudioPlayerLoaded(
          position: player.position,
          duration: currentState.duration,
          isPlaying: player.playing));
    }
  }

  Future<void> _onSeek(SeekEvent event, Emitter<AudioPlayerState> emit) async {
    if (state is AudioPlayerLoaded) {
      final currentState = state as AudioPlayerLoaded;
      final newPosition = Duration(seconds: event.value.toInt());
      await player.seek(newPosition);
      emit(AudioPlayerLoaded(
          position: newPosition,
          duration: currentState.duration,
          isPlaying: currentState.isPlaying));
    }
  }

  void _onUpdatePosition(
      UpdatePositionEvent event, Emitter<AudioPlayerState> emit) {
    if (state is AudioPlayerLoaded) {
      final currentState = state as AudioPlayerLoaded;
      emit(AudioPlayerLoaded(
          position: event.position,
          duration: currentState.duration,
          isPlaying: currentState.isPlaying));
    }
  }

  void _onUpdatePlayerState(
      UpdatePlayerStateEvent event, Emitter<AudioPlayerState> emit) {
    if (state is AudioPlayerLoaded) {
      final currentState = state as AudioPlayerLoaded;
      emit(AudioPlayerLoaded(
          position: player.position,
          duration: currentState.duration,
          isPlaying: event.isPlaying));
    }
  }

  @override
  Future<void> close() {
    player.dispose();
    return super.close();
  }
}

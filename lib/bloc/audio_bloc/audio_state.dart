abstract class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerLoading extends AudioPlayerState {}

class AudioPlayerLoaded extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  AudioPlayerLoaded({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });
}

class AudioPlayerError extends AudioPlayerState {
  final String error;

  AudioPlayerError(this.error);
}

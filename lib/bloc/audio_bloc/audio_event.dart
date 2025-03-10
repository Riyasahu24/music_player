abstract class AudioPlayerEvent {}

class PlayPauseEvent extends AudioPlayerEvent {}

class SeekEvent extends AudioPlayerEvent {
  final double value;

  SeekEvent(this.value);
}

class InitAudioEvent extends AudioPlayerEvent {}

class UpdatePositionEvent extends AudioPlayerEvent {
  final Duration position;

  UpdatePositionEvent(this.position);
}

class UpdatePlayerStateEvent extends AudioPlayerEvent {
  final bool isPlaying;

  UpdatePlayerStateEvent(this.isPlaying);
}

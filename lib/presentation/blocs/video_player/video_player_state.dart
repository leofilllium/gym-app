import 'package:chewie/chewie.dart';
import 'package:equatable/equatable.dart';

abstract class VideoPlayerState extends Equatable {
  const VideoPlayerState();

  @override
  List<Object?> get props => [];
}

class VideoPlayerInitial extends VideoPlayerState {}

class VideoPlayerLoading extends VideoPlayerState {}

class VideoPlayerLoaded extends VideoPlayerState {
  final ChewieController chewieController;

  const VideoPlayerLoaded({required this.chewieController});

  @override
  List<Object?> get props => [chewieController];
}

class VideoPlayerError extends VideoPlayerState {
  final String message;

  const VideoPlayerError({required this.message});

  @override
  List<Object?> get props => [message];
}
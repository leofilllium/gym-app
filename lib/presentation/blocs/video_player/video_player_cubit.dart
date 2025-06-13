import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/localization/app_localization.dart';
import 'package:gym_app/presentation/blocs/video_player/video_player_state.dart';


class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final String videoUrl;
  final AppLocalization appLocalization;

  VideoPlayerCubit({required this.videoUrl, required this.appLocalization}) : super(VideoPlayerInitial()) {
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (videoUrl.isEmpty || !Uri.parse(videoUrl).isAbsolute) {
      emit(VideoPlayerError(message: appLocalization.getLocalizedText('videoInvalidUrl', 'en'))); // 'en' fallback
      return;
    }

    try {
      emit(VideoPlayerLoading());
      final Uri uri = Uri.parse(videoUrl);
      final encodedUrl = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path,
        queryParameters: uri.queryParameters,
      ).toString();

      _videoPlayerController = VideoPlayerController.network(encodedUrl);

      _videoPlayerController.addListener(_onVideoError);

      await _videoPlayerController.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutFailure(message: appLocalization.getLocalizedText('videoTimedOut', 'en')); // 'en' fallback
        },
      );

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF0A84FF),
          handleColor: const Color(0xFF0A84FF),
          backgroundColor: Colors.grey[300]!,
          bufferedColor: Colors.grey[600]!,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                Text(
                  '${appLocalization.getLocalizedText('videoErrorPrefix', 'en')}$errorMessage',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );
      emit(VideoPlayerLoaded(chewieController: _chewieController!));
    } on TimeoutFailure catch (e) {
      emit(VideoPlayerError(message: e.message));
    } catch (e) {
      emit(VideoPlayerError(message: '${appLocalization.getLocalizedText('videoErrorPrefix', 'en')}$e'));
    }
  }

  void _onVideoError() {
    if (_videoPlayerController.value.hasError && state is! VideoPlayerError) {
      emit(VideoPlayerError(message: '${appLocalization.getLocalizedText('videoErrorPrefix', 'en')}${_videoPlayerController.value.errorDescription}'));
    }
  }

  Future<void> retryInitialization() async {
    await close();
    _initializePlayer();
  }


  @override
  Future<void> close() {
    _videoPlayerController.removeListener(_onVideoError);
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    return super.close();
  }
}
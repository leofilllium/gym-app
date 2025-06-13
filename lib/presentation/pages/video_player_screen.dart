// lib/presentation/pages/video_player_screen.dart
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/core/localization/app_localization.dart';
import 'package:gym_app/presentation/blocs/video_player/video_player_cubit.dart';
import 'package:gym_app/presentation/blocs/video_player/video_player_state.dart';
import 'package:gym_app/service_locator.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String title;
  final String videoUrl;
  final String language;

  const VideoPlayerScreen({
    Key? key,
    required this.title,
    required this.videoUrl,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VideoPlayerCubit>(param1: videoUrl),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
          builder: (context, state) {
            if (state is VideoPlayerLoading) {
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 14,
                  color: Color(0xFF0A84FF),
                ),
              );
            } else if (state is VideoPlayerError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFF0A84FF),
                        size: 48,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        state.message,
                        style: const TextStyle(
                          color: Color(0xFF0A84FF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<VideoPlayerCubit>().retryInitialization();
                        },
                        child: Text(sl<AppLocalization>().getLocalizedText('videoRetryButton', language)),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is VideoPlayerLoaded) {
              return Center(
                child: AspectRatio(
                  aspectRatio: state.chewieController.videoPlayerController.value.aspectRatio,
                  child: Chewie(controller: state.chewieController),
                ),
              );
            }
            return Center(child: Text(sl<AppLocalization>().getLocalizedText('videoFailedToLoad', language)));
          },
        ),
      ),
    );
  }
}
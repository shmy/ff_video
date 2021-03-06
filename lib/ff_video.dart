import 'package:ff_video/plugins/screen.dart';
import 'package:ff_video/video_view.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

export 'package:video_player/video_player.dart';

typedef VideoControlBuilder = Widget Function(VideoPlayerController controller);

class FFVideo extends StatefulWidget {
  final VideoPlayerController? controller;
  final VideoControlBuilder? controlBuilder;
  final double aspectRatio;

  const FFVideo({
    Key? key,
    this.controller,
    this.controlBuilder, this.aspectRatio = 16 / 9,
  }) : super(key: key);

  @override
  _FFVideoState createState() => _FFVideoState();
}

class _FFVideoState extends State<FFVideo> {
  VideoPlayerController? get videoPlayerController => widget.controller;

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        color: Colors.black,
        child: VideoView(
          controller: videoPlayerController,
          control: widget.controlBuilder != null
              ? widget.controlBuilder!(videoPlayerController!)
              : Container(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController?.pause();
    videoPlayerController?.dispose();
    Screen.keepOn(false);
  }
}

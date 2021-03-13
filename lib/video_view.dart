import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoView extends StatefulWidget {
  final VideoPlayerController? controller;
  final Widget? control;

  const VideoView({Key? key, this.controller, this.control}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: widget.controller != null
              ? Center(
                  child: AspectRatio(
                    aspectRatio: widget.controller!.value.aspectRatio,
                    child: VideoPlayer(widget.controller!),
                  ),
                )
              : Container(
                  color: Colors.black,
                ),
        ),
        Positioned.fill(
          child: Visibility(
            visible: widget.control != null,
            child: widget.control ?? Container(),
          ),
        ),
      ],
    );
  }
}

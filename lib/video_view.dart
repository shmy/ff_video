import 'package:ff_video/interfaces/video_control_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final VideoPlayerController controller;
  final VideoControlWidget control;

  const VideoView({Key key, this.controller, this.control}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  double _aspectRatio = 1.0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant VideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _init() {
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _aspectRatio = widget.controller.value.aspectRatio;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: widget.controller != null
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _aspectRatio,
                    child: VideoPlayer(widget.controller),
                  ),
                )
              : Container(
                  color: Colors.black,
                ),
        ),
        Positioned.fill(
          child: widget.control ??
              Container(
                height: 0,
                width: 0,
              ),
        ),
      ],
    );
  }
}

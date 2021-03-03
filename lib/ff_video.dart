import 'package:ff_video/interfaces/video_control_widget.dart';
import 'package:ff_video/video_view.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

export 'package:video_player/video_player.dart';
class FFVideo extends StatefulWidget {
  final String url;
  final VideoControlWidget control;
  final double aspectRatio;
  final bool autoPlay;
  final bool looping;
  final ValueChanged<VideoPlayerController> onReceiveController;

  const FFVideo({
    Key key,
    @required this.url,
    this.control,
    this.aspectRatio = 16 / 9,
    this.autoPlay = false,
    this.looping = false,
    this.onReceiveController,
  }) : super(key: key);

  @override
  _FFVideoState createState() => _FFVideoState();
}

class _FFVideoState extends State<FFVideo> {
  VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        color: Colors.black,
        child: VideoView(
          controller: controller,
          control: widget.control,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _setUpPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    Screen.keepOn(false);
    controller?.pause();
    controller?.dispose();
    controller = null;
  }

  @override
  void didUpdateWidget(FFVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.control != widget.control) {
      _setUpPlayer();
    }
    if (oldWidget.looping != widget.looping) {
      controller?.setLooping(widget.looping);
    }
  }

  void _setUpPlayer() {
    if (widget.url == "") {
      return;
    }
    controller?.pause();
    controller?.dispose();
    controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        if (widget.autoPlay) {
          controller.play();
        }
        if (widget.looping) {
          controller.setLooping(widget.looping);
        }
      });
    widget.onReceiveController?.call(controller);
    setState(() {
      widget.control.controller.value = controller;
    });
  }
}

import 'package:ff_video/interfaces/video_control_widget.dart';
import 'package:ff_video/video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

mixin VideoControlMixin<T extends VideoControlWidget> on State<T> {
  VideoPlayerController get controller => widget.controller.value;
  double _brightness = 0.0;

  bool get isFullscreen => widget.isFullscreen.value;

  bool get isBuffering => controller?.value?.isBuffering ?? false;

  bool get isPlaying => controller?.value?.isPlaying ?? false;

  bool get hasError => controller?.value?.hasError ?? false;

  bool get initialized => controller?.value?.initialized ?? false;

  bool get isEnded => position == duration && duration != 0.0;

  double get playbackSpeed => controller?.value?.playbackSpeed;

  double get volume => controller?.value?.volume;

  double get brightness => _brightness;

  double get duration =>
      controller?.value?.duration?.inSeconds?.toDouble() ?? 0;

  double get position {
    double position = controller?.value?.position?.inSeconds?.toDouble() ?? 0;
    if (position >= duration) {
      return duration;
    }
    return position;
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _init() async {
    controller?.addListener(_listener);
    double brightness = await Screen.brightness;
    setState(() {
      _brightness = brightness;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(VideoControlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.value?.removeListener(_listener);
      _init();
    }
  }

  Future<void> enterFullscreen() async {
    if (isFullscreen) {
      return;
    }
    setState(() {
      widget.isFullscreen.value = true;
    });
    await Future.wait([
      // 隐藏状态栏和底部栏
      SystemChrome.setEnabledSystemUIOverlays([]),
      // 设置横屏
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]),
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Material(
            color: Colors.transparent,
            child: VideoView(
              controller: controller,
              control: widget,
            ),
          ),
        ),
      )
    ]);
  }

  Future<void> exitFullscreen() async {
    if (!isFullscreen) {
      return;
    }
    setState(() {
      widget.isFullscreen.value = false;
    });
    Navigator.pop(context);
    await Future.wait([
      // 显示状态栏和底部栏
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]),
      // 返回竖屏
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    ]);
  }

  Future<void> toggleFullscreen(bool isFullscreen) async {
    if (isFullscreen) {
      enterFullscreen();
    } else {
      exitFullscreen();
    }
  }

  Future<void> play() async {
    await controller?.play();
  }

  Future<void> pause() async {
    await controller?.pause();
  }

  Future<void> togglePlay(bool isPlay) async {
    if (isPlay) {
      play();
    } else {
      pause();
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await controller?.setPlaybackSpeed(speed);
  }

  Future<void> seekTo(num seconds) async {
    print('seekTo $seconds');
    await controller?.seekTo(Duration(seconds: seconds.toInt()));
  }

  Future<void> setVolume(double volume) async {
    await controller?.setVolume(volume);
  }

  Future<void> setBrightness(double brightness) async {
    setState(() {
      _brightness = brightness;
    });
    await Screen.setBrightness(brightness);
  }
}

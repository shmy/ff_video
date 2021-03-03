import 'package:ff_video/interfaces/video_control_widget.dart';
import 'package:ff_video/video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

mixin VideoControlMixin<T extends VideoControlWidget> on State<T> {
  VideoPlayerController get videoPlayerController => widget.controller.value;
  double _brightness = 0.0;
  VideoPlayerValue _value;

  VideoPlayerValue get value => _value;

  bool get isFullscreen => widget.isFullscreen.value;

  bool get isLocked => widget.isLocked.value;

  bool get isBuffering => value?.isBuffering ?? false;

  bool get isPlaying => value?.isPlaying ?? false;

  bool get hasError => value?.hasError ?? false;

  bool get initialized => value?.initialized ?? false;

  bool get isEnded => position == duration && duration != 0.0;

  double get playbackSpeed => value?.playbackSpeed;

  double get volume => value?.volume;

  double get brightness => _brightness;

  double get duration => value?.duration?.inSeconds?.toDouble() ?? 0;

  double get position {
    double position = value?.position?.inSeconds?.toDouble() ?? 0;
    if (position >= duration) {
      return duration;
    }
    return position;
  }

  void _listener() {
    if (mounted) {
      setState(() {
        _value = videoPlayerController.value;
      });
    }
  }

  Future<void> _setup() async {
    videoPlayerController?.removeListener(_listener);
    videoPlayerController?.addListener(_listener);
    double brightness = await Screen.brightness;
    setState(() {
      _brightness = brightness;
    });
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void didUpdateWidget(VideoControlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _setup();
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
              controller: videoPlayerController,
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
  void toggleLocked(bool locked) async {
    if (locked) {
      setLocked();
    } else {
      setUnLocked();
    }
  }
  void setLocked() {
    setState(() {
      widget.isLocked.value = true;
    });
  }
  void setUnLocked() {
    setState(() {
      widget.isLocked.value = false;
    });
  }
  Future<void> play() async {
    await videoPlayerController?.play();
  }

  Future<void> pause() async {
    await videoPlayerController?.pause();
  }

  Future<void> togglePlay(bool isPlay) async {
    if (isPlay) {
      play();
    } else {
      pause();
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await videoPlayerController?.setPlaybackSpeed(speed);
  }

  Future<void> seekTo(num seconds) async {
    print('seekTo $seconds');
    await videoPlayerController?.seekTo(Duration(seconds: seconds.toInt()));
  }

  Future<void> setVolume(double volume) async {
    await videoPlayerController?.setVolume(volume);
  }

  Future<void> setBrightness(double brightness) async {
    setState(() {
      _brightness = brightness;
    });
    await Screen.setBrightness(brightness);
  }
}

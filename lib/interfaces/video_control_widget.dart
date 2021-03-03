import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class _ValueWrap<T> {
  T value;

  _ValueWrap({@required this.value});
}

abstract class VideoControlWidget extends StatefulWidget {
  final _ValueWrap<VideoPlayerController> controller = _ValueWrap(value: null);
  final _ValueWrap<bool> isFullscreen = _ValueWrap(value: false);
  // VideoPlayerController controller;
  // bool isFullscreen = false;

  VideoControlWidget({Key key}) : super(key: key);
}

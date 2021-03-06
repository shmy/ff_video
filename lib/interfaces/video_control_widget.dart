import 'package:ff_video/ff_video.dart';
import 'package:flutter/material.dart';

class _ValueWrap<T> {
  T? value;

  _ValueWrap({this.value});
}

// fix @immutable
abstract class VideoControlWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final _ValueWrap<bool> isFullscreen = _ValueWrap(value: false);
  final _ValueWrap<bool> isLocked = _ValueWrap(value: false);

  VideoControlWidget({Key? key, required this.controller}) : super(key: key);
}

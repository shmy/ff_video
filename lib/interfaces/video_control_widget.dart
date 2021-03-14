import 'package:ff_video/ff_video.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class VideoControlWidget extends StatefulWidget {
  final VideoPlayerController controller;
  bool isFullscreen = false;
  bool isLocked = false;

  VideoControlWidget({Key? key, required this.controller}) : super(key: key);
}

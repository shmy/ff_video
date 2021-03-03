import 'dart:async';
import 'package:ff_video/controls/tencent_video/widgets/body.dart';
import 'package:ff_video/interfaces/video_control_widget.dart';
import 'package:ff_video/mixins/video_control_mixin.dart';
import 'package:ff_video/util.dart';
import 'package:flutter/material.dart';

part './widgets/header.dart';

part './widgets/footer.dart';

typedef SizeTransformCallback = double Function(double);

class TencentVideoControl extends VideoControlWidget {
  final Widget title;
  final Widget thumbnail;
  final SizeTransformCallback sizeTransformCallback;

  TencentVideoControl({
    Key key,
    this.title,
    this.thumbnail,
    this.sizeTransformCallback,
  }) : super(key: key);

  @override
  _TencentVideoControlState createState() => _TencentVideoControlState();
}

class _TencentVideoControlState extends State<TencentVideoControl>
    with VideoControlMixin, SingleTickerProviderStateMixin {
  Timer _timer;
  AnimationController _animationController;
  Animation<double> _tweenAnimation;
  SizeTransformCallback get sizeTransformCallback => widget.sizeTransformCallback ?? (double size) => size;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _tweenAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
    _animationController = null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: _toggleMask,
        onDoubleTap: () {
          if (isPlaying) {
            pause();
          } else {
            play();
          }
        },
        child: Container(
          color: Colors.transparent,
          child: ClipRRect(
            child: initialized ? _buildControl() : widget.thumbnail,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (isFullscreen) {
      await exitFullscreen();
      return false;
    }
    return true;
  }

  void _toggleMask() {
    _timer?.cancel();
    if (_animationController.status == AnimationStatus.dismissed) {
      _animationController?.forward();
    } else {
      _animationController?.reverse();
    }
    _startHideMask();
  }

  void _startHideMask() {
    _timer = Timer(Duration(seconds: 3), () {
      if (_animationController == null) {
        return;
      }
      _animationController?.reverse();
    });
  }

  Widget _buildControl() {
    return Column(
      children: [
        _Header(
          animation: _tweenAnimation,
          title: widget.title,
        ),
        Expanded(
          child: Body(
            builder: _buildCenter,
            position: position,
            duration: duration,
            onPositionChange: seekTo,
            brightness: brightness,
            onBrightnessChange: setBrightness,
            volume: volume,
            onVolumeChange: setVolume,
          ),
        ),
        _wrapListener(
          child: _Footer(
            position: position,
            duration: duration,
            isPlaying: isPlaying,
            isFullscreen: isFullscreen,
            animation: _tweenAnimation,
            onFullscreenModeChange: toggleFullscreen,
            onSliderChange: seekTo,
            onStatusChange: togglePlay,
          ),
        ),
      ],
    );
  }

  Widget _buildCenter(BuildContext context) {
    Widget result = Container();
    if (hasError) {
      result = GestureDetector(
        onTap: () {
          seekTo(0);
          play();
        },
        child: Icon(
          Icons.error,
          color: Colors.white,
          size: 40,
        ),
      );
    } else if (isEnded) {
      result = GestureDetector(
        onTap: () {
          seekTo(0);
          play();
        },
        child: Icon(
          Icons.replay,
          color: Colors.white,
          size: 40,
        ),
      );
    } else if (!isPlaying) {
      result = GestureDetector(
        onTap: () {
          play();
          _toggleMask();
        },
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 40,
        ),
      );
    } else if (isBuffering) {
      result = SizedBox(
        height: 26,
        width: 26,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );
    }
    return Container(
      child: Center(
        child: result,
      ),
    );
  }

  Widget _wrapListener({Widget child}) {
    return Listener(
      onPointerDown: (details) {
        _timer?.cancel();
      },
      onPointerUp: (details) {
        _startHideMask();
      },
      onPointerCancel: (details) {
        _startHideMask();
      },
      child: child,
    );
  }
}

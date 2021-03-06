import 'dart:async';
import 'package:ff_video/interfaces/video_control_widget.dart';
import 'package:ff_video/mixins/video_control_mixin.dart';
import 'package:ff_video/util.dart';
import 'package:flutter/material.dart';

part './widgets/header.dart';

part './widgets/body.dart';

part './widgets/footer.dart';

part './widgets/lock_view.dart';

typedef SizeTransformCallback = double Function(double);

class TencentVideoControl extends VideoControlWidget {
  final Widget? title;
  final Widget? action;
  final String? thumbnailUrl;
  final SizeTransformCallback? sizeTransformCallback;

  TencentVideoControl({
    Key? key,
    this.title,
    this.thumbnailUrl,
    this.sizeTransformCallback,
    this.action,
  }) : super(key: key);

  @override
  _TencentVideoControlState createState() => _TencentVideoControlState();
}

class _TencentVideoControlState extends State<TencentVideoControl>
    with VideoControlMixin, SingleTickerProviderStateMixin {
   Timer? _timer;
  late AnimationController? _animationController;
  late Animation<double> _tweenAnimation;
  double animationDouble = 0;

  SizeTransformCallback get sizeTransformCallback =>
      widget.sizeTransformCallback ?? (double size) => size;

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
        parent: _animationController!,
        curve: Curves.fastOutSlowIn,
      ),
    )..addListener(() {
        setState(() {
          animationDouble = _tweenAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GestureDetector(
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
          child: (initialized || isFullscreen) ? _buildControl() : _buildThumbnail(),
        ),
      ),
    );
    if (!isFullscreen) {
      return content;
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: content,
    );
  }

  Future<bool> _onWillPop() async {
    if (isFullscreen && !isLocked) {
      await exitFullscreen();
    }
    return false;
  }

  void _toggleMask() {
      _timer?.cancel();
    if (animationDouble == 0) {
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
        _wrapListener(
          child: Visibility(
            visible: !isLocked,
            child: _Header(
              animation: animationDouble,
              title: widget.title,
              action: widget.action,
              sizeTransformCallback: sizeTransformCallback,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: _Body(
                  builder: _buildCenter,
                  mixin: this,
                  sizeTransformCallback: sizeTransformCallback,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Center(
                  child: _wrapListener(
                    child: _LockView(
                      mixin: this,
                      animation: animationDouble,
                      sizeTransformCallback: sizeTransformCallback,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _wrapListener(
          child: Visibility(
            visible: !isLocked,
            child: _Footer(
              mixin: this,
              animation: animationDouble,
              sizeTransformCallback: sizeTransformCallback,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.network(
            widget.thumbnailUrl ?? '',
            fit: BoxFit.cover,
          ).image,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(
            sizeTransformCallback(10),
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, .7),
            borderRadius: BorderRadius.all(
              Radius.circular(sizeTransformCallback(5)),
            ),
          ),
          child: SizedBox(
            height: sizeTransformCallback(22),
            width: sizeTransformCallback(22),
            child: CircularProgressIndicator(
              strokeWidth: sizeTransformCallback(2),
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
      ),
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
          size: sizeTransformCallback(40),
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
          size: sizeTransformCallback(40),
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
          size: sizeTransformCallback(40),
        ),
      );
    } else if (isBuffering) {
      result = SizedBox(
        height: sizeTransformCallback(26),
        width: sizeTransformCallback(26),
        child: CircularProgressIndicator(
          strokeWidth: sizeTransformCallback(2),
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

  Widget _wrapListener({required Widget child}) {
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

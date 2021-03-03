import 'package:ff_video/mixins/video_control_mixin.dart';
import 'package:ff_video/util.dart';
import 'package:flutter/material.dart';

typedef AsyncValueChanged<T> = Future<void> Function(T value);

class Body extends StatefulWidget {
  final WidgetBuilder builder;
  final VideoControlMixin mixin;

  const Body({
    Key key,
    this.builder,
    this.mixin,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double _dx = 0;
  double _dy = 0;
  double _startX = 0;
  double _newPosition = 0;
  String _popMessage;

  Size get size => MediaQuery.of(context).size;

  VideoControlMixin get mixin => widget.mixin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: widget.builder(context),
            ),
            Positioned.fill(
              child: _buildPopArea(),
            ),
          ],
        ),
      ),
    );
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _startX = details.globalPosition.dx;
  }

  // TODO: debonce
  void _onVerticalDragUpdate(DragUpdateDetails details) async {
    _dy += -details.delta.dy;
    bool isLeft = _startX < size.width / 2;
    double value = double.parse(
        (_dy / size.height + (isLeft ? mixin.brightness : mixin.volume))
            .toStringAsFixed(2));
    if (value >= 1.0) {
      value = 1.0;
    } else if (value <= 0.0) {
      value = 0.0;
    }
    if (isLeft) {
      _showPopMessage('亮度: ${_formatPercentage(mixin.brightness)}');
      await mixin.setBrightness?.call(value);
    } else {
      _showPopMessage('音量: ${_formatPercentage(mixin.volume)}');
      await mixin.setVolume?.call(value);
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _dy = 0;
    setState(() {
      _popMessage = null;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dx += details.delta.dx;
    double position = mixin.position + _dx;
    if (position < 0) {
      position = 0;
    }
    if (position > mixin.duration) {
      position = mixin.duration;
    }
    _newPosition = position;
    _showPopMessage(
        '${_dx < 0 ? '-' : '+'}${Util.formatTime(_dx)}\n${Util.formatTime(position)}');
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    mixin.seekTo?.call(_newPosition);
    _dx = 0;
    _newPosition = 0;
    setState(() {
      _popMessage = null;
    });
  }

  String _formatPercentage(double value) {
    return (value * 100).toInt().toString() + '%';
  }

  void _showPopMessage(String message) {
    setState(() {
      _popMessage = message;
    });
  }

  Widget _buildPopArea() {
    return Visibility(
      visible: _popMessage != null,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.7),
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Text(
            _popMessage ?? '',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

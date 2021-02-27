import 'package:ff_video/util.dart';
import 'package:flutter/material.dart';

typedef AsyncValueChanged<T> = Future<void> Function(T value);

class Body extends StatefulWidget {
  final WidgetBuilder builder;
  final double position;
  final double duration;
  final double volume;
  final double brightness;
  final AsyncValueChanged<double> onVolumeChange;
  final AsyncValueChanged<double> onBrightnessChange;
  final ValueChanged<double> onPositionChange;

  const Body(
      {Key key,
      this.builder,
      this.volume,
      this.onVolumeChange,
      this.brightness,
      this.onBrightnessChange, this.position, this.duration, this.onPositionChange})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd:  _onVerticalDragEnd,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
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
        (_dy / size.height + (isLeft ? widget.brightness : widget.volume))
            .toStringAsFixed(2));
    if (value >= 1.0) {
      value = 1.0;
    } else if (value <= 0.0) {
      value = 0.0;
    }
    if (isLeft) {
      _showPopMessage('亮度: ${_formatPercentage(widget.brightness)}');
      await widget.onBrightnessChange?.call(value);
    } else {
      _showPopMessage('音量: ${_formatPercentage(widget.volume)}');
      await widget.onVolumeChange?.call(value);
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
    double position = widget.position + _dx;
    if (position < 0) {
      position = 0;
    }
    if (position > widget.duration) {
      position = widget.duration;
    }
    _newPosition = position;
    _showPopMessage('${_dx < 0 ? '-' : '+'}${Util.formatTime(_dx)}\n${Util.formatTime(position)}');

  }
  void _onHorizontalDragEnd(DragEndDetails details) {
    widget.onPositionChange?.call(_newPosition);
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
    if (_popMessage == null) {
      return Container();
    }
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.7),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Text(
          _popMessage,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

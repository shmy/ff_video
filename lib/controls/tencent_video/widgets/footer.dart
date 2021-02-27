part of '../tencent_video_control.dart';

class _Footer extends StatefulWidget {
  final double position;
  final double duration;
  final bool isPlaying;
  final bool isFullscreen;
  final Animation<double> animation;
  final ValueChanged<double> onSliderChange;
  final ValueChanged<bool> onStatusChange;
  final ValueChanged<bool> onFullscreenModeChange;

  const _Footer(
      {Key key,
      this.position,
      this.duration,
      this.onSliderChange,
      this.isPlaying,
      this.onStatusChange,
      this.onFullscreenModeChange,
      this.isFullscreen,
      this.animation})
      : super(key: key);

  @override
  __FooterState createState() => __FooterState();
}

class __FooterState extends State<_Footer> {
  final TextStyle style = TextStyle(fontSize: 12, color: Colors.white);
  final double height = 30.0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, height - (widget.animation?.value ?? 0) * height),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white24,
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                widget.onStatusChange?.call(!widget.isPlaying);
              },
              child: Icon(
                widget.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            Text(
              Util.formatTime(widget.position),
              style: style,
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white54,
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 2.0,
                  thumbColor: Colors.orange,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
                  overlayColor: Colors.orange,
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 6.0),
                ),
                child: Slider(
                  value: widget.position,
                  max: widget.duration,
                  onChanged: (double value) {
                    widget.onSliderChange?.call(value);
                  },
                ),
              ),
            ),
            Text(
              Util.formatTime(widget.duration),
              style: style,
            ),
            GestureDetector(
              onTap: () {
                widget.onFullscreenModeChange?.call(!widget.isFullscreen);
              },
              child: Icon(
                !widget.isFullscreen ? Icons.fullscreen : Icons.fullscreen_exit,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

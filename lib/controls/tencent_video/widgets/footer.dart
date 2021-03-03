part of '../tencent_video_control.dart';

class _Footer extends StatefulWidget {
  final VideoControlMixin mixin;
  final double animation;

  const _Footer({
    Key key,
    this.mixin,
    this.animation,
  }) : super(key: key);

  @override
  __FooterState createState() => __FooterState();
}

class __FooterState extends State<_Footer> {
  final TextStyle style = TextStyle(fontSize: 12, color: Colors.white);
  final double height = 30.0;
  VideoControlMixin get mixin => widget.mixin;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, height - (widget.animation ?? 0) * height),
      child: Container(
        height: height,
        padding: EdgeInsets.zero,
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
                mixin.togglePlay?.call(!mixin.isPlaying);
              },
              child: Icon(
                mixin.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            Text(
              Util.formatTime(mixin.position),
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
                  value: mixin.position,
                  max: mixin.duration,
                  onChanged: (double value) {
                    mixin.seekTo?.call(value);
                  },
                ),
              ),
            ),
            Text(
              Util.formatTime(mixin.duration),
              style: style,
            ),
            GestureDetector(
              onTap: () {
                mixin.toggleFullscreen?.call(!mixin.isFullscreen);
              },
              child: Icon(
                !mixin.isFullscreen ? Icons.fullscreen : Icons.fullscreen_exit,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

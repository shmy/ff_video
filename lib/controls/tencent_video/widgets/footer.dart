part of '../tencent_video_control.dart';

class _Footer extends StatelessWidget {
  final VideoControlMixin mixin;
  final double animation;
  final SizeTransformCallback sizeTransformCallback;

  const _Footer({
    Key key,
    this.mixin,
    this.animation,
    this.sizeTransformCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        TextStyle(fontSize: sizeTransformCallback(12), color: Colors.white);
    final double height = sizeTransformCallback(30);

    return Transform.translate(
      offset: Offset(0, height - (animation ?? 0) * height),
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
                size: sizeTransformCallback(22),
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
                  trackHeight: sizeTransformCallback(2),
                  thumbColor: Colors.orange,
                  thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: sizeTransformCallback(4)),
                  overlayColor: Colors.orange,
                  overlayShape: RoundSliderOverlayShape(
                      overlayRadius: sizeTransformCallback(6)),
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
                size: sizeTransformCallback(22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

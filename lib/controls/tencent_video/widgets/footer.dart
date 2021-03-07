part of '../tencent_video_control.dart';

class _Footer extends StatelessWidget {
  final VideoControlMixin mixin;
  final double animation;
  final SizeTransformCallback sizeTransformCallback;

  const _Footer({
    Key? key,
    required this.mixin,
    required this.animation,
    required this.sizeTransformCallback,
  }) : super(key: key);

  double get bufferedRatio {
    if (mixin.buffered.length == 0) {
      return 0;
    }
    int bufferedSeconds = mixin.buffered[0].end.inSeconds;
    return bufferedSeconds / mixin.duration;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        TextStyle(fontSize: sizeTransformCallback(12), color: Colors.white);
    final double height = sizeTransformCallback(30);
    return Transform.translate(
      offset: Offset(0, height - animation * height),
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
                mixin.togglePlay.call(!mixin.isPlaying);
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sizeTransformCallback(7),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          height: sizeTransformCallback(2),
                          width: double.infinity,
                          color: Colors.white30,
                          // color: Colors.red,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          height: sizeTransformCallback(2),
                          color: Colors.transparent,
                          width: double.infinity,
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: bufferedRatio,
                            child: Container(
                              color: Colors.white60,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.transparent,
                          trackShape: CustomTrackShape(),
                          trackHeight: sizeTransformCallback(1),
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
                            mixin.seekTo.call(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              Util.formatTime(mixin.duration),
              style: style,
            ),
            Visibility(
              visible: !mixin.isFullscreen && !mixin.isLocked,
              child: GestureDetector(
                onTap: mixin.enterFullscreen,
                child: Icon(
                  !mixin.isFullscreen ? Icons.fullscreen : Icons.fullscreen_exit,
                  color: Colors.white,
                  size: sizeTransformCallback(22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  // final double trackHeight;
  // CustomTrackShape({this.trackHeight});
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

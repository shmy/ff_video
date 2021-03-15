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
        TextStyle(fontSize: sizeTransformCallback(14), color: Colors.white);
    final double height = sizeTransformCallback(32);
    final double iconSize = sizeTransformCallback(28);
    return Transform.translate(
      offset: Offset(0, height - animation * height),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: sizeTransformCallback(5),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white24,
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
                size: iconSize,
              ),
            ),
            Text(
              FFVideoUtil.formatTime(mixin.position),
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
                          trackHeight: sizeTransformCallback(1.2),
                          thumbColor: Colors.orange,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: sizeTransformCallback(5),
                            elevation: 0,
                            pressedElevation: 0,
                          ),
                          overlayColor: Colors.orange,
                          overlayShape: RoundSliderOverlayShape(
                              overlayRadius: sizeTransformCallback(5)),
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
              FFVideoUtil.formatTime(mixin.duration),
              style: style,
            ),
            GestureDetector(
              onTap: () {
                mixin.showPopover(
                  (BuildContext context) => PlaySpeedWidget(
                    playbackSpeed: mixin.playbackSpeed,
                    onChange: (v) => mixin.setPlaybackSpeed(v),
                    sizeTransformCallback: sizeTransformCallback,
                  ),
                );
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: sizeTransformCallback(5)),
                child: Text(
                  '${mixin.playbackSpeed}x',
                  style: style.copyWith(
                    fontSize: sizeTransformCallback(16),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !mixin.isFullscreen && !mixin.isLocked,
              child: GestureDetector(
                onTap: mixin.enterFullscreen,
                child: Icon(
                  !mixin.isFullscreen
                      ? Icons.fullscreen
                      : Icons.fullscreen_exit,
                  color: Colors.white,
                  size: iconSize,
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

class PlaySpeedWidget extends StatelessWidget {
  final double playbackSpeed;
  final ValueChanged<double> onChange;
  final SizeTransformCallback sizeTransformCallback;

  const PlaySpeedWidget(
      {Key? key,
      required this.playbackSpeed,
      required this.onChange,
      required this.sizeTransformCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlaySpeed();
  }

  Widget _buildPlaySpeed() {
    return Container(
      height: double.infinity,
      width: 100,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      padding: EdgeInsets.zero,
      child: ListView(
        children: [
          _buildPlaySpeedItem(0.5),
          _buildPlaySpeedItem(0.75),
          _buildPlaySpeedItem(1),
          _buildPlaySpeedItem(1.25),
          _buildPlaySpeedItem(1.5),
          _buildPlaySpeedItem(2.0),
          _buildPlaySpeedItem(3.0),
        ],
      ),
    );
  }

  Widget _buildPlaySpeedItem(double speed) {
    final isSelected = speed.toDouble() == playbackSpeed;
    final TextStyle style = TextStyle(
      fontSize: sizeTransformCallback(16),
      color: Colors.white,
    );
    return GestureDetector(
      onTap: () {
        onChange(speed);
      },
      child: Container(
        height: sizeTransformCallback(48),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                width: sizeTransformCallback(1),
                color: isSelected ? Colors.deepOrange : Colors.transparent)),
        child: Center(
            child: Text(
          speed.toString(),
          style: style,
        )),
      ),
    );
  }
}

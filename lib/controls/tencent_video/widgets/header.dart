part of '../tencent_video_control.dart';

class _Header extends StatelessWidget {
  final Widget? title;
  final Widget? action;
  final VideoControlMixin mixin;
  final double animation;
  final SizeTransformCallback sizeTransformCallback;

  const _Header(
      {Key? key,
      this.title,
      required this.animation,
      required this.sizeTransformCallback,
      this.action,
      required this.mixin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = sizeTransformCallback(30);
    final double iconSize = sizeTransformCallback(28);
    return Transform.translate(
      offset: Offset(0, (animation - 1) * height),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: sizeTransformCallback(5),
        ),
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.transparent,
                Colors.white24,
              ]),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (mixin.isFullscreen) {
                  mixin.exitFullscreen();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            Expanded(
              child: Visibility(
                visible: title != null,
                child: title ?? Container(),
              ),
            ),
            Visibility(
              visible: action != null,
              child: action ?? Container(),
            ),
          ],
        ),
      ),
    );
  }
}

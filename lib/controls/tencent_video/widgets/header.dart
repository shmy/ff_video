part of '../tencent_video_control.dart';

class _Header extends StatelessWidget {
  final Widget title;
  final double animation;
  final SizeTransformCallback sizeTransformCallback;

  const _Header(
      {Key key, this.title, this.animation, this.sizeTransformCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = sizeTransformCallback(30);
    return Transform.translate(
      offset: Offset(0, ((animation ?? 0) - 1) * height),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: sizeTransformCallback(5),
        ),
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white24,
                Colors.transparent,
              ]),
        ),
        alignment: Alignment.centerLeft,
        child: Visibility(
          visible: title != null,
          child: title,
        ),
      ),
    );
  }
}

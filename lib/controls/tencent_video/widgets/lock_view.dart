part of '../tencent_video_control.dart';

class _LockView extends StatelessWidget {
  final double animation;
  final VideoControlMixin mixin;
  final SizeTransformCallback sizeTransformCallback;

  const _LockView(
      {Key? key, required this.animation, required this.mixin, required this.sizeTransformCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = sizeTransformCallback(34);
    final dist = size + sizeTransformCallback(5);
    return GestureDetector(
      onTap: () {
        bool newState = !mixin.isLocked;
        mixin.toggleLocked(newState);
      },
      child: Transform.translate(
        offset: Offset(animation * dist - size, 0),
        child: Icon(
          mixin.isLocked ? IconFonts.iconSuoding : IconFonts.iconJihuohuoqijiesuo,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}

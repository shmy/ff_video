part of '../tencent_video_control.dart';

class _LockView extends StatelessWidget {
  final double animation;
  final VideoControlMixin mixin;
  final SizeTransformCallback sizeTransformCallback;

  const _LockView(
      {Key key, this.animation, this.mixin, this.sizeTransformCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = sizeTransformCallback(22);
    final dist = size + sizeTransformCallback(5);
    return GestureDetector(
      onTap: () {
        bool newState = !mixin.isLocked;
        mixin.toggleLocked(newState);
      },
      child: Transform.translate(
        offset: Offset((animation ?? 0) * dist - size, 0),
        child: Icon(
          mixin.isLocked ? Icons.lock : Icons.lock_open,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}

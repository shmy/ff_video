part of '../tencent_video_control.dart';

class _LockView extends StatelessWidget {
  final double animation;
  final VideoControlMixin mixin;
  final double size = 22;
  const _LockView({Key key, this.animation, this.mixin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dist = size + 5;
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

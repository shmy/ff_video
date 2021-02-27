part of '../tencent_video_control.dart';

class _Header extends StatefulWidget {
  final Widget title;
  final Animation<double> animation;

  const _Header({Key key, this.title, this.animation})
      : super(key: key);

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  final double height = 30.0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, ((widget.animation?.value ?? 0) - 1) * height),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: 5,
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
        child: widget.title ?? Container(),
      ),
    );
  }
}

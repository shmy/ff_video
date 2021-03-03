import 'package:ff_video/controls/tencent_video/tencent_video_control.dart';
import 'package:ff_video/ff_video.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  final String url;
  final String title;

   VideoPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          FFVideo(
            url: widget.url,
            autoPlay: true,
            onReceiveController: (controller) {
              this.controller = controller;
            },
            control: TencentVideoControl(
              thumbnailUrl: 'http://img.mp.itc.cn/upload/20170326/39eaf2c41cfb46fe98982670af385a64_th.jpeg',
              title: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

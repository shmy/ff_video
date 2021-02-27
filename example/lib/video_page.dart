import 'package:ff_video/controls/tencent_video/tencent_video_control.dart';
import 'package:ff_video/ff_video.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  final String url;
  final String title;

  const VideoPage({Key key, this.url, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: [
          FFVideo(
            url: url,
            autoPlay: true,
            control: TencentVideoControl(
              thumbnail: Image.network(
                'http://img.mp.itc.cn/upload/20170326/39eaf2c41cfb46fe98982670af385a64_th.jpeg',
                fit: BoxFit.cover,
              ),
              title: Text(
                title,
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

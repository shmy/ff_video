import 'package:ff_video/controls/tencent_video/tencent_video_control.dart';
import 'package:ff_video/ff_video.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  final String url;
  final String title;

  VideoPage({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? controller;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url)..initialize().then((_) {
      controller?.play();
      controller?.setLooping(true);
    });
  }
  @override
  void dispose() {
    super.dispose();
    controller?.pause();
    controller?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: ListView(
        children: [
          FFVideo(
            controller: controller,
            controlBuilder: (videoPlayController) => TencentVideoControl(
              controller: videoPlayController,
              thumbnailUrl:
                  'https://img.mp.itc.cn/upload/20170326/39eaf2c41cfb46fe98982670af385a64_th.jpeg',
              title: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              action: GestureDetector(
                onTap: () {
                  print('add taped');
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              sizeTransformCallback: (e) => e,
            ),
          ),
        ],
      ),
    );
  }
}

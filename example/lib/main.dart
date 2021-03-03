import 'package:ff_video_example/video_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        platform: TargetPlatform.iOS
      ),
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text('白雪公主和小矮人'),
              onTap: () {
                _jumpVideoPage(title: '白雪公主和小矮人', url: 'https://hair.jingpin88.com/20171029/Fillu3JT/index.m3u8');
              },
            ),
            ListTile(
              title: Text('复仇者联盟4'),
              onTap: () {
                _jumpVideoPage(title: '复仇者联盟4', url: 'https://bili.meijuzuida.com/20190731/21094_0a89b649/index.m3u8');
              },
            ),
          ],
        ),
      ),
    );
  }
  void _jumpVideoPage({String title, String url}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPage(url: url, title: title,)));
  }
}

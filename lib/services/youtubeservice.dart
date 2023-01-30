import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

void showDownloadProgress(received, total) {
  if (total != -1) {
   print ((received / total * 100));
  }
}
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

Future download(Dio dio, String url, String savePath) async {
  try {
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    File file = File("$savePath${getRandomString(15)}.mp4");
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    print(e);
  }
}

Future<void> start(String baseUrl, String videoId) async {
  var dio = Dio();
  Directory? directory;
  directory = Directory('/storage/emulated/0/Download/');

  String fullPath = directory.path;
  print('full path ${fullPath}');

  download(dio, baseUrl + videoId, fullPath);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController urlController;
  String baseUrl = "https://d73c-159-146-84-234.eu.ngrok.io/video/";
  late String videoId;

  @override
  void initState() {
    Future.microtask(() async {
      await Permission.manageExternalStorage.request();
    });
    urlController = TextEditingController();
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: urlController,
              ),
             ElevatedButton(
                  onPressed: () async {
                    videoId = urlController.text.split("/").last;
                    start(baseUrl, videoId);
                  },
                  child: const Text("İndir"))
            ]),
      ),
    );
  }
}

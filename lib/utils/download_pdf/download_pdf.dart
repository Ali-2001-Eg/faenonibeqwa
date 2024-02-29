import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faenonibeqwa/utils/download_pdf/check_permission.dart';
import 'package:faenonibeqwa/utils/download_pdf/directory_path.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';

class DownLoadPdfFirstWayScreen extends StatefulWidget {
  const DownLoadPdfFirstWayScreen({super.key});

  @override
  State<DownLoadPdfFirstWayScreen> createState() =>
      _DownLoadPdfFirstWayScreenState();
}

class _DownLoadPdfFirstWayScreenState extends State<DownLoadPdfFirstWayScreen> {
  bool isPermission = false;
  var checkAllPermissions = CheckPermission();

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  var dataList = [
    {
      "id": "2",
      "title": "file Video 1",
      "url": "https://download.samplelib.com/mp4/sample-30s.mp4"
    },
    {
      "id": "3",
      "title": "file Video 2",
      "url": "https://download.samplelib.com/mp4/sample-20s.mp4"
    },
    {
      "id": "4",
      "title": "file Video 3",
      "url": "https://download.samplelib.com/mp4/sample-15s.mp4"
    },
    {
      "id": "5",
      "title": "file Video 4",
      "url": "https://download.samplelib.com/mp4/sample-10s.mp4"
    },
    {
      "id": "6",
      "title": "file PDF 6",
      "url":
          "https://www.iso.org/files/live/sites/isoorg/files/store/en/PUB100080.pdf"
    },
    {
      "id": "10",
      "title": "file PDF 7",
      "url": "https://www.tutorialspoint.com/javascript/javascript_tutorial.pdf"
    },
    {
      "id": "10",
      "title": "C++ Tutorial",
      "url": "https://www.tutorialspoint.com/cplusplus/cpp_tutorial.pdf"
    },
    {
      "id": "11",
      "title": "file PDF 9",
      "url":
          "https://www.iso.org/files/live/sites/isoorg/files/store/en/PUB100431.pdf"
    },
    {
      "id": "12",
      "title": "file PDF 10",
      "url": "https://www.tutorialspoint.com/java/java_tutorial.pdf"
    },
    {
      "id": "13",
      "title": "file PDF 12",
      "url": "https://www.irs.gov/pub/irs-pdf/p463.pdf"
    },
    {
      "id": "14",
      "title": "file PDF 11",
      "url": "https://www.tutorialspoint.com/css/css_tutorial.pdf"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                var data = dataList[index];
                return TileList(
                  fileUrl: data['url']!,
                  title: data['title']!,
                );
              },
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     Map<Permission, PermissionStatus> statuses = await [
          //       Permission.storage,
          //       //add more permission to request here.
          //     ].request();
          //     print(statuses);
          //     if (statuses[Permission.storage]!.isGranted) {
          //       // var dir = await DownloadsPathProvider.downloadsDirectory;
          //       // String savename = "file.pdf";
          //       // String savePath = dir.path + "/$savename";
          //       // print(savePath);
          //       //output:  /storage/emulated/0/Download/banner.png
          //       try {
          //         // await Dio().download(
          //         //     fileurl,
          //         //     savePath,
          //         //     onReceiveProgress: (received, total) {
          //         //       if (total != -1) {
          //         //         print((received / total * 100).toStringAsFixed(0) + "%");
          //         //         //you can build progressbar feature too
          //         //       }
          //         //     });
          //         print("File is saved to download folder.");
          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text("File Downloaded"),
          //         ));
          //       } on DioError catch (e) {
          //         print(e.message);
          //       }
          //     } else {
          //       print("No permission to read and write.");
          //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //         content: Text("Permission Denied !"),
          //       ));
          //     }
          //   },
          //   child: Text('Check'),
          // )
        ],
      ),
    );
  }
}

class TileList extends StatefulWidget {
  TileList({super.key, required this.fileUrl, required this.title});
  final String fileUrl;
  final String title;

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  File? pdfFile;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(widget.fileUrl, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    pdfFile = File(filePath);
    bool fileExistCheck = await pdfFile!.exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  openfile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName = Path.basename(widget.fileUrl);
    });
    checkFileExit();
  }

  deletePDF() async {
    await pdfFile?.delete().then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DownLoadPdfFirstWayScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.grey.shade100,
      child: ListTile(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            fileExists && dowloading == false ? deletePDF() : cancelDownload();
          },
          icon: fileExists && dowloading == false
              ? const Icon(
                  Icons.delete,
                  color: Colors.red,
                )
              : const Icon(Icons.close),
        ),
        trailing: IconButton(
          onPressed: () {
            fileExists && dowloading == false ? openfile() : startDownload();
          },
          icon: fileExists
              ? const Icon(
                  Icons.check_sharp,
                  color: Colors.green,
                )
              : dowloading
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        Text(
                          (progress * 100).toStringAsFixed(2),
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    )
                  : const Icon(
                      Icons.download,
                    ),
        ),
      ),
    );
  }
}

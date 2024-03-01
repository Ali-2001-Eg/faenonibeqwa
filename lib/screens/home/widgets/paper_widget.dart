// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import 'package:faenonibeqwa/models/paper_model.dart';
import 'package:faenonibeqwa/screens/home/widgets/pdf_viewer_widget.dart';
import 'package:faenonibeqwa/utils/download_pdf/directory_path.dart';
import 'package:faenonibeqwa/utils/shared/widgets/shimmer_widget.dart';

import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../../../utils/shared/widgets/small_text.dart';

class PapersWidget extends ConsumerWidget {
  final String lectureId;

  const PapersWidget({
    super.key,
    required this.lectureId,
  });
  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(papersStream(lectureId)).when(
      data: (data) {
        if (data.isEmpty) {
          return const BigText(
              textAlign: TextAlign.center,
              fontWeight: FontWeight.normal,
              text: 'لا توجد مستندات مرفقه بالمحاضره');
        } else {
          return ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final paper = data[index];
              return PaperItem(paperModel: paper);
            },
          );
        }
      },
      error: (err, stacktrace) {
        return BigText(text: err.toString());
      },
      loading: () {
        return const ShimmerWidget(
          cardsNumber: 2,
          heigth: 40,
        );
      },
    );
  }
}

class PaperItem extends StatefulWidget {
  final PaperModel paperModel;
  const PaperItem({
    Key? key,
    required this.paperModel,
  }) : super(key: key);

  @override
  State<PaperItem> createState() => _PaperItemState();
}

class _PaperItemState extends State<PaperItem> {
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
      await Dio().download(widget.paperModel.filePath, filePath,
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
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName = path.basename(widget.paperModel.filePath);
    });
    checkFileExit();
  }

  deletePDF() async {
    await pdfFile?.delete().then((value) {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => DownLoadPdfFirstWayScreen(),
      //     ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        fileExists
            ? openfile()
            : Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return PdfViewerWidget(
                    pdfPath: widget.paperModel.filePath,
                    networkSource: true,
                    title: widget.paperModel.title,
                  );
                },
              ));
      },
      title: SmallText(text: widget.paperModel.title),
      trailing: PopupMenuButton(
        icon: fileExists
            ? const Icon(
                Icons.picture_as_pdf,
                color: Colors.green,
                size: 25,
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
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      )
                    ],
                  )
                : const Icon(Icons.more_vert_outlined),
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            PopupMenuItem(
              child: fileExists
                  ? const SmallText(text: 'تم التحميل')
                  : const SmallText(text: 'تحميل'),
              onTap: () {
                fileExists ? null : startDownload();
              },
            ),
          ];
        },
      ),
    );
  }
}
/**     //open pdf file from network
                    FileInfo? cacheIsEmpty = await DefaultCacheManager()
                        .getFileFromCache(paper.filePath);

                    if (kDebugMode) {
                      print('path ${cacheIsEmpty?.file.uri}');
                    }
                    if (context.mounted && cacheIsEmpty == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfViewerWidget(
                                    pdfPath: paper.filePath,
                                    networkSource: true,
                                    title: paper.title,
                                  )));
                    } else {
                      ref.watch(isCached.notifier).update((state) => true);
                      DefaultCacheManager()
                          .getFileFromCache(paper.filePath)
                          .then(
                            (value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewerWidget(
                                  pdfPath: paper.filePath,
                                  networkSource: false,
                                  title: paper.title,
                                ),
                              ),
                            ),
                          );
                    } */
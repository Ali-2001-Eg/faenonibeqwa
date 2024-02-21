// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:faenonibeqwa/utils/shared/widgets/shimmer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/models/paper_model.dart';
import 'package:faenonibeqwa/screens/home/widgets/pdf_viewer_widget.dart';

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
  Widget build(BuildContext context, WidgetRef ref) {
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
                return ListTile(
                  title: SmallText(text: paper.title),
                  leading: const Icon(Icons.bookmark),
                  onTap: () async {
                    //open pdf file from network
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
                          .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PdfViewerWidget(
                                        pdfPath: paper.filePath,
                                        networkSource: false,
                                        title: paper.title,
                                      ))));
                    }
                  },
                  trailing: PopupMenuButton(itemBuilder: (context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(
                        child: const SmallText(text: 'تحميل'),
                        onTap: () {
                          //set it offline
                          _setAvailableOffline(paper, ref);
                        },
                      ),
                    ];
                  }),
                );
              });
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

  Future<void> _setAvailableOffline(PaperModel paper, WidgetRef ref) async {
    ref.read(isDownloading.notifier).update((state) => true);

    DefaultCacheManager().downloadFile(paper.filePath).then((value) {
      ref.read(isCached.notifier).update((state) => true);
      ref.read(isDownloading.notifier).update((state) => false);
    });
  }
}

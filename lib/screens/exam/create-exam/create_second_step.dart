import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

class CreateSecondStep extends StatefulWidget {
  const CreateSecondStep({
    super.key,
  });

  @override
  State<CreateSecondStep> createState() => _CreateSecondStepState();
}

class _CreateSecondStepState extends State<CreateSecondStep> {
  final _controller = DocumentScannerController();
  @override
  void initState() {
    _controller.statusTakePhotoPage.listen((AppStatus event) {
      debugPrint("Changes when taking the picture");
      debugPrint("[initial, loading, success, failure]");
    });

    _controller.statusCropPhoto.listen((AppStatus event) {
      debugPrint("Changes while cutting the image and adding warp perspective");
      debugPrint("[initial, loading, success, failure]");
    });

    _controller.statusEditPhoto.listen((AppStatus event) {
      debugPrint("Changes when editing the image (applying filters)");
      debugPrint("[initial, loading, success, failure]");
    });

    _controller.currentFilterType.listen((FilterType event) {
      debugPrint("Listen to the current filter applied on the image");
      debugPrint("[ natural, gray, eco]");
    });

    _controller.statusSavePhotoDocument.listen((AppStatus event) {
      debugPrint("Changes while the document image is being saved");
      debugPrint("[initial, loading, success, failure]");
    });

    _controller.currentPage.listen((AppPages page) {
      debugPrint("Changes in the current page");
      debugPrint("[takePhoto, cropPhoto, editDocument]");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DocumentScanner(
      controller: _controller,
      cropPhotoDocumentStyle: CropPhotoDocumentStyle(),
      takePhotoDocumentStyle: TakePhotoDocumentStyle(),
      generalStyles: GeneralStyles(),
      pageTransitionBuilder: (child, animation) {
        final tween = Tween(begin: 0.0, end: 1.0);

        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: tween.animate(curvedAnimation),
          child: child,
        );
      },
      onSave: (image) {},
    );
  }
}

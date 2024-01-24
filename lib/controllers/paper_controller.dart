import 'package:faenonibeqwa/repositories/paper_repo.dart';

class PaperController {
  final PaperRepo paperRepo;

  PaperController({required this.paperRepo});
  Future<void> uploadPaper({
    required String title,
    required String filePath,
  }) =>
      paperRepo.uploadPaper(title, filePath);
}

import 'package:faenonibeqwa/repositories/paper_repo.dart';
import 'package:faenonibeqwa/models/paper_model.dart';

class PaperController {
  final PaperRepo paperRepo;

  PaperController({required this.paperRepo});
  Future<void> uploadPaper({
    required String title,
    required String filePath,
    required String lectureId,
  }) =>
      paperRepo.uploadPaper(title, filePath,lectureId);

  Stream<List<PaperModel>>  papers(lectureId) => paperRepo.papers(lectureId);
}

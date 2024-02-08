import 'package:faenonibeqwa/repositories/paper_repo.dart';
import 'package:faenonibeqwa/models/paper_model.dart';

class PaperController {
  final PaperRepo paperRepo;

  PaperController({required this.paperRepo});
  Future<void> uploadPaper({
    required String title,
    required String filePath,
  }) =>
      paperRepo.uploadPaper(title, filePath);

  Stream<List<PaperModel>> get papers => paperRepo.papers;
}

import '../../models/exam_model.dart';

typedef QuestionsIds = Stream<List<String>>;
typedef Answer =  Future<List<Answers>>;
typedef Questions =  Future<List<Question>>;
typedef ExamsStream =  Stream<List<ExamModel>>;

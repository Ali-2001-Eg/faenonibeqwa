import 'package:tuple/tuple.dart';

import '../../models/exam_model.dart';

typedef QuestionsIds = Stream<List<String>>;
typedef Answer =  Future<List<Answers>>;
typedef Questions =  Future<List<Question>>;
typedef ExamsStream =  Stream<List<ExamModel>>;
typedef QuestionParameters = Tuple2<String,int>;
typedef AnswersParameters = Tuple2<String,String>;
typedef AnswersIdentiferParameters = Tuple2<String,String>;
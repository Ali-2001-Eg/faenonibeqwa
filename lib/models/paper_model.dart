
import 'package:equatable/equatable.dart';

class PaperModel extends Equatable {
  final String title;
  final String filePath;
  const PaperModel({
    required this.title,
    required this.filePath,
  });
  

  PaperModel copyWith({
    String? title,
    String? filePath,
  }) {
    return PaperModel(
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'filePath': filePath,
    };
  }

  factory PaperModel.fromMap(Map<String, dynamic> map) {
    return PaperModel(
      title: map['title'] as String,
      filePath: map['filePath'] as String,
    );
  }

  
  @override
  List<Object> get props => [title, filePath];
}

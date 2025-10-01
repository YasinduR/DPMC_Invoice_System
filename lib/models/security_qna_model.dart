import 'package:myapp/contracts/mappable.dart';

class SecurityQuestionAnswer implements Mappable {
  final String question;
  final String answer;

  SecurityQuestionAnswer({required this.question, required this.answer});

  @override
  Map<String, dynamic> toMap() {
    return {'question': question, 'answer': answer};
  }
}

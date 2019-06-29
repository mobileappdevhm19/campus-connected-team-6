import 'package:flutter_campus_connected/FAQ/faq_questions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fqaQuestion = new Faq();

  fqaQuestion.question = " Can I delete my account?";
  fqaQuestion.answer =
      " Your account will only be deleted if you are not a student at the university.";
  fqaQuestion.imageURL = " assets/faq.jpg  ";

  test("FAQ Question wird getetstet", () {
    expect(fqaQuestion.question.length, 25);
    expect(fqaQuestion.answer.length, 78);
    expect(fqaQuestion.imageURL.length, 17);

    expect(fqaQuestion.question.isNotEmpty, true);
    expect(fqaQuestion.answer.isEmpty, false);
    expect(fqaQuestion.imageURL.isNotEmpty, true);
  });
}

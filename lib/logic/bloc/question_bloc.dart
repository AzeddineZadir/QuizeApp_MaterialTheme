import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_app_quize/data/models/question.dart';
import 'package:material_app_quize/data/repositories/firestore_repository.dart';
import 'package:meta/meta.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionsBloc extends Bloc<QuestionEvent, QuestionState> {
  FireStoreRepository fireStoreRepository = FireStoreRepository();
  List<dynamic> questions = [];
  List<Question> formatedQuestions = [];
  QuestionsBloc() : super(QuestionInitialState());

  @override
  Stream<QuestionState> mapEventToState(QuestionEvent event) async* {
    if (event is FetchQuestionsEvent) {
      try {
        questions = await fireStoreRepository.getQuestions();
        questions.forEach((element) {
          print(element);
          formatedQuestions.add(Question.fromJson(element));
        });

        yield QuestionLoadedState(formatedQuestions);
      } catch (er) {
        print(er);
      }
    }
    if (event is AddQuestionsEvent) {
      try {
        var returnVal = fireStoreRepository.addQuestion(event._question);
        yield QuestionAddedCorrectly();
      } catch (er) {
        print(er);
      }
    }
  }
}

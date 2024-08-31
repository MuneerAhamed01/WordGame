import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:english_wordle/models/error.dart';
import 'package:english_wordle/models/word_model.dart';
import 'package:english_wordle/services/apis/gemeni_service.dart';
import 'package:english_wordle/services/database/words_db.dart';
import 'package:get/get.dart';

class WordsRepository extends GetxService {
  final WordsDb _wordsDb = WordsDb.instance;

  Future<Either<MyError, List<WordModel>>> getTodaysWord({
    String wordDiff = 'HIGH',
    String hintDiff = "HIGH",
  }) async {
    final isEmpty = await _wordsDb.todayIsEmpty;

    if (isEmpty.isLeft) return Left(isEmpty.left);

    if (isEmpty.right) {
      final twoDaysData = await WordsDb.instance.getPreviousTwoDaysWords();

      if (twoDaysData.isLeft) return Left(twoDaysData.left);

      return await Get.find<GemeniService>().getMyWord(
        hintDiff: hintDiff,
        wordDiff: wordDiff,
        ignoreWord: twoDaysData.right,
      );
    }

    return WordsDb.instance.getTodaysWords();
  }

  Future<void> getHintForTheWord(String word) async {}

  Future<void> checkIsThisAWord(String word) async {}

  // Future<void>

  @override
  void onInit() {
    checkIsThisAWord('Frog');
    super.onInit();
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:english_wordle/models/error.dart';
import 'package:english_wordle/models/word_model.dart';
import 'package:english_wordle/services/database/words_db.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GemeniService extends GetxService {
  late final GenerativeModel geminiModel;

  Future<Either<MyError, List<WordModel>>> getMyWord({
    String wordDiff = 'HIGH',
    String hintDiff = "HIGH",
    List<String> ignoreWord = const [],
  }) async {
    try {
      final prompt = '''

Give me a 5 letter word and  2 hints for the word with the below criteria and the below json structure 
Note:
I need it as list of 10 words with hints

json structure:
[{
'word': "<WORD>",
'hints': [
<Hint 1>
<Hint 2>
]
}]

Note:
The response should can convert to dart jsonDecode(response)
Somtimes it gives FormatException Make sure it is not
criterial 
// WE HAVE THE OPTIONS HIGH,LOW,MEDIUM
Word difficulty: $wordDiff
  HINT DIFFICULYT: $hintDiff,
  IGONRE THIS WORDS: ${ignoreWord.join(',')}
  ''';
      final response =
          await geminiModel.generateContent([Content.text(prompt)]);

      if (response.text == null) {
        return Left(ApiError(apiError: 'There is no response'));
      }

      final List<WordModel> model =
          (jsonDecode(fixJsonBrackets(response.text!)) as List).map((e) {
        return WordModel.fromJson(e);
      }).toList();

      unawaited(_addTheWordsToDB(model));

      return Right(model);
    } catch (e) {
      return Left(ApiError(apiError: e));
    }
  }

  Future<void> _addTheWordsToDB(List<WordModel> words) async {
    WordsDb.instance.addItemToTheList(words);
  }

  @override
  void onInit() async {
    super.onInit();
    const geminiKey = String.fromEnvironment('GEMINI_KEY');
    geminiModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );
  }

  String fixJsonBrackets(String jsonString) {
    return jsonString.replaceAll('}]}', ']}');
  }
}

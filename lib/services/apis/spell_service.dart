import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SpellService extends GetxService {
  final Dio _dio = Dio();
  Future<bool> spellCheck(String word) async {
    try {
      const String key = String.fromEnvironment('WORD_KEY');
      final String wordPath =
          'https://wordsapiv1.p.rapidapi.com/words/$word/synonyms';
      final response = await _dio.get(
        wordPath,
        options: Options(
          headers: {
            "x-rapidapi-key": key,
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
          },
        ),
      );

      if (response.statusCode == 200) return true;
    } catch (e) {
      return false;
    }
    return false;
  }
}

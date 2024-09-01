import 'package:english_wordle/models/word_model.dart';
import 'package:get_storage/get_storage.dart';

class WordsBoxDB {
  WordsBoxDB._();

  static WordsBoxDB instance = WordsBoxDB._();

  late final GetStorage _wordBox;

  Future<void> initBox() async {
    await GetStorage('words').initStorage;

    _wordBox = GetStorage('words');
  }

  Future<void> storeTodaysWord(WordModel word) async {
    await _wordBox.write(
      'todaysWord',
      {
        'word': word.toJson(true),
        'date': DateTime.now().toString(),
        "hints": [...word.hints]
      },
    );
  }

  WordModel? get getTodaysWord {
    final word = _wordBox.read('todaysWord') as Map<String, dynamic>?;

    if (word == null) return null;

    final DateTime? date = DateTime.tryParse(word['date']);

    if (date == null) return null;

    if (date.year == DateTime.now().year &&
        date.day == DateTime.now().day &&
        date.month == DateTime.now().month) {
      return WordModel.fromJsonLocal(word['word']);
    }
    return null;
  }

  Future<void> storeCurrentSataus(List<String> typedValues, int session) async {
    await _wordBox.write('typedValues', {
      'date': DateTime.now().toString(),
      'values': typedValues,
      'currentSession': session,
    });
  }

  List<String> get getTypedValues {
    final word = _wordBox.read('typedValues') as Map<String, dynamic>?;

    if (word == null) return [];

    final DateTime? date = DateTime.tryParse(word['date']);

    if (date == null) return [];

    if (date.year == DateTime.now().year &&
        date.day == DateTime.now().day &&
        date.month == DateTime.now().month) {
      return List.from(word['values']);
    }

    return [];
  }

  int get getCurrentSession {
    final word = _wordBox.read('typedValues') as Map<String, dynamic>?;

    if (word == null) return 1;

    final DateTime? date = DateTime.tryParse(word['date']);

    if (date == null) return 1;

    if (date.year == DateTime.now().year &&
        date.day == DateTime.now().day &&
        date.month == DateTime.now().month) {
      return word['currentSession'];
    }

    return 1;
  }
}

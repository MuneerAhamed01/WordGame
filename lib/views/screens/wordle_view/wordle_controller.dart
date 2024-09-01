import 'dart:math';

import 'package:english_wordle/models/word_model.dart';
import 'package:english_wordle/services/apis/words_service.dart';
import 'package:english_wordle/services/local_db/words_box.dart';
import 'package:english_wordle/views/widgets/word_tile/word_tile.dart';
import 'package:get/get.dart';

class WordleController extends GetxController {
  static String reBuildCardId(String id) => 'Rebuild_$id';

  static String get reBuildKeyBord => 'reBuildKeyBord';

  static String get reBuildScreen => 'reBuildScreen';

  static String get reBuildIndicator => 'reBuildIndicator';

  WordTileType type = WordTileType.none;

  List<String> typedValues = [];

  String todaysWord = 'FROGS';

  WordModel? word;

  bool isLoading = false;

// include in the [todaysWord] but not available at the correct position
  final Map<int, List<String>> _orangeWords = {
    for (int i = 1; i <= 5; i++) i: []
  };

// Included in the [todaysWord] and available at the correct position
  final Map<int, List<String>> _greenWords = {
    for (int i = 1; i <= 5; i++) i: []
  };

// This is not included at the [todaysWord] and not avaiable at the position
  final Map<int, List<String>> _disabledWords = {
    for (int i = 1; i <= 5; i++) i: []
  };

  List<String> disabledIn(int section) => _disabledWords[section]!;

  List<String> orangeIn(int section) => _orangeWords[section]!;

  List<String> greenIn(int section) => _greenWords[section]!;

  List<String> get disabledValues {
    List<String> values = [];

    _disabledWords.forEach((e, v) {
      values.addAll(v);
    });

    return values.toSet().toList();
  }

  List<String> get orangeValues {
    List<String> values = [];

    _orangeWords.forEach((e, v) {
      values.addAll(v);
    });

    return values.toSet().toList();
  }

  List<String> get greenValues {
    List<String> values = [];

    _greenWords.forEach((e, v) {
      values.addAll(v);
    });

    return values.toSet().toList();
  }

  int currentSection = 1;
  void addTypedValue(String value) {
    if (typedValues.length == (5 * currentSection)) {
      print('You have entered the 5th wordle please press enter');
      return;
    }
    typedValues.add(value);

    update([reBuildCardId((typedValues.length - 1).toString())]);
  }

  void removeValue() {
    if (typedValues.isEmpty) return;

    if ((5 * (currentSection - 1) >= typedValues.length)) {
      print('Previous session is not allowed');
      return;
    }
    typedValues.removeLast();

    update([reBuildCardId((typedValues.length).toString())]);
  }

  void onPressEnter() {
    if (typedValues.length == (5 * currentSection)) {
      _moveToTheNextSession();
    } else {
      showTopSnackBar('This is new');
    }
  }

  void _moveToTheNextSession() {
    final value = typedValues
        .getRange(typedValues.length - 5, typedValues.length)
        .toList();
    if (value.join() == todaysWord) {
      _callWonTheGame(value.join());
    } else {
      _checkWithCurrentWord(value);
    }
  }

  Future<void> _checkWithCurrentWord(List<String> wordFromTypledValues) async {
    for (String i in wordFromTypledValues) {
      if (todaysWord.contains(i)) {
        if (todaysWord.indexOf(i) == wordFromTypledValues.indexOf(i)) {
          _greenWords[currentSection]?.add(i);
        } else {
          _orangeWords[currentSection]?.add(i);
        }
      } else {
        _disabledWords[currentSection]?.add(i);
      }
    }

    int start = (currentSection - 1) * 5;

    int end = start + 5;

    for (int i = start; i < end; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      update([reBuildCardId(i.toString())]);
    }

    currentSection += 1;

    update([reBuildKeyBord, reBuildIndicator]);
  }

  WordTileType typeOfTheContainer(String value, int section, int index) {
    if (greenIn(section).contains(value)) {
      int indexOfThatWord = index % 5;

      int indexInOurWord = todaysWord.indexOf(value);

      if (indexOfThatWord == indexInOurWord) return WordTileType.green;
      return WordTileType.none;
    }

    if (orangeIn(section).contains(value)) return WordTileType.orange;

    return WordTileType.none;
  }

  Future<void> _callWonTheGame(String value) async {
    _greenWords[currentSection] = [...value.split('')];
    int start = (currentSection - 1) * 5;

    int end = start + 5;
    for (int i = start; i < end; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      update([reBuildCardId(i.toString())]);
    }
  }

  Future<void> getTodaysWord() async {
    isLoading = true;
    update([reBuildScreen]);
    final myWord = WordsBoxDB.instance.getTodaysWord;

    if (myWord == null) {
      final todaysWord = await Get.find<WordsRepository>().getTodaysWord();

      todaysWord.either((_) {
        print('Word handling has some error');
        isLoading = false;
        update([reBuildScreen]);
      }, _assignTodaysWord);
    } else {
      word = myWord;
      isLoading = false;
      update([reBuildScreen]);
    }
  }

  void _assignTodaysWord(List<WordModel> words) {
    Random random = Random();

    final int value = random.nextInt(10);

    word = words[value];

    if (word != null) {
      WordsBoxDB.instance.storeTodaysWord(word!);
    }
    isLoading = false;
    update([reBuildScreen]);
  }

  void showTopSnackBar(String message) {
    print('ShowSnackbar');
    // Get.showSnackbar(
    //   Ge
    // );
  }

  @override
  void onInit() {
    super.onInit();
    // getTodaysWord();
  }
}

import 'dart:math';

import 'package:dictionaryx/dictionary_reduced_sa.dart';
import 'package:english_wordle/controllers/audio_controller.dart';
import 'package:english_wordle/models/word_model.dart';
import 'package:english_wordle/services/apis/spell_service.dart';
import 'package:english_wordle/services/apis/words_service.dart';
import 'package:english_wordle/services/local_db/words_box.dart';
import 'package:english_wordle/views/utils/audios.dart';
import 'package:english_wordle/views/widgets/snackbar.dart';
import 'package:english_wordle/views/widgets/winning_bottom_sheet.dart';
import 'package:english_wordle/views/widgets/word_tile/word_tile.dart';
import 'package:get/get.dart';

class WordleController extends GetxController {
  static String reBuildCardId(String id) => 'Rebuild_$id';

  static String get reBuildKeyBord => 'reBuildKeyBord';

  static String get reBuildScreen => 'reBuildScreen';

  static String get reBuildIndicator => 'reBuildIndicator';

  WordTileType type = WordTileType.none;

  final DictionaryReducedSA dictnory = DictionaryReducedSA();

  List<String> typedValues = [];

  String get todaysWord => word?.word ?? '';

  Map<int, Function?> listOfShakeItems = {};

  WordModel? word;

  bool isLoading = false;

  bool isWinnedToday = false;

  late final AudioController audioController;

  bool checkingWordIsCorrect = false;

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
    if (isWinnedToday) return;
    if (typedValues.length == (5 * currentSection)) {
      // print('You have entered the 5th wordle please press enter');
      return;
    }
    typedValues.add(value);
    saveTypedValue();

    update([reBuildCardId((typedValues.length - 1).toString())]);
  }

  void removeValue() {
    if (isWinnedToday) return;

    if (typedValues.isEmpty) return;

    if ((5 * (currentSection - 1) >= typedValues.length)) {
      // print('Previous session is not allowed');
      SnackBarService.showSnackBar('Previous session is not allowed');
      return;
    }
    typedValues.removeLast();
    saveTypedValue();

    update([reBuildCardId((typedValues.length).toString())]);
  }

  void onPressEnter() {
    if (isWinnedToday) return;

    if (typedValues.length == (5 * currentSection)) {
      _moveToTheNextSession();
    } else {
      shakeFirstFive();
      SnackBarService.showSnackBar('Fill the letters and press ender');
    }
  }

  Future<void> _moveToTheNextSession() async {
    final value = typedValues
        .getRange(typedValues.length - 5, typedValues.length)
        .toList();

    checkingWordIsCorrect = true;

    final hasWord = await Get.find<SpellService>().spellCheck(value.join());
    if (!hasWord) {
      checkingWordIsCorrect = false;
      return _onWordError();
    }
    checkingWordIsCorrect = false;

    if (value.join() == todaysWord) {
      isWinnedToday = true;
      // PERFOM THE WINNING ANOUNCEMENT
      _callWonTheGame(value.join());
    } else {
      _checkWithCurrentWord(value);
    }
  }

  Future<void> _checkWithCurrentWord(List<String> wordFromTypledValues) async {
    _addTheWords(wordFromTypledValues, currentSection);

    int start = (currentSection - 1) * 5;

    int end = start + 5;

    for (int i = start; i < end; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      update([reBuildCardId(i.toString())]);
    }

    currentSection += 1;
    if (currentSection == 6) {
      // YOU CAN DO THE LOSS THE GAME OVER HERE
      print('You loss word is $todaysWord');
    }
    update([reBuildKeyBord, reBuildIndicator]);
  }

  void _addTheWords(List<String> wordFromTypledValues,
      [int currentSection = 0]) {
    for (int i = 0; i < wordFromTypledValues.length; i++) {
      if (todaysWord.contains(wordFromTypledValues[i])) {
        final int indexOfTheWord = i;

        final valueAtTheIndex = todaysWord.split('')[indexOfTheWord];

        if (valueAtTheIndex == wordFromTypledValues[i]) {
          _greenWords[currentSection]?.add(wordFromTypledValues[i]);
        } else {
          _orangeWords[currentSection]?.add(wordFromTypledValues[i]);
        }
      } else {
        _disabledWords[currentSection]?.add(wordFromTypledValues[i]);
      }
    }
  }

  WordTileType typeOfTheContainer(String value, int section, int index) {
    if (greenIn(section).contains(value)) {
      int indexOfThatWord = index % 5;

      String elementAtThatIndex =
          todaysWord.split('').elementAt(indexOfThatWord);

      if (value == elementAtThatIndex) return WordTileType.green;
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
    _winnerBottomSheet();
  }

  void _onWordError() {
    shakeFirstFive();
    // print('Typed word is not exist in the dictnory');
    SnackBarService.showSnackBar('Typed word is not exist');
  }

  Future<void> getTodaysWord() async {
    isLoading = true;
    update([reBuildScreen]);
    final myWord = WordsBoxDB.instance.getTodaysWord;

    if (myWord == null) {
      final todaysWord = await Get.find<WordsRepository>().getTodaysWord();

      todaysWord.either((e) {
        SnackBarService.showSnackBar('Something went wrong please try again');
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

  Future<void> saveTypedValue() async {
    WordsBoxDB.instance.storeCurrentSataus(typedValues, currentSection);
  }

  void getTypedValues() {
    typedValues = WordsBoxDB.instance.getTypedValues;
    currentSection = WordsBoxDB.instance.getCurrentSession;

    int startRange = 0;
    int endRange = 5;

    int session = 1;

    for (int i = 0; i < 5; i++) {
      if (typedValues.length < (endRange - 1)) break;
      final word = typedValues.getRange(startRange, endRange).join('');
      if (word == todaysWord) {
        isWinnedToday = true;
        _winnerBottomSheet();
      }
      _addTheWords(
        typedValues.getRange(startRange, endRange).toList(),
        session,
      );
      startRange = endRange;
      endRange = endRange + 5;
      session++;
    }
    update([reBuildScreen]);
    // int value = (typedValues.length / 5).floor() * 5;
  }

  shakeFirstFive() {
    final value = currentSessionIndex();
    final items = listOfShakeItems.entries.where((v) {
      return v.key <= value.$2 && v.key >= value.$1;
    }).toList();
    for (var v in items) {
      v.value?.call();
    }
  }

  (int start, int end) currentSessionIndex() {
    if (currentSection == 1) {
      return (0, 4);
    }
    if (currentSection == 2) {
      return (5, 9);
    }

    if (currentSection == 3) {
      return (10, 14);
    }

    if (currentSection == 4) {
      return (15, 19);
    }

    if (currentSection == 5) {
      return (20, 24);
    }
    return (0, 4);
  }

  void _winnerBottomSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      WinnerBottomSheet(
        todayWord: todaysWord,
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    audioController = AudioController(audio: Audios.clickAudioGame);
    getTodaysWord().then((e) {
      // getTypedValues();
    });
  }
}

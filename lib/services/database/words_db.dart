import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:english_wordle/models/error.dart';
import 'package:english_wordle/models/word_model.dart';

class WordsDb {
  WordsDb._();

  static WordsDb instance = WordsDb._();

  // late final List<String>? _todaysWords;

  final _wordsCollection = FirebaseFirestore.instance.collection('words');

  final WriteBatch _batch = FirebaseFirestore.instance.batch();

  Future<Either<MyError, bool>> get todayIsEmpty async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(microseconds: 1));

      final count = await _wordsCollection
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThan: Timestamp.fromDate(endOfDay))
          .count()
          .get();

      return Right((count.count ?? 0) == 0);
    } catch (e) {
      return Left(DatabaseError(dbError: e));
    }
  }

  Future<Either<MyError, List<WordModel>>> getTodaysWords() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(microseconds: 1));

      final todaysWords = await _wordsCollection
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      final listOfWords =
          todaysWords.docs.map((e) => WordModel.fromJson(e.data())).toList();

      return Right(listOfWords);
    } catch (e) {
      return Left(DatabaseError(dbError: e));
    }
  }

  Future<Either<MyError, bool>> addItemToTheList(
    List<WordModel> newWord,
  ) async {
    try {
      for (int i = 0; i < newWord.length; i++) {
        // Create a new document reference with an auto-generated ID
        final DocumentReference newItemRef = _wordsCollection.doc();

        // Create the data for this item
        final Map<String, dynamic> itemData = newWord[i]
            .copyWith(
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
            .toJson();

        // Add this operation to the batch
        _batch.set(newItemRef, itemData);
      }

      await _batch.commit();
      return const Right(true);
    } on Exception catch (e) {
      return Left(DatabaseError(dbError: e));
    }
  }

  Future<Either<MyError, List<String>>> getPreviousTwoDaysWords() async {
    try {
      final DateTime twoDaysAgo =
          DateTime.now().subtract(const Duration(days: 2));

      final data = await _wordsCollection
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(twoDaysAgo))
          .orderBy('createdAt', descending: true)
          .get();

      return Right(data.docs.map((e) => e.data()['word'].toString()).toList());
    } catch (e) {
      return Left(DatabaseError(dbError: e));
    }
  }

  // Future<void> onInit() async {
  //   await getTodaysWords();
  // }
}

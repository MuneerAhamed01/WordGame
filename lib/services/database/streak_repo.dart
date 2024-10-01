import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_wordle/models/streak_model.dart';
import 'package:english_wordle/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StreakRepo extends GetxService {
  CollectionReference<Map<String, dynamic>> get _streakCollection {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('streaks');
  }

  UserModel? streakOfUser;

  Future<DocumentReference<Map<String, dynamic>>> addStreak(StreakModel streak,
      [int currentSection = 0]) async {
    try {
      final id = DateFormat('yyyy-MM-dd').format(streak.date);
      await _streakCollection.doc(id).set(streak.toMap());

      if (currentSection == 5) {
        if (streak.isWon) {
          streakOfUser = streakOfUser!
              .copyWith(streakCount: streakOfUser!.streakCount + 1);
          await addSteakCount();
        } else {
          streakOfUser = streakOfUser!.copyWith(streakCount: 0);
          await addSteakCount();
        }
      }

      return _streakCollection.doc(id);
    } on FirebaseException catch (e) {
      throw Exception('Failed to add streak: ${e.message}');
    }
  }

  Future<void> addSteakCount() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'streakCount': streakOfUser!.streakCount});
  }

  Future<List<StreakModel>> getStreaksByMonth(DateTime date) async {
    try {
      final firstDayOfMonth = DateTime(date.year, date.month, 1);
      final lastDayOfMonth = DateTime(date.year, date.month + 1, 1);
      final querySnapshot = await _streakCollection
          .where(
            'date',
            isLessThanOrEqualTo: lastDayOfMonth,
            isGreaterThanOrEqualTo: firstDayOfMonth,
          )
          .orderBy('date')
          .get();
      return querySnapshot.docs
          .map((doc) => StreakModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get streaks: ${e.message}');
    }
  }

  Future<StreakModel?> getStreakByDate(DateTime date) async {
    try {
      final id = DateFormat('yyyy-MM-dd').format(date);
      final doc = await _streakCollection.doc(id).get();
      if (doc.exists) {
        return StreakModel.fromMap(doc.data()!);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw Exception('Failed to get streaks: ${e.message}');
    }
  }

  Future<void> userStreak() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (doc.exists) {
        streakOfUser = UserModel.fromJson(doc.data()!);
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .set(UserModel(streakCount: 0).toJson());

        streakOfUser = UserModel(streakCount: 0);
      }
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete streak: ${e.message}');
    }
  }

  Future<StreakRepo> init() async {
    await userStreak();
    return this;
  }
}

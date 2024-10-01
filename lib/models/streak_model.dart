// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StreakModel {
  final bool isWon;

  final DateTime date;

  final String word;

  final List<String> usedWord;

  int get currentSession {
    return usedWord.isEmpty ? 1 : usedWord.length;
  }

  List<String> get usedWordsOneByOneList {
    List<String> usedWordList = [];
    for (var word in usedWord) {
      word.split('').forEach((e) {
        usedWordList.add(e);
      });
    }
    return usedWordList;
  }

  StreakModel({
    required this.isWon,
    required this.date,
    required this.word,
    required this.usedWord,
  });

  StreakModel copyWith({
    bool? isWon,
    DateTime? date,
    String? word,
    List<String>? usedWord,
  }) {
    return StreakModel(
      isWon: isWon ?? this.isWon,
      date: date ?? this.date,
      word: word ?? this.word,
      usedWord: usedWord ?? this.usedWord,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isWon': isWon,
      'date': Timestamp.fromDate(date),
      'word': word,
      'usedWord': usedWord,
    };
  }

  factory StreakModel.fromMap(Map<String, dynamic> map) {
    return StreakModel(
      isWon: map['isWon'] as bool,
      date: (map['date'] as Timestamp).toDate(),
      word: map['word'] as String,
      usedWord: List<String>.from((map['usedWord'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory StreakModel.fromJson(String source) =>
      StreakModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StreakModel(isWon: $isWon, date: $date, word: $word, usedWord: $usedWord)';
  }

  @override
  bool operator ==(covariant StreakModel other) {
    if (identical(this, other)) return true;

    return other.isWon == isWon &&
        other.date == date &&
        other.word == word &&
        listEquals(other.usedWord, usedWord);
  }

  @override
  int get hashCode {
    return isWon.hashCode ^ date.hashCode ^ word.hashCode ^ usedWord.hashCode;
  }
}

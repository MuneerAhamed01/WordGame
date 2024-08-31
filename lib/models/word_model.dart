import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class WordModel {
  final String word;

  final List<String> hints;

  final DateTime createdAt;

  final DateTime? updatedAt;

  final DateTime? deletedAt;

  WordModel({
    required this.word,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.hints = const [],
  });

  WordModel copyWith({
    String? word,
    List<String>? hints,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return WordModel(
      word: word ?? this.word,
      hints: hints ?? this.hints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toJson([bool forLocalStorage = false]) {
    return <String, dynamic>{
      'word': word,
      'hints': hints,
      'deletedAt': forLocalStorage && deletedAt != null
          ? deletedAt.toString()
          : deletedAt != null
              ? Timestamp.fromDate(deletedAt!)
              : null,
      'createdAt': forLocalStorage
          ? createdAt.toString()
          : Timestamp.fromDate(createdAt),
      "updatedAt": forLocalStorage && updatedAt != null
          ? updatedAt.toString()
          : updatedAt != null
              ? Timestamp.fromDate(updatedAt!)
              : null,
    };
  }

  factory WordModel.fromJson(Map<String, dynamic> map) {
    return WordModel(
      word: map['word'] as String,
      hints: List<String>.from(
        (map['hints'] as List),
      ),
      deletedAt: _dateTimeOrNull(map["deletedAt"]),
      updatedAt: _dateTimeOrNull(map['updatedAt']),
      createdAt: _dateTimeOrNull(map['createdAt']) ?? DateTime.now(),
    );
  }

  factory WordModel.fromJsonLocal(Map<String, dynamic> map) {
    return WordModel(
      word: map['word'] as String,
      hints: List<String>.from(
        (map['hints'] as List),
      ),
      deletedAt: _dateTimeOrNullLocal(map["deletedAt"]),
      updatedAt: _dateTimeOrNullLocal(map['updatedAt']),
      createdAt: _dateTimeOrNullLocal(map['createdAt']) ?? DateTime.now(),
    );
  }

  static DateTime? _dateTimeOrNull(Timestamp? stamp) {
    if (stamp == null) return null;
    return stamp.toDate();
  }

  static DateTime? _dateTimeOrNullLocal(String? stamp) {
    if (stamp == null) return null;
    return DateTime.tryParse(stamp);
  }

  @override
  String toString() => 'WordModel(word: $word, hints: $hints)';

  @override
  bool operator ==(covariant WordModel other) {
    if (identical(this, other)) return true;

    return other.word == word && listEquals(other.hints, hints);
  }

  @override
  int get hashCode => word.hashCode ^ hints.hashCode;
}

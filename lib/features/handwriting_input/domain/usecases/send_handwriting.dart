import '../repository/handwriting_repository.dart';
import '../entities/handwriting_result.dart';
import 'package:flutter/material.dart';

class SendHandwriting {
  final HandwritingRepository repository;

  SendHandwriting(this.repository);

  Future<HandwritingResult> call(List<List<Offset>> strokes) {
    return repository.sendHandwriting(strokes);
  }
}

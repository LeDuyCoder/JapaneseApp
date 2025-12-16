import 'package:japaneseapp/features/handwriting_input/data/datasource/handwriting_remote_datasource.dart';
import 'package:japaneseapp/features/handwriting_input/domain/entities/handwriting_result.dart';
import 'package:japaneseapp/features/handwriting_input/domain/repository/handwriting_repository.dart';

import 'package:flutter/material.dart';

class HandwritingRepositoryImpl implements HandwritingRepository {
  final HandwritingRemoteDataSource remote;

  HandwritingRepositoryImpl({
    required this.remote,
  });

  @override
  Future<HandwritingResult> sendHandwriting(
      List<List<Offset>> strokes) async {
    final candidates = await remote.sendHandwriting(strokes);
    return HandwritingResult(candidates: candidates);
  }
}

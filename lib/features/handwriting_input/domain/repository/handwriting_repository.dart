import 'package:flutter/material.dart';
import 'package:japaneseapp/features/handwriting_input/domain/entities/handwriting_result.dart';

abstract class HandwritingRepository {
  Future<HandwritingResult> sendHandwriting(
      List<List<Offset>> strokes,
      );
}

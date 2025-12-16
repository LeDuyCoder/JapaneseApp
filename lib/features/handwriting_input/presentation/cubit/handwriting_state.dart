import 'package:flutter/services.dart';

class HandwritingState {
  final List<String> candidates;
  final bool loading;

  const HandwritingState({
    this.candidates = const [],
    this.loading = false,
  });

  HandwritingState copyWith({
    TextEditingValue? input,
    List<String>? candidates,
    bool? loading,
  }) {
    return HandwritingState(
      candidates: candidates ?? this.candidates,
      loading: loading ?? this.loading
    );
  }
}

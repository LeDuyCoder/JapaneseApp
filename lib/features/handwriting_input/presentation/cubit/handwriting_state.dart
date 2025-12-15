import 'package:flutter/services.dart';

class HandwritingState {
  final TextEditingValue input;
  final List<String> candidates;
  final bool loading;

  const HandwritingState({
    this.input = const TextEditingValue(),
    this.candidates = const [],
    this.loading = false,
  });

  HandwritingState copyWith({
    TextEditingValue? input,
    List<String>? candidates,
    bool? loading,
  }) {
    return HandwritingState(
      input: input ?? this.input,
      candidates: candidates ?? this.candidates,
      loading: loading ?? this.loading,
    );
  }
}

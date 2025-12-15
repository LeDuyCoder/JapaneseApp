import 'package:flutter/services.dart';

class DeleteText {
  TextEditingValue call(TextEditingValue oldValue) {
    final selection = oldValue.selection;
    final text = oldValue.text;

    if (!selection.isValid || text.isEmpty) return oldValue;

    if (selection.start != selection.end) {
      final before = text.substring(0, selection.start);
      final after = text.substring(selection.end);
      return TextEditingValue(
        text: before + after,
        selection: TextSelection.collapsed(offset: before.length),
      );
    }

    if (selection.start == 0) return oldValue;

    final before = text.substring(0, selection.start - 1);
    final after = text.substring(selection.start);

    return TextEditingValue(
      text: before + after,
      selection: TextSelection.collapsed(offset: before.length),
    );
  }
}

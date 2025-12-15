import 'package:flutter/services.dart';

class InsertText {
  TextEditingValue call({
    required TextEditingValue oldValue,
    required String newText,
  }) {
    final selection = oldValue.selection;
    final text = oldValue.text;

    if (!selection.isValid) {
      return TextEditingValue(
        text: text + newText,
        selection: TextSelection.collapsed(
          offset: (text + newText).length,
        ),
      );
    }

    final before = text.substring(0, selection.start);
    final after = text.substring(selection.end);

    final updated = before + newText + after;

    return TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(
        offset: selection.start + newText.length,
      ),
    );
  }
}

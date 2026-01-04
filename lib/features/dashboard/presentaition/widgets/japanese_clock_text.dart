import 'package:flutter/material.dart';

class JapaneseClockText extends StatelessWidget {
  final TextStyle? style;
  final bool showSeconds;

  const JapaneseClockText({
    Key? key,
    this.style,
    this.showSeconds = true,
  }) : super(key: key);

  String _formatJapaneseTime(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');

    return showSeconds
        ? "$hour時$minute分$second秒"
        : "$hour時$minute分";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        return Text(
          _formatJapaneseTime(snapshot.data!),
          style: style ??
              const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        );
      },
    );
  }
}

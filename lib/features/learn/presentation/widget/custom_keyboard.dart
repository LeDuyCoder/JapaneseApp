import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class CustomKeyboard extends StatefulWidget {
  final Function(List<List<Offset>>) onStrokeComplete;
  final Function(String word) insertText;
  final Function() backSpace;
  final Function() closeKeyBoard;
  final List<dynamic> listWord;

  const CustomKeyboard({
    required this.onStrokeComplete,
    required this.insertText,
    Key? key, required this.listWord, required this.backSpace, required this.closeKeyBoard,
  }) : super(key: key);

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  Timer? _apiDelayTimer;

  double boxWidth = 0;
  final double boxHeight = 250;

  Offset _clampPoint(Offset point) {
    if (boxWidth == 0) return point;
    return Offset(
      point.dx.clamp(0.0, boxWidth),
      point.dy.clamp(0.0, boxHeight),
    );
  }

  void _startStroke(Offset point) {
    final p = _clampPoint(point);
    setState(() {
      _currentStroke = [p];
      _strokes.add(_currentStroke);
    });
  }

  void _addPoint(Offset point) {
    final p = _clampPoint(point);
    setState(() {
      _currentStroke.add(p);
    });
  }

  void _endStroke() {
    _currentStroke = [];

    _apiDelayTimer?.cancel();

    _apiDelayTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onStrokeComplete(_strokes);
    });
  }

  void _clearDrawing() {
    setState((){
      _strokes.clear();
      widget.listWord.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 60,
            color: AppColors.primary,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for(String text in widget.listWord)
                            IntrinsicWidth(
                              child: Material(
                                color: Colors.transparent, // nền mặc định trong suốt
                                child: InkWell(
                                  onTap: () {
                                    widget.insertText(text);
                                    _clearDrawing();
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  splashColor: Colors.white24,  // màu loang khi click
                                  highlightColor: Colors.white10, // màu nhấn giữ
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Color.fromRGBO(
                                              241, 255, 241, 1.0), fontSize: 25),
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                  ),
                ),
                IconButton(onPressed: (){
                  widget.backSpace();
                }, icon: Icon(Icons.backspace, color: Colors.white,))
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),

                child: SizedBox(
                  height: boxHeight,
                  width: boxWidth,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) => _startStroke(details.localPosition),
                    onPanUpdate: (details) => _addPoint(details.localPosition),
                    onPanEnd: (_) => _endStroke(),
                    child: CustomPaint(
                      foregroundPainter: _DrawingPainter(_strokes),
                      child: Container(
                        width: boxWidth,
                        height: boxHeight,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  // đường ngang
                  Container(
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Dash(
                            direction: Axis.horizontal,
                            length: MediaQuery.of(context).size.width/1.8,
                            dashLength: 6,
                            dashColor: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // đường dọc
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 250,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Dash(
                            direction: Axis.vertical,
                            length: 200,
                            dashLength: 6,
                            dashColor: Colors.black87,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )

            ],
          ),
          const SizedBox(height: 16),
          // Functional buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  widget.closeKeyBoard();
                },
                child: Container(
                  margin: EdgeInsets.all(4),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 230, 230, 1.0),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(Icons.arrow_drop_down),
                ),
              ),
              Container(
                margin: EdgeInsets.all(4),
                width: MediaQuery.sizeOf(context).width / 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(230, 230, 230, 1.0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    widget.insertText(' ');
                  },
                  icon: const Icon(Icons.space_bar),
                  label: const Text("Space"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                width: MediaQuery.sizeOf(context).width/4,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _clearDrawing,
                  icon: const Icon(LineAwesome.broom_solid),
                  label: const Text("Xoá"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Vẽ từng stroke
    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }

    // Vẽ khung box
    final border = Paint()
      ..color = Colors.white.withAlpha(0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), border);
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => true;
}

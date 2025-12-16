import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/handwriting_input/presentation/widget/handwriting_painter.dart';
import '../cubit/handwriting_cubit.dart';
import '../cubit/handwriting_state.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key, required this.textEditingController});

  final TextEditingController textEditingController;

  @override
  State<CustomKeyboard> createState() => CustomKeyboardState();
}

class CustomKeyboardState extends State<CustomKeyboard> with SingleTickerProviderStateMixin {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  Timer? _recognizeTimer;

  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 3), // từ dưới
      end: Offset.zero,         // lên vị trí
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOut,
      ),
    );

    // chạy animation ngay khi build
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void showKeyboard() {
    _animController.forward();
  }

  void hideKeyboard() {
    _animController.reverse();
  }


  void _onPanStart(DragStartDetails details) {
    _currentStroke = [details.localPosition];
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _strokes.add(_currentStroke);
    _currentStroke = [];

    _recognizeTimer?.cancel();

    // set timer mới 3 giây
    _recognizeTimer = Timer(const Duration(microseconds: 500), () async {
      await context
          .read<HandwritingCubit>()
          .sendHandwriting(_strokes);
    });

  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<HandwritingCubit, HandwritingState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ===== CANDIDATES =====
                    Container(
                      color: AppColors.primary,
                      height: 48,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (context, index) {
                                final word = state.candidates[index];
                                return IntrinsicWidth(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        context.read<HandwritingCubit>().insertText(widget.textEditingController, word);
                                        _clearCanvas();
                                      },
                                      splashColor: Colors.white24,
                                      highlightColor: Colors.white10,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                word,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Color.fromRGBO(
                                                    241, 255, 241, 1.0), fontSize: 25),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => const SizedBox(width: 6),
                              itemCount: state.candidates.length,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.backspace, color: Colors.white,),
                            onPressed: () {
                              context.read<HandwritingCubit>().deleteText(widget.textEditingController);
                            },
                          )
                        ],
                      ),
                    ),

                    // ===== CANVAS =====
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),

                          child: SizedBox(
                            height: 200,
                            width: MediaQuery.sizeOf(context).width,
                            child: GestureDetector(
                              onPanStart: _onPanStart,
                              onPanUpdate: _onPanUpdate,
                              onPanEnd: _onPanEnd,
                              child: CustomPaint(
                                painter: HandwritingPainter(
                                  strokes: _strokes,
                                  currentStroke: _currentStroke,
                                ),
                                child: Container(),
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

                    const SizedBox(height: 8),

                    // ===== ACTION BUTTONS =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _animController.reverse();
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
                              context.read<HandwritingCubit>().insertText(widget.textEditingController, ' ');
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
                            onPressed: _clearCanvas,
                            icon: const Icon(LineAwesome.broom_solid),
                            label: const Text("Xoá"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

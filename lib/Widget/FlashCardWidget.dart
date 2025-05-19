import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashCardWidget extends StatefulWidget {

  final String word, mean, wayread;

  const FlashCardWidget({super.key, required this.word, required this.mean, required this.wayread});


  @override
  _FlashCardWidgetState createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_controller.isCompleted || _controller.isDismissed) {
      if (_isFront) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _isFront = !_isFront;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final rotation = _animation.value * 3.14159; // 0 → π
        final showFront = _animation.value < 0.5;

        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(rotation),
          child: showFront
              ? _buildFrontSide()
              : Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(3.14159),
            child: _buildBackSide(),
          ),
        );
      },
    );
  }

  Widget _buildFrontSide() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
            child: AutoSizeText(
              widget.word,
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontFamily: "Itim"
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 400,
            child: AutoSizeText(
              widget.wayread,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontFamily: "Itim"
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  readText(widget.wayread, 0.5);
                },
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.blue.shade200
                    ),
                    child: Icon(Icons.volume_down)
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: (){
                  _flipCard();
                },
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.red.shade200
                    ),
                    child: Icon(Icons.rotate_right, color: Colors.black,)
                ),
              )
            ],
          )
        ],
      )
    );
  }

  Widget _buildBackSide() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
            child: AutoSizeText(
              widget.mean,
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontFamily: "Itim"
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              _flipCard();
            },
            child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.red.shade200
                ),
                child: Icon(Icons.rotate_left, color: Colors.black,)
            ),
          )
        ],
      )
    );
  }
}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:japaneseapp/core/Service/GoogleTTSService.dart';
import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';

class FlashCardWidget extends StatefulWidget {

  final WordEntity wordEntity;

  const FlashCardWidget({super.key, required this.wordEntity});


  @override
  _FlashCardWidgetState createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  final FlutterTts _flutterTts = FlutterTts();
  final GoogleTTSService googleTTSService = GoogleTTSService();

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
          /// Từ vựng chính
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AutoSizeText(
              widget.wordEntity.word,
              style: const TextStyle(
                fontSize: 50,
                color: Colors.black,
                fontFamily: "Itim",
              ),
              textAlign: TextAlign.center,
              maxLines: 1,       // giữ 1 dòng, sẽ scale nhỏ lại
              minFontSize: 16,   // không nhỏ hơn 16
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),

          /// Cách đọc
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AutoSizeText(
              widget.wordEntity.wayread,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontFamily: "Itim",
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),

          /// Các nút
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if(await googleTTSService.speak(widget.wordEntity.word) != true){
                    readText(widget.wordEntity.wayread, 0.5);
                  }
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.blue.shade200,
                  ),
                  child: const Icon(Icons.volume_down),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _flipCard();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.red.shade200,
                  ),
                  child: const Icon(Icons.rotate_right, color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
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
              widget.wordEntity.mean,
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
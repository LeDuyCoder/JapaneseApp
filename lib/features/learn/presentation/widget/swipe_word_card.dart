import 'package:flutter/material.dart';

class SwipeWordCard extends StatefulWidget {
  final String word;
  final String hira;
  final String meaning;

  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const SwipeWordCard({
    super.key,
    required this.word,
    required this.hira,
    required this.meaning,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  State<SwipeWordCard> createState() => _SwipeWordCardState();
}

class _SwipeWordCardState extends State<SwipeWordCard>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  double angle = 0;

  void resetCard() {
    setState(() {
      position = Offset.zero;
      angle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;

            angle = position.dx * 0.001;
          });
        },
        onPanEnd: (_) {
          if (position.dx > 120) {
            widget.onSwipeRight();
          } else if (position.dx < -120) {
            widget.onSwipeLeft();
          }

          resetCard();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(position.dx, position.dy)
            ..rotateZ(angle),
          curve: Curves.easeOut,
          width: MediaQuery.sizeOf(context).width * 0.9,
          height: 430,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: position.dx > 0
                  ? Colors.green.withOpacity(0.5)
                  : position.dx < 0
                  ? Colors.red.withOpacity(0.5)
                  : Colors.transparent,
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 14,
                spreadRadius: 2,
                offset: Offset(0, 0),
              )
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// WORD
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    widget.word,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 34),

              /// HIRAGANA
              SizedBox(
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      widget.hira,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Divider(color: Colors.grey.withOpacity(0.2),),

              const SizedBox(height: 20),

              /// MEANING
              Text(
                widget.meaning,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "← Kéo trái (chưa nhớ)",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Kéo phải (đã nhớ) →",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
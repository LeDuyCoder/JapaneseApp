import 'package:flutter/material.dart';

class HorizontalCardScroller extends StatefulWidget {
  final List<Widget> children;

  const HorizontalCardScroller({
    super.key,
    required this.children,
  });

  @override
  State<HorizontalCardScroller> createState() =>
      _HorizontalCardScrollerState();
}

class _HorizontalCardScrollerState
    extends State<HorizontalCardScroller> {
  final PageController _pageController = PageController(
    viewportFraction: 0.94,
  );

  double currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 440,
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.children.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final difference = currentPage - index;

              final scale = (1 - (difference.abs() * 0.08))
                  .clamp(0.9, 1.0);

              final opacity = (1 - (difference.abs() * 0.2))
                  .clamp(0.7, 1.0);

              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                tween: Tween<double>(
                  begin: scale,
                  end: scale,
                ),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: child,
                      ),
                    ),
                  );
                },
                child: widget.children[index],
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.children.length,
                (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: currentPage.round() == i ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: currentPage.round() == i
                    ? Colors.red
                    : Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        )
      ],
    );
  }
}
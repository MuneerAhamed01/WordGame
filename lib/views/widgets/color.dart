import 'package:flutter/material.dart';

class ColorPopUpContainer extends StatefulWidget {
  final Color color;
  final double size;
  final Widget child;
  final Duration duration;

  const ColorPopUpContainer({
    super.key,
    required this.color,
    this.size = 100,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  _ColorPopUpContainerState createState() => _ColorPopUpContainerState();
}

class _ColorPopUpContainerState extends State<ColorPopUpContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipOval(
          child: Container(
            width: widget.size,
            height: widget.size,
            color: Colors.transparent,
            child: Center(
              child: SizedBox(
                width: widget.size * _animation.value,
                height: widget.size * _animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

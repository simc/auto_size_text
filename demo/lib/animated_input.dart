import 'package:flutter/material.dart';

typedef InputBuilder = Widget Function(String input);

class AnimatedInput extends StatefulWidget {
  final String text;
  final InputBuilder builder;

  AnimatedInput({required this.text, required this.builder});

  @override
  _AnimatedInputState createState() => _AnimatedInputState();
}

class _AnimatedInputState extends State<AnimatedInput>
    with SingleTickerProviderStateMixin {
  String _input = '';

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 80),
      vsync: this,
    );

    final number = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_controller);

    number.addListener(() {
      setState(() {
        _input = widget.text.substring(0, number.value);
      });
    });

    number.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) _controller.forward(from: 0);
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_input);
  }
}


import 'package:flutter/material.dart';

class HoverOpacityWidget extends StatefulWidget {
  const HoverOpacityWidget({super.key, this.onTap, required this.child, padding}) : padding = padding ?? 0;

  final void Function()? onTap;
  final Widget child;
  final double padding;

  @override
  State<HoverOpacityWidget> createState() => _HoverOpacityWidgetState();
}

class _HoverOpacityWidgetState extends State<HoverOpacityWidget> {
  bool isHovered = false;
  double opacity = 1;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
          opacity = 0.5;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
          opacity = 1;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(widget.padding),
          child: AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(milliseconds: 100),
            child: widget.child,
          ),
        )
      )
    );
  }
}
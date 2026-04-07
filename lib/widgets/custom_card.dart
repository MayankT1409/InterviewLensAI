import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withValues(alpha: 0.05),
             blurRadius: 24,
             spreadRadius: 2,
             offset: const Offset(0, 10),
          ),
          BoxShadow(
             color: Colors.black.withValues(alpha: 0.02),
             blurRadius: 8,
             offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: onTap != null 
            ? InkWell(
                onTap: onTap,
                highlightColor: Colors.black.withValues(alpha: 0.02),
                splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(24.0),
                  child: child,
                ),
              )
            : Padding(
                padding: padding ?? const EdgeInsets.all(24.0),
                child: child,
              ),
        ),
      ),
    );
  }
}

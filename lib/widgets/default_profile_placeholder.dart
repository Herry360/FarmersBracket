import 'package:flutter/material.dart';

class DefaultProfilePlaceholder extends StatelessWidget {
  final double size;
  const DefaultProfilePlaceholder({Key? key, this.size = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.grey[300],
      child: Icon(Icons.person, size: size * 0.8, color: Colors.grey[600]),
    );
  }
}

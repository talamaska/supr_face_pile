import 'package:flutter/material.dart';

import 'pile_user.dart';

class AvatarCircle extends StatefulWidget {
  const AvatarCircle({
    Key? key,
    required this.user,
    this.size = 48.0,
    required this.nameLabelColor,
    required this.backgroundColor,
  }) : super(key: key);

  final PileUser user;
  final double size;
  final Color nameLabelColor;
  final Color backgroundColor;

  @override
  State<AvatarCircle> createState() => _AvatarCircleState();
}

class _AvatarCircleState extends State<AvatarCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              widget.user.firstName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.nameLabelColor,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Image.network(widget.user.avatarUrl,
                width: widget.size,
                height: widget.size, loadingBuilder: (BuildContext context,
                    Widget child, ImageChunkEvent? loadingProgress) {
              debugPrint(loadingProgress.toString());
              if (loadingProgress == null) return child;
              return Container(
                padding: const EdgeInsets.all(15.0),
                child: const CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

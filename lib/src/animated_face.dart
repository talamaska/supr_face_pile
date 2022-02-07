import 'package:flutter/widgets.dart';

import 'avatar_circle.dart';
import 'pile_user.dart';

class AnimatedAvatarCircle extends StatefulWidget {
  const AnimatedAvatarCircle({
    Key? key,
    required this.user,
    required this.faceSize,
    required this.showFace,
    required this.onDisappear,
  }) : super(key: key);

  final PileUser user;
  final double faceSize;
  final bool showFace;
  final VoidCallback onDisappear;

  @override
  _AnimatedAvatarCircleState createState() => _AnimatedAvatarCircleState();
}

class _AnimatedAvatarCircleState extends State<AnimatedAvatarCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          widget.onDisappear();
        }
      });
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _syncScaleAnimationWithWidget();
  }

  @override
  void didUpdateWidget(AnimatedAvatarCircle oldWidget) {
    super.didUpdateWidget(oldWidget);

    _syncScaleAnimationWithWidget();
  }

  void _syncScaleAnimationWithWidget() {
    if (widget.showFace &&
        !_scaleController.isCompleted &&
        _scaleController.status != AnimationStatus.forward) {
      _scaleController.forward();
    } else if (!widget.showFace &&
        !_scaleController.isDismissed &&
        _scaleController.status != AnimationStatus.reverse) {
      _scaleController.reverse();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.faceSize,
      height: widget.faceSize,
      child: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AvatarCircle(
                user: widget.user,
                size: widget.faceSize,
                nameLabelColor: const Color(0xFF222222),
                backgroundColor: const Color(0xFF888888),
              ),
            );
          },
        ),
      ),
    );
  }
}

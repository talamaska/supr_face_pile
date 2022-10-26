import 'package:flutter/widgets.dart';

import 'animated_face.dart';
import 'pile_user.dart';

class SuprFacePile extends StatefulWidget {
  const SuprFacePile({
    Key? key,
    required this.users,
    this.faceSize = 48.0,
    required this.facePercentOverlap,
  }) : super(key: key);

  final List<PileUser> users;
  final double faceSize;
  final double facePercentOverlap;

  @override
  State<SuprFacePile> createState() => _SuprFacePileState();
}

class _SuprFacePileState extends State<SuprFacePile> {
  final List<PileUser> _visibleUsers = <PileUser>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _syncUsersWithPile();
    });
  }

  @override
  void didUpdateWidget(SuprFacePile oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _syncUsersWithPile();
    });
  }

  void _syncUsersWithPile() {
    setState(() {
      final Iterable<PileUser> newUsers = widget.users.where(
        (PileUser user) => _visibleUsers
            .where((PileUser visibleUser) => visibleUser == user)
            .isEmpty,
      );

      for (final PileUser newUser in newUsers) {
        _visibleUsers.add(newUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final int facesCount = _visibleUsers.length;
      double facePercentVisible = 1.0 - widget.facePercentOverlap;

      final double maxIntrinsicWidth = facesCount > 1
          ? (1 + (facePercentVisible * (facesCount - 1))) * widget.faceSize
          : widget.faceSize;

      late double leftOffset;
      if (maxIntrinsicWidth > constraints.maxWidth) {
        leftOffset = 0;
        facePercentVisible =
            ((constraints.maxWidth / widget.faceSize) - 1) / (facesCount - 1);
      } else {
        leftOffset = (constraints.maxWidth - maxIntrinsicWidth) / 2;
      }

      return SizedBox(
        height: widget.faceSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < facesCount; i += 1)
              AnimatedPositioned(
                key: ValueKey<String>(_visibleUsers[i].id),
                top: 0,
                height: widget.faceSize,
                left: leftOffset + (i * facePercentVisible * widget.faceSize),
                width: widget.faceSize,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: AnimatedAvatarCircle(
                  user: _visibleUsers[i],
                  showFace: widget.users.contains(_visibleUsers[i]),
                  faceSize: widget.faceSize,
                  onDisappear: () {
                    setState(() {
                      _visibleUsers.removeAt(i);
                    });
                  },
                ),
              ),
          ],
        ),
      );
    });
  }
}

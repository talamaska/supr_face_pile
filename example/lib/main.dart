import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_random_user/flutter_random_user.dart';
import 'package:supr_face_pile/supr_face_pile.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const SuprFacePileApp());
}

class SuprFacePileApp extends StatelessWidget {
  const SuprFacePileApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supr Face Pile Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SuprFacePileDemoPage(),
    );
  }
}

class SuprFacePileDemoPage extends StatefulWidget {
  const SuprFacePileDemoPage({Key? key}) : super(key: key);

  @override
  State<SuprFacePileDemoPage> createState() => _SuprFacePileDemoPageState();
}

class _SuprFacePileDemoPageState extends State<SuprFacePileDemoPage> {
  final Uuid uuid = const Uuid();

  final List<String> sprites = [
    'male',
    'female',
  ];

  late List<PileUser> _availableUsers;
  final List<PileUser> _facePileUsers = <PileUser>[];

  @override
  void initState() {
    super.initState();

    _populateFakeUsers();
  }

  Future<void> _populateFakeUsers() async {
    final List<RandomUser> randomUsers =
        userGenerator(max: 20, loremIpsumParagraphs: 1, loremIpsumWords: 10);

    _availableUsers = randomUsers
        .map((RandomUser randomUser) => PileUser(
              id: uuid.v4(),
              firstName: randomUser.firstName,
              lastName: randomUser.lastName,
              avatarUrl: randomUser.thumbNail,
            ))
        .toList();
  }

  void addUser() {
    if (_availableUsers.isNotEmpty) {
      final PileUser user = _availableUsers.removeLast();
      setState(() {
        _facePileUsers.add(user);
      });
    }
  }

  void subtractUser() {
    if (_facePileUsers.isNotEmpty) {
      final int randomIndex = Random().nextInt(_facePileUsers.length);
      setState(() {
        final PileUser user = _facePileUsers.removeAt(randomIndex);
        _availableUsers.insert(0, user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: DecoratedBox(
      //     decoration: BoxDecoration(border: Border.all()),
      //     child: ConstrainedBox(
      //       constraints: const BoxConstraints(maxWidth: 200),
      //       child: SuprFacePile(
      //         users: _facePileUsers,
      //         facePercentOverlap: 0.1,
      //       ),
      //     ),
      //   ),
      // ),
      body: FutureBuilder<bool>(
          future: Future<bool>.value(true),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return FutureBuilderResponse<bool>(
              dataSnapshot: snapshot,
              builder:
                  (BuildContext context, AsyncSnapshot<bool> dataSnapshot) {
                return Center(
                  child: Text('data is ${dataSnapshot.data.toString()}'),
                );
              },
            );
          }),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: addUser,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: subtractUser,
            child: const Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}

typedef FutureBuilderResponseBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> dataSnapshot);

class FutureBuilderResponse<T> extends StatelessWidget {
  final AsyncSnapshot<T> dataSnapshot;
  final FutureBuilderResponseBuilder<T> builder;

  const FutureBuilderResponse({
    Key? key,
    required this.dataSnapshot,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dataSnapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (dataSnapshot.error != null) {
        // ...
        // Do error handling stuff
        return const Center(
          child: Text('An error occurred!'),
        );
      } else {
        return builder(context, dataSnapshot);
      }
    }
  }
}

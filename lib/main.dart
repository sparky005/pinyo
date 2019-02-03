import 'package:flutter/material.dart';
import 'package:pinyo/src/pinyo_bloc.dart';
import 'package:pinyo/src/routes/homepage.dart';

void main() {
  final pinyoBloc = PinyoBloc();
  runApp(MyApp(bloc: pinyoBloc));
}

class MyApp extends StatelessWidget {
  final PinyoBloc bloc;

  MyApp({
    Key key,
    this.bloc,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinyo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Pinyo', bloc: bloc),
    );
  }
}

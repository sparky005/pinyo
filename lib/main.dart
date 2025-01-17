import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pinyo/src/pinyo_bloc.dart';
import 'package:pinyo/src/widgets/postlist.dart';
import 'package:pinyo/src/widgets/postsearch.dart';
import 'package:pinyo/src/widgets/progressbar.dart';

void main() {
  final pinyoBloc  = PinyoBloc();
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

class MyHomePage extends StatefulWidget {
  final PinyoBloc bloc;
  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: ProgressBar(widget.bloc.isLoading),
          ),
        title:
            StreamBuilder<String>(
              stream: widget.bloc.selectedTag,
              initialData: "",
              builder: (context, snapshot) {
                if (snapshot.data != "") {
                  return Text(snapshot.data);
                }
                return Text(widget.title);
              }
            ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => widget.bloc.currentTag.add(""),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: PostSearch(bloc: widget.bloc),)
          ),
        ],
      ),
      body: PostList(bloc: widget.bloc),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet(context: context,
                builder: (BuildContext context) {
                  return StreamBuilder<UnmodifiableListView<String>>(
                    stream: widget.bloc.tags,
                    initialData: UnmodifiableListView<String>([]),
                    builder: (context, snapshot) => _buildTagList(context, snapshot),
                  );
                });
              }
            ),
          ],
        ),
    ),
    );
  }



  Widget _buildTagList(BuildContext context, AsyncSnapshot snapshot) {
    List<String> tags = snapshot.data;
    return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildTagItem(tags[index]);
      },
    );
  }
  Widget _buildTagItem(String tag) {
    return Padding(
      key: Key(tag),
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(tag ?? '[null]'),
          ),
            onTap: () {
              widget.bloc.currentTag.add(tag);
            }
      ),
    );
  }


}
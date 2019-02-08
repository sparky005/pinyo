import 'package:flutter/material.dart';

import 'dart:collection';
import 'package:pinyo/src/pinyo_bloc.dart';
import 'package:pinyo/src/routes/editpage.dart';
import 'package:pinyo/src/widgets/postlist.dart';
import 'package:pinyo/src/widgets/postsearch.dart';
import 'package:pinyo/src/widgets/progressbar.dart';

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
        title: StreamBuilder<String>(
          stream: widget.bloc.selectedTag,
          initialData: "",
          builder: (context, snapshot) {
            if (snapshot.data != "") {
              return Text(snapshot.data);
            }
            return Text(widget.title);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => widget.bloc.currentTag.add(""),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
                  context: context,
                  delegate: PostSearch(bloc: widget.bloc),
                ),
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
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StreamBuilder<UnmodifiableListView<String>>(
                      stream: widget.bloc.tags,
                      initialData: UnmodifiableListView<String>([]),
                      builder: (context, snapshot) =>
                          _buildTagList(context, snapshot),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditPage()),
        );
      }),
    );
  }

  Widget _buildTagList(BuildContext context, AsyncSnapshot snapshot) {
    List<String> tags = snapshot.data;
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: tags.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildTagItem(tags[index], index);
      },
    );
  }

  Widget _buildTagItem(String tag, int index) {
    if (index == 0) return Icon(Icons.menu);

    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(tag ?? '[null]'),
      ),
      onTap: () {
        widget.bloc.currentTag.add(tag);
      },
    );
  }
}

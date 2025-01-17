import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pinyo/src/pinyo_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pinyo/src/models/post.dart';
class PostList extends StatelessWidget {
  final PinyoBloc bloc;
  final String query;
  // TODO: Maybe move the query to the bloc and let it handle the list filtering?

  PostList({Key key, this.bloc, this.query}) : super(key: key);

  Future<Null> _handleRefresh() {
    bloc.refresh.add(true);
    return Future.value();
  }

  Widget build(BuildContext context) {
      return StreamBuilder<UnmodifiableListView<Post>>(
        stream: bloc.posts,
        initialData: UnmodifiableListView<Post>([]),
        builder: (context, snapshot) => _buildList(context, snapshot),
      );
  }

    Widget _buildList(BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
      List<Post> posts;
      if (query == null) {
        posts = snapshot.data;
      } else {
        posts = snapshot.data.where((a) => a.description.toLowerCase().contains(query.toLowerCase())).toList();
      }
      return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItem(context, posts[index]);
          },
        ),
      );
    }


  Widget _buildItem(BuildContext context, Post post) {
    // TODO: wrap this in column, display tags below listtile
    return Padding(
      key: Key(post.hash),
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(post.description ?? '[null]'),
        ),
        subtitle: Text(post.extended),
        trailing: post.shared == "no" ? Icon(Icons.lock) : null,
        onTap: () async {
          // await the future!
          // needed because canLaunch returns a future
          // and "if" statements are syncronous
          if (await canLaunch(post.href)) {
            launch(post.href);
          }
        },
        onLongPress: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Not yet implemented'),
          ));
        }
      ),
    );
  }
}
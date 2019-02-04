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
      posts = snapshot.data
          .where((a) => (a.description.toLowerCase() +
                  a.extended.toLowerCase() +
                  a.tags.toLowerCase())
              .contains(query.toLowerCase()))
          .toList();
    }
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        padding: EdgeInsets.all(16.0),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(context, posts[index], index);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, Post post, int index) {
    // TODO: wrap this in column, display tags below listtile

    return ListTile(
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
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pinyo/src/pinyo_bloc.dart';
import 'package:pinyo/src/widgets/postlist.dart';

class PostSearch extends SearchDelegate {
  final PinyoBloc bloc;
  PostSearch({Key key, this.bloc}) : super();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return PostList(bloc: bloc, query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return PostList(bloc: bloc, query: query);
  }
}

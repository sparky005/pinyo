import 'dart:async';
import 'dart:collection';

import 'package:pinyo/src/post.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

enum PostsType {
  all,
  python,
}

class PinyoBloc {
  final token = "sparky_005:3E0DC4EC2FF41897ED27";

  // create streamcontroller
  final _postsTypeController = StreamController<PostsType>();

  var _posts = <Post>[];

  // getter for postsType gets me the sink on the stream controller
  Sink<PostsType> get postsType => _postsTypeController.sink;

  Stream<UnmodifiableListView<Post>> get posts => _postsSubject.stream;

  // behavior subject is just a stream that
  // will always display some initial data
  final _postsSubject = BehaviorSubject<UnmodifiableListView<Post>>();

  // constructor
  PinyoBloc() {
    _updatePostsListView(PostsType.all);

    _postsTypeController.stream.listen((postsType) {
      if (postsType == PostsType.all) {
        _updatePostsListView(PostsType.all);
      } else {
        _updatePostsListView(PostsType.python);
      }
    });
  }

  _updatePostsListView(PostsType type) {
    _updatePosts(type).then((_) {
      _postsSubject.add(UnmodifiableListView(_posts));
    });
  }

  Future<Null> _updatePosts(PostsType type) async {
    var posts;
    if (type == PostsType.all) {
      posts = await _getPosts(token);
    } else {
      posts = await _getTaggedPosts(token, 'python');
    }
    _posts = posts;
  }

  Future<List<Post>> _getPosts(String token) async {
    final postsUrl = 'https://api.pinboard.in/v1/posts/all?auth_token=$token&format=json';
    final postsRes = await http.get(postsUrl);
    if (postsRes.statusCode == 200) {
      return parseAllPosts(postsRes.body);
    }
  }

  Future<List<Post>> _getTaggedPosts(String token, String tag) async {
    // get all posts matching a single tag
    final postsUrl = 'https://api.pinboard.in/v1/posts/all?auth_token=$token&format=json&tag=$tag';
    final postsRes = await http.get(postsUrl);
    if (postsRes.statusCode == 200) {
      return parseAllPosts(postsRes.body);
    }
  }
}

import 'dart:async';
import 'dart:collection';

import 'package:pinyo/src/post.dart';
import 'package:http/http.dart' as http;
import 'package:pinyo/src/tag_map.dart';
import 'package:rxdart/rxdart.dart';


class PinyoBloc {
  final token = "sparky_005:3E0DC4EC2FF41897ED27";

  // create streamcontroller
  final _currentTagController = StreamController<String>();

  var _posts = <Post>[];
  var _tags = <String>[];

  // getter for postsType gets me the sink on the stream controller
  Sink<String> get currentTag => _currentTagController.sink;

  Stream<UnmodifiableListView<Post>> get posts => _postsSubject.stream;
  Stream<UnmodifiableListView<String>> get tags => _tagsSubject.stream;

  // behavior subject is just a streamcontroller that
  // will always display some initial data
  final _postsSubject = BehaviorSubject<UnmodifiableListView<Post>>();
  final _tagsSubject = BehaviorSubject<UnmodifiableListView<String>>();

  // constructor
  PinyoBloc() {
    _updatePostsListView();
    _updateTagsListView();

    _currentTagController.stream.listen((currentTag) {
        _updatePostsListView(tag: currentTag);
    });
  }

  _updatePostsListView({String tag = ""}) {
    _updatePosts(tag).then((_) {
      _postsSubject.add(UnmodifiableListView(_posts));
    });
  }

  Future<Null> _updatePosts(tag) async {
    var posts;
     posts = await _getPosts(token, {'tag': tag});
    _posts = posts;
  }

  Future<List<Post>> _getPosts(String token, Map<String, String> queryParams) async {
    queryParams['auth_token'] = token;
    queryParams['format'] = 'json';
    final postsUrl = Uri.https(
        'api.pinboard.in', '/v1/posts/all', queryParams);
    final postsRes = await http.get(postsUrl);
    if (postsRes.statusCode == 200) {
      return parseAllPosts(postsRes.body);
    }
  }

  _updateTagsListView() {
    _updateTags().then((_) {
      _tagsSubject.add(UnmodifiableListView(_tags));
    });
  }

  Future<Null> _updateTags() async {
    var tags;
    tags = await _getTags(token);
    _tags = tags.tags.keys.toList();
  }

  Future<TagMap> _getTags(String token) async {
    final queryParams = {'auth_token': token, 'format': 'json'};
    final url = Uri.https(
        'api.pinboard.in', '/v1/tags/get', queryParams
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return parseTags(res.body);
    }
  }
}

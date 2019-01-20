import 'dart:async';
import 'dart:collection';

import 'package:pinyo/src/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:pinyo/src/models/tag_map.dart';
import 'package:rxdart/rxdart.dart';


class PinyoBloc {
  // TODO: remove this hard-coded token when i implement login flow
  final token = "sparky_005:3E0DC4EC2FF41897ED27";

  var _posts = <Post>[];
  var _tags = <String>[];
  String _currentTag;

  // stream controllers
  final _postsSubject = BehaviorSubject<UnmodifiableListView<Post>>();
  final _tagsSubject = BehaviorSubject<UnmodifiableListView<String>>();
  final _refreshRequestedSubject = BehaviorSubject<bool>();
  final _currentTagController = StreamController<String>.broadcast();
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  // getters for sinks
  Sink<String> get currentTag => _currentTagController.sink;
  Sink<bool> get refresh => _refreshRequestedSubject.sink;

  // getters for streams
  Stream<UnmodifiableListView<Post>> get posts => _postsSubject.stream;
  Stream<UnmodifiableListView<String>> get tags => _tagsSubject.stream;
  Stream<String> get selectedTag => _currentTagController.stream;
  Stream<bool> get isLoading => _isLoadingSubject.stream;


  // constructor
  PinyoBloc() {
    _updatePostsListView();
    _updateTagsListView();

    _currentTagController.stream.listen((currentTag) {
        _currentTag = currentTag;
        _updatePostsListView(tag: currentTag);
    });
    _refreshRequestedSubject.stream.listen((refresh) {
      if(refresh) {
        _currentTagController.sink.add(_currentTag);
      _refreshRequestedSubject.sink.add(false);
      }
    });
  }

  _updatePostsListView({String tag = ""}) async {
    _isLoadingSubject.add(true);
    await _updatePosts(tag);
    _postsSubject.add(UnmodifiableListView(_posts));
    _isLoadingSubject.add(false);
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

  dispose() {
    // called when widget is removed from tree
    // here we close all our streams
    _currentTagController.close();
    _isLoadingSubject.close();
    _postsSubject.close();
    _refreshRequestedSubject.close();
    _tagsSubject.close();
  }
}

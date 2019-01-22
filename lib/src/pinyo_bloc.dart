import 'dart:async';
import 'dart:collection';

import 'package:pinyo/src/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:pinyo/src/models/tag_map.dart';
import 'package:pinyo/src/utils/dbprovider.dart';
import 'package:rxdart/rxdart.dart';


class PinyoBloc {
  // TODO: remove this hard-coded token when i implement login flow
  final token = "sparky_005:3E0DC4EC2FF41897ED27";

  var _posts = <Post>[];
  var _tags = <String>[];

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
    _getAllStoredPosts();
    _updateTagsListView();

    _currentTagController.stream.listen((currentTag) {
      _updatePostView(tag: currentTag);
    });

    _refreshRequestedSubject.stream.listen((refresh) {
      if(refresh) {
        _fetchAndUpdatePosts();
        //_currentTagController.sink.add(_currentTag);
        _refreshRequestedSubject.sink.add(false);
      }
    });
  }

  _getAllStoredPosts() async {
    _posts = await DBProvider.db.getAllPosts();
    _postsSubject.add(UnmodifiableListView<Post>(_posts));
  }

  _updateDatabase(List<Post> posts, List<String> tags) {
    posts.forEach((post) => DBProvider.db.checkAndInsert(post));
    tags.forEach((tag) => DBProvider.db.checkAndInsertTag(tag));
  }

  _fetchAndUpdatePosts() async {
    _isLoadingSubject.add(true);
    await _updatePosts();
    await _updateTags();
    _updateDatabase(_posts, _tags);
    _postsSubject.add(UnmodifiableListView(_posts));
    _tagsSubject.add(UnmodifiableListView(_tags));
    _isLoadingSubject.add(false);
  }

  Future<Null> _updatePosts() async {
    var posts;
    posts = await _fetchPosts(token, {'tag': ""});
    _posts = posts;
  }

  Future<List<Post>> _fetchPosts(String token, Map<String, String> queryParams) async {
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
    tags = await _fetchTags(token);
    // TODO: actually keep the tag map, not just the keys
    _tags = tags.tags.keys.toList();
  }

  Future<TagMap> _fetchTags(String token) async {
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
    // this actually gets called from the widget
    _currentTagController.close();
    _isLoadingSubject.close();
    _postsSubject.close();
    _refreshRequestedSubject.close();
    _tagsSubject.close();
  }

  void _updatePostView({String tag = ""}) async {
    _posts = await DBProvider.db.getPostsByTag(tag);
    _postsSubject.add(UnmodifiableListView<Post>(_posts));
  }
}

import 'package:http/http.dart' as http;
import 'package:pinyo/src/models/post.dart';
import 'package:pinyo/src/models/tag_map.dart';
import 'dart:convert' as json;

class PinboardAPI {

  PinboardAPI._();
  static final PinboardAPI api = PinboardAPI._();

  Future<List<Post>> fetchPosts(
      String token, Map<String, String> queryParams, List<Post> _posts) async {
    queryParams['auth_token'] = token;
    queryParams['format'] = 'json';
    final postsUrl = Uri.https('api.pinboard.in', '/v1/posts/all', queryParams);
    try {
      final postsRes = await http.get(postsUrl);
      if (postsRes.statusCode == 200) {
        return parseAllPosts(postsRes.body);
      }
    } catch (SocketException) {
      print("couldn't connect");
    }
    return _posts;
  }

  Future<int> addPost(String token, Post post) async {
    Map <String, String> queryParams = {};
    queryParams['auth_token'] = token;
    queryParams['format'] = 'json';
    queryParams.addAll(toJson(post).cast<String, String>());
    final postsUrl = Uri.https('api.pinboard.in', '/v1/posts/add', queryParams);
    try {
      final postsRes = await http.get(postsUrl);
      if (postsRes.statusCode == 200) {
        print(postsRes.body);
        final result = json.jsonDecode(postsRes.body);
        if (result['result_code'] == 'done') {
          return 0;
        }
      }
    } catch (SocketException) {
      print("couldn't connect");
    }
    return 1;
  }

  Future<TagMap> fetchTags(String token, List<String> _tags) async {
    final queryParams = {'auth_token': token, 'format': 'json'};
    final url = Uri.https('api.pinboard.in', '/v1/tags/get', queryParams);
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        return parseTags(res.body);
      }
    } catch (SocketError) {
      print("couldn't connect");
    }
    // this is definitely a hack
    var tags = {};
    _tags.forEach((i) => {tags[i]: "0"});
    return parseTags(tags.toString());
  }
}
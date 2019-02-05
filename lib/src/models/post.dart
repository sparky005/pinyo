import 'dart:convert' as json;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pinyo/src/utils/serializers.dart';

part 'post.g.dart';

abstract class Post implements Built<Post, PostBuilder> {
  static Serializer<Post> get serializer => _$postSerializer;

  String get href;

  @nullable
  String get url;

  @nullable
  int get id;

  @nullable
  String get description;

  @nullable
  String get extended;

  @nullable
  String get meta;

  @nullable
  String get hash;

  @nullable
  String get time;

  String get shared;

  String get toread;

  @nullable
  // this is a string, not a list
  // because the api actually provides (and accepts)
  // a single string of space-separated tags
  String get tags;

  Post._();

  factory Post([updates(PostBuilder b)]) = _$Post;
}

List<Post> parseAllPosts(String jsonStr) {
  //final parsed = json.jsonDecode(jsonStr);
  final List<dynamic> parsed = json.jsonDecode(jsonStr);
  return parsed
      .map<Post>(
          (map) => standardSerializers.deserializeWith(Post.serializer, map))
      .toList();
}

Post parsePost(Map<String, dynamic> post) {
  return standardSerializers.deserializeWith(Post.serializer, post);
}

Post parsePostFromJson(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  Post post = standardSerializers.deserializeWith(Post.serializer, parsed);
  return post;
}

Map<String, dynamic> toJson(Post post) {
  return standardSerializers.serializeWith(Post.serializer, post);
}
